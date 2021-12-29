import SwiftUI

struct AboutView: View {
    let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    var body: some View {
        VStack {
            Image(nsImage: NSImage(named: "AppIcon")!)
            Text("IssueBar").font(.title)
            Text("by Pavel Makhov").font(.caption)
            Text("version " + currentVersion).font(.footnote)
            Divider()
            Link("IssueBar on GitHub", destination: URL(string: "https://github.com/menubar-apps/IssueBar")!)
        }.padding()
    }
}

struct AboutTab_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
