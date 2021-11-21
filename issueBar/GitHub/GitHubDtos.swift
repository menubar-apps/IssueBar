//
//  GitHubDtos.swift
//  issueBar
//
//  Created by Pavel Makhov on 2021-11-10.
//

import Foundation

//{
//    "data": {
//        "search": {
//            "issueCount": 9,
//            "edges": [
//                {
//                    "node": {

struct GraphQlSearchResp: Codable {
    var data: Data
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Data: Codable {
    var search: Search

    enum CodingKeys: String, CodingKey {
        case search
    }
}

struct Search: Codable {
    var edges: [Edge]
    var issueCount: Int
    
    enum CodingKeys: String, CodingKey {
        case edges
        case issueCount
    }
}

struct Edges: Codable {
    var edge: [Edge]
    
    enum CodingKeys: String, CodingKey {
        case edge
    }
}

struct Edge: Codable {
    var node: GhIssue

    enum CodingKeys: String, CodingKey {
        case node
    }
}

struct GhIssue: Codable {
    var url: URL
    var updatedAt: Date
    var createdAt: Date
    var title: String
    var number: Int
    var repository: Repository
    var labels: LabelNodes
    
    enum CodingKeys: String, CodingKey {
        case url
        case updatedAt
        case createdAt
        case title
        case number
        case repository
        case labels
    }
}

struct Repository: Codable {
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct LabelNodes: Codable {
    var nodes: [Label]
    
    enum CodingKeys: String, CodingKey {
        case nodes
    }
}

struct Label: Codable {
    var name: String
    var color: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case color
    }
}

struct LatestRelease: Codable {
    
    var name: String
    var assets: [Asset]
    
    enum CodingKeys: String, CodingKey {
        case name
        case assets
    }
}

struct Asset: Codable {
    var name: String
    var browserDownloadUrl: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case browserDownloadUrl = "browser_download_url"
    }
}
