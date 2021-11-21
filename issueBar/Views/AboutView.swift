//
//  AboutView.swift
//  issueBar
//
//  Created by Pavel Makhov on 2021-11-20.
//

import SwiftUI

struct AboutView: View {
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon")!)
            Text("IssueBar").font(.title)
            Text("Version " + currentVersion).font(.footnote)
            Divider()
            Link("GitHub Repo", destination: URL(string: "https://github.com/menubar-apps-for-devs/IssueBar")!)
        }.padding()
    }
}

struct AboutTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
