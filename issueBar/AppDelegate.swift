//
//  AppDelegate.swift
//  issueBar
//
//  Created by Pavel Makhov on 2021-11-09.
//

import Cocoa
import Defaults
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @Default(.refreshRate) var refreshRate
    @Default(.showLabels) var showLabels

    let ghClient = GitHubClient()
    var statusBarItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let menu: NSMenu = NSMenu()
    
    var preferencesWindow: NSWindow!
    var aboutWindow: NSWindow!

    var timer: Timer? = nil

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.windowClosed), name: NSWindow.willCloseNotification, object: nil)

        guard let statusButton = statusBarItem.button else { return }
        statusButton.title = "hello"
        let icon = NSImage(named: "issue-opened")
        let size = NSSize(width: 16, height: 16)
        icon?.isTemplate = true
        icon?.size = size
        statusButton.image = icon
        
        statusBarItem.menu = menu
        
        timer = Timer.scheduledTimer(
                    timeInterval: Double(refreshRate * 60),
                    target: self,
                    selector: #selector(refreshMenu),
                    userInfo: nil,
                    repeats: true
                )
                timer?.fire()
        RunLoop.main.add(timer!, forMode: .common)
        NSApp.setActivationPolicy(.accessory)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    @objc
    func openLink(_ sender: NSMenuItem) {
        NSWorkspace.shared.open(sender.representedObject as! URL)
    }
}

extension AppDelegate {
    @objc
    func refreshMenu() {
        NSLog("Refreshing menu")

        self.menu.removeAllItems()
        ghClient.getMyIssues() { issues in
            
            let issuesByRepoName = Dictionary(grouping: issues, by: { $0.node.repository.name })
            let issuesByRepoNameSorted = issuesByRepoName.sorted {
                return $0.key.lowercased() < $1.key.lowercased()
            }

            for (repoName, issuess) in issuesByRepoNameSorted {
                self.menu.addItem(.separator())
                self.menu.addItem(withTitle: repoName, action: nil, keyEquivalent: "")

                for issue in issuess {
                    let issueItem = NSMenuItem(title: "", action: #selector(self.openLink), keyEquivalent: "")
                    let issueItemTitle = NSMutableAttributedString(string: issue.node.title)
                        .appendString(string: " #" + String(issue.node.number), color: "#888888")
                        .appendNewLine()
                        .appendString(string: "opened " + issue.node.createdAt.getElapsedInterval() + " ago", color: "#888888")
                    
                    if self.showLabels && !issue.node.labels.nodes.isEmpty {
                        issueItemTitle.appendString(string: "\n")
                        for label in issue.node.labels.nodes {
                            issueItemTitle.appendString(string: label.name + "   ", color: "#" + label.color)
                        }
                    }
                    
                    issueItem.attributedTitle = issueItemTitle
                    issueItem.representedObject = issue.node.url
                    self.menu.addItem(issueItem)
                }
            }
            self.menu.addItem(.separator())
            self.menu.addItem(withTitle: "Refresh", action: #selector(self.refreshMenu), keyEquivalent: "R")
            self.menu.addItem(.separator())
            self.menu.addItem(withTitle: "Preferences...", action: #selector(self.openPrefecencesWindow), keyEquivalent: ",")
            self.menu.addItem(withTitle: "Check for updates...", action: #selector(self.checkForUpdates), keyEquivalent: "")
            self.menu.addItem(withTitle: "About IssueBar", action: #selector(self.openAboutWindow), keyEquivalent: "")
            self.menu.addItem(withTitle: "Quit", action: #selector(self.quit), keyEquivalent: "q")
        }
    }
    
    @objc
    func openPrefecencesWindow(_: NSStatusBarButton?) {
        NSLog("Open preferences window")
        let contentView = PreferencesView()
        if preferencesWindow != nil {
            preferencesWindow.close()
        }
        preferencesWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.closable, .titled],
            backing: .buffered,
            defer: false
        )
        
        preferencesWindow.title = "Preferences"
        preferencesWindow.contentView = NSHostingView(rootView: contentView)
        preferencesWindow.makeKeyAndOrderFront(nil)
        // allow the preference window can be focused automatically when opened
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        let controller = NSWindowController(window: preferencesWindow)
        controller.showWindow(self)
        
        preferencesWindow.center()
        preferencesWindow.orderFrontRegardless()
    }
    
    @objc
    func openAboutWindow(_: NSStatusBarButton?) {
        NSLog("Open about window")
        let contentView = AboutView()
        if aboutWindow != nil {
            aboutWindow.close()
        }
        aboutWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 240, height: 340),
            styleMask: [.closable, .titled],
            backing: .buffered,
            defer: false
        )
        
        aboutWindow.title = "About"
        aboutWindow.contentView = NSHostingView(rootView: contentView)
        aboutWindow.makeKeyAndOrderFront(nil)
        // allow the preference window can be focused automatically when opened
        NSApplication.shared.activate(ignoringOtherApps: true)
        
        let controller = NSWindowController(window: aboutWindow)
        controller.showWindow(self)
        
        aboutWindow.center()
        aboutWindow.orderFrontRegardless()
    }
    
    @objc
    func checkForUpdates(_: NSStatusBarButton?) {
        let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        ghClient.getLatestRelease { latestRelease in
            let versionComparison = currentVersion.compare(latestRelease.name.replacingOccurrences(of: "v", with: ""), options: .numeric)
            if versionComparison == .orderedAscending {
                self.downloadNewVersionDialog(link: latestRelease.assets[0].browserDownloadUrl)
            } else {
                self.dialogWithText(text: "You have the latest version installed!")
            }
        }
    }
    
    func dialogWithText(text: String) -> Void {
        let alert = NSAlert()
        alert.messageText = text
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    func downloadNewVersionDialog(link: String) -> Void {
        let alert = NSAlert()
        alert.messageText = "New version is available!"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "Download")
        alert.addButton(withTitle: "Cancel")
        let pressedButton = alert.runModal()
        if (pressedButton == .alertFirstButtonReturn) {
            NSWorkspace.shared.open(URL(string: link)!)
        }
    }
    
    @objc
        func windowClosed(notification: NSNotification) {
            let window = notification.object as? NSWindow
            if let windowTitle = window?.title {
                if (windowTitle == "Preferences") {
                    timer = Timer.scheduledTimer(
                        timeInterval: Double(refreshRate * 60),
                        target: self,
                        selector: #selector(refreshMenu),
                        userInfo: nil,
                        repeats: true
                    )
                    timer?.fire()
                }
            }
        }
    
    @objc
    func quit(_: NSStatusBarButton) {
        NSLog("User click Quit")
        NSApplication.shared.terminate(self)
    }
}
