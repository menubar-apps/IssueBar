import Foundation
import Defaults

extension Defaults.Keys {
    static let githubUsername = Key<String>("githubUsername", default: "")
    static let githubToken = Key<String>("githubToken", default: "")
    
    static let showLabels = Key<Bool>("showLabels", default: true)
    static let issueType = Key<IssueType>("issueType", default: .created)
    static let refreshRate = Key<Int>("refreshRate", default: 5)
}

enum IssueType: String, DefaultsSerializable, CaseIterable, Equatable {
    case created = "created"
    case assigned = "assigned"
}
