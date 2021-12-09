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
    @Default(.issueType) var issueType
    @Default(.refreshRate) var refreshRate
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("GitHub Username:").frame(width: 120, alignment: .trailing)
                    TextField("", text: $githubUsername)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 200)
                }
                
                HStack {
                    Text("GitHub token:").frame(width: 120, alignment: .trailing)
                    SecureField("", text: $githubToken)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 360)
                }
            }
            Section{
                HStack {
                    Text("Show Issues:").frame(width: 120, alignment: .trailing)
                    Picker("", selection: $issueType) {
                        ForEach(IssueType.allCases, id: \.self) { value in
                            Text(value.rawValue).tag(value)
                        }
                    }.pickerStyle(MenuPickerStyle())
                     .frame(width: 120)
                }
                HStack {
                    Text("Refresh Rate:").frame(width: 120, alignment: .trailing)
                    Picker("", selection: $refreshRate) {
                        Text("1 minute").tag(1)
                        Text("5 minutes").tag(5)
                        Text("10 minutes").tag(10)
                        Text("15 minutes").tag(15)
                        Text("30 minutes").tag(30)
                    }.pickerStyle(MenuPickerStyle())
                     .frame(width: 120)
                }
                HStack {
                    Toggle(isOn: $showLabels) {
                        Text("Show Labels")
                    }
                }
            }
        }
        .padding()
    }
}
