import Foundation
import Defaults
import Alamofire
import UserNotifications

public class GitHubClient {
    
    @Default(.githubUsername) var githubUsername
    @Default(.githubToken) var githubToken
    @Default(.issueType) var issueType
    
    func getMyIssues(completion:@escaping (([Edge]) -> Void)) -> Void {
        
        if (githubUsername == "" || githubToken == "") {
            completion([Edge]())
        }
        
        let headers: HTTPHeaders = [
            .authorization(username: githubUsername, password: githubToken),
            .accept("application/json")
        ]
        
        let queryFilter = { () -> String in
            switch issueType {
            case .created: return "author"
            case .assigned: return "assignee"
            }
        }()
        
        let graphQlQuery = """
        {
          search(query: "is:open is:issue \(queryFilter):@me", type: ISSUE, first: 30) {
            issueCount
            edges {
              node {
                ... on Issue {
                  number
                  createdAt
                  updatedAt
                  title
                  url
                  body
                  labels(first: 5) {
                    nodes {
                        name
                        color
                    }
                  }
                  comments(last: 5) {
                      totalCount
                  }
                  repository {
                      name
                  }
                }
              }
            }
          }
        }
        """
        
        let parameters = [
            "query": graphQlQuery,
            "variables":[]
        ] as [String: Any]
        
        AF.request("https://api.github.com/graphql", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GraphQlSearchResp.self, decoder: GithubDecoder()) { response in
                switch response.result {
                case .success(let prs):
                    completion(prs.data.search.edges)
                case .failure(let error):
                    if response.response?.statusCode == 401 {
                        sendNotification(subtitle: "Unauthorized", body: "Token is not valid")
                    }
                    completion([Edge]())
                }
            }
    }
    
    //
    //    MARK: Check for updates
    //
    func getLatestRelease(completion:@escaping (((LatestRelease?) -> Void))) -> Void {
        let headers: HTTPHeaders = [
            .authorization(username: githubUsername, password: githubToken),
            .contentType("application/json"),
            .accept("application/json")
        ]
        AF.request("https://api.github.com/repos/menubar-apps-for-devs/IssueBar/releases/latest",
                   method: .get,
                   encoding: JSONEncoding.default,
                   headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LatestRelease.self) { response in
                switch response.result {
                case .success(let latestRelease):
                    completion(latestRelease)
                case .failure(let error):
                    completion(nil)
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        print("Failure Response: \(json)")
                    }
                    sendNotification(subtitle: "Something went wrong", body: "")
                }
            }
    }
}


class GithubDecoder: JSONDecoder {
    let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateDecodingStrategy = .iso8601
    }
}

func sendNotification(subtitle: String, body: String = "") {
  let content = UNMutableNotificationContent()
  content.title = "IssueBar"

  if body.count > 0 {
    content.body = body
  }
  
    content.subtitle = subtitle

  let uuidString = UUID().uuidString
  let request = UNNotificationRequest(
    identifier: uuidString,
    content: content, trigger: nil)

  let notificationCenter = UNUserNotificationCenter.current()
  notificationCenter.requestAuthorization(options: [.alert, .sound]) { _, _ in }
  notificationCenter.add(request)
}
