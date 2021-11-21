//
//  DefaultsExtensions.swift
//  issueBar
//
//  Created by Pavel Makhov on 2021-11-10.
//

import Foundation
import Defaults

extension Defaults.Keys {
    static let githubUsername = Key<String>("githubUsername", default: "")
    static let githubToken = Key<String>("githubToken", default: "")
    
    static let showLabels = Key<Bool>("showLabels", default: true)
    static let refreshRate = Key<Int>("refreshRate", default: 5)
}
