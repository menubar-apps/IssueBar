//
//  GeneralTab.swift
//  issueBar
//
//  Created by Pavel Makhov on 2021-11-14.
//

import SwiftUI
import Defaults

struct PreferencesView: View {
    
    @Default(.githubUsername) var githubUsername
    @Default(.githubToken) var githubToken
    @Default(.showLabels) var showLabels
    @Default(.refreshRate) var refreshRate
    
    var body: some View {
        Form {
            Section {
                HStack(alignment: .center) {
                    Text("GitHub Username:").frame(width: 120, alignment: .trailing)
                    TextField("", text: $githubUsername)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 340)
                }
                
                HStack(alignment: .center) {
                    Text("GitHub token:").frame(width: 120, alignment: .trailing)
                    SecureField("ghp...", text: $githubToken)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 340)
                }
                Divider()
                HStack(alignment: .center) {
                    Text("Refresh Rate:").frame(width: 120, alignment: .trailing)
                    Picker("", selection: $refreshRate, content: {
                        Text("1 minute").tag(1)
                        Text("5 minutes").tag(5)
                        Text("10 minutes").tag(10)
                        Text("15 minutes").tag(15)
                        Text("30 minutes").tag(30)
                    }).labelsHidden()
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 100)
                }
                HStack{
                    Text("Show Labels:").frame(width: 120, alignment: .trailing)
                    Toggle("", isOn: $showLabels).labelsHidden()
                }
            }
        }
        .padding()
        .frame(width: 500)
    }
}
