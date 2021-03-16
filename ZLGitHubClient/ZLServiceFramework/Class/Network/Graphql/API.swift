// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// The possible states of a pull request.
public enum PullRequestState: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// A pull request that is still open.
  case `open`
  /// A pull request that has been closed without being merged.
  case closed
  /// A pull request that has been closed by being merged.
  case merged
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "OPEN": self = .open
      case "CLOSED": self = .closed
      case "MERGED": self = .merged
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .open: return "OPEN"
      case .closed: return "CLOSED"
      case .merged: return "MERGED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PullRequestState, rhs: PullRequestState) -> Bool {
    switch (lhs, rhs) {
      case (.open, .open): return true
      case (.closed, .closed): return true
      case (.merged, .merged): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PullRequestState] {
    return [
      .open,
      .closed,
      .merged,
    ]
  }
}

/// The possible states of an issue.
public enum IssueState: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// An issue that is still open
  case `open`
  /// An issue that has been closed
  case closed
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "OPEN": self = .open
      case "CLOSED": self = .closed
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .open: return "OPEN"
      case .closed: return "CLOSED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: IssueState, rhs: IssueState) -> Bool {
    switch (lhs, rhs) {
      case (.open, .open): return true
      case (.closed, .closed): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [IssueState] {
    return [
      .open,
      .closed,
    ]
  }
}

public final class ViewerPullRequestQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query viewerPullRequest($state: [PullRequestState!], $after: String) {
      viewer {
        __typename
        pullRequests(
          states: $state
          orderBy: {field: CREATED_AT, direction: DESC}
          after: $after
          first: 20
        ) {
          __typename
          pageInfo {
            __typename
            endCursor
            hasNextPage
          }
          nodes {
            __typename
            title
            state
            number
            author {
              __typename
              login
            }
            url
            createdAt
            closedAt
            mergedAt
          }
        }
      }
    }
    """

  public let operationName: String = "viewerPullRequest"

  public var state: [PullRequestState]?
  public var after: String?

  public init(state: [PullRequestState]?, after: String? = nil) {
    self.state = state
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["state": state, "after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("pullRequests", arguments: ["states": GraphQLVariable("state"), "orderBy": ["field": "CREATED_AT", "direction": "DESC"], "after": GraphQLVariable("after"), "first": 20], type: .nonNull(.object(PullRequest.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(pullRequests: PullRequest) {
        self.init(unsafeResultMap: ["__typename": "User", "pullRequests": pullRequests.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of pull requests associated with this user.
      public var pullRequests: PullRequest {
        get {
          return PullRequest(unsafeResultMap: resultMap["pullRequests"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pullRequests")
        }
      }

      public struct PullRequest: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PullRequestConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(pageInfo: PageInfo, nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "PullRequestConnection", "pageInfo": pageInfo.resultMap, "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Information to aid in pagination.
        public var pageInfo: PageInfo {
          get {
            return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("endCursor", type: .scalar(String.self)),
              GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(endCursor: String? = nil, hasNextPage: Bool) {
            self.init(unsafeResultMap: ["__typename": "PageInfo", "endCursor": endCursor, "hasNextPage": hasNextPage])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? {
            get {
              return resultMap["endCursor"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endCursor")
            }
          }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool {
            get {
              return resultMap["hasNextPage"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "hasNextPage")
            }
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PullRequest"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("state", type: .nonNull(.scalar(PullRequestState.self))),
              GraphQLField("number", type: .nonNull(.scalar(Int.self))),
              GraphQLField("author", type: .object(Author.selections)),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("closedAt", type: .scalar(String.self)),
              GraphQLField("mergedAt", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(title: String, state: PullRequestState, number: Int, author: Author? = nil, url: String, createdAt: String, closedAt: String? = nil, mergedAt: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "PullRequest", "title": title, "state": state, "number": number, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "url": url, "createdAt": createdAt, "closedAt": closedAt, "mergedAt": mergedAt])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Identifies the pull request title.
          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          /// Identifies the state of the pull request.
          public var state: PullRequestState {
            get {
              return resultMap["state"]! as! PullRequestState
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
            }
          }

          /// Identifies the pull request number.
          public var number: Int {
            get {
              return resultMap["number"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "number")
            }
          }

          /// The actor who authored the comment.
          public var author: Author? {
            get {
              return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "author")
            }
          }

          /// The HTTP URL for this pull request.
          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          /// Identifies the date and time when the object was created.
          public var createdAt: String {
            get {
              return resultMap["createdAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Identifies the date and time when the object was closed.
          public var closedAt: String? {
            get {
              return resultMap["closedAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "closedAt")
            }
          }

          /// The date and time that the pull request was merged.
          public var mergedAt: String? {
            get {
              return resultMap["mergedAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "mergedAt")
            }
          }

          public struct Author: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("login", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public static func makeBot(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "Bot", "login": login])
            }

            public static func makeEnterpriseUserAccount(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
            }

            public static func makeMannequin(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "Mannequin", "login": login])
            }

            public static func makeOrganization(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "Organization", "login": login])
            }

            public static func makeUser(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "User", "login": login])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The username of the actor.
            public var login: String {
              get {
                return resultMap["login"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "login")
              }
            }
          }
        }
      }
    }
  }
}

public final class ViewerTopRepositoriesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query viewerTopRepositories($after: String) {
      viewer {
        __typename
        topRepositories(
          first: 10
          orderBy: {field: UPDATED_AT, direction: DESC}
          after: $after
        ) {
          __typename
          pageInfo {
            __typename
            endCursor
          }
          nodes {
            __typename
            name
            nameWithOwner
            isPrivate
            description
            forkCount
            stargazerCount
            owner {
              __typename
              login
              avatarUrl
            }
            primaryLanguage {
              __typename
              name
            }
            url
          }
        }
      }
    }
    """

  public let operationName: String = "viewerTopRepositories"

  public var after: String?

  public init(after: String? = nil) {
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("topRepositories", arguments: ["first": 10, "orderBy": ["field": "UPDATED_AT", "direction": "DESC"], "after": GraphQLVariable("after")], type: .nonNull(.object(TopRepository.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(topRepositories: TopRepository) {
        self.init(unsafeResultMap: ["__typename": "User", "topRepositories": topRepositories.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// Repositories the user has contributed to, ordered by contribution rank, plus repositories the user has created
      public var topRepositories: TopRepository {
        get {
          return TopRepository(unsafeResultMap: resultMap["topRepositories"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "topRepositories")
        }
      }

      public struct TopRepository: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["RepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(pageInfo: PageInfo, nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "pageInfo": pageInfo.resultMap, "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Information to aid in pagination.
        public var pageInfo: PageInfo {
          get {
            return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("endCursor", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(endCursor: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "PageInfo", "endCursor": endCursor])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? {
            get {
              return resultMap["endCursor"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endCursor")
            }
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Repository"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
              GraphQLField("isPrivate", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("forkCount", type: .nonNull(.scalar(Int.self))),
              GraphQLField("stargazerCount", type: .nonNull(.scalar(Int.self))),
              GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
              GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String, nameWithOwner: String, isPrivate: Bool, description: String? = nil, forkCount: Int, stargazerCount: Int, owner: Owner, primaryLanguage: PrimaryLanguage? = nil, url: String) {
            self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "isPrivate": isPrivate, "description": description, "forkCount": forkCount, "stargazerCount": stargazerCount, "owner": owner.resultMap, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> ResultMap in value.resultMap }, "url": url])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The name of the repository.
          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// The repository's name with owner.
          public var nameWithOwner: String {
            get {
              return resultMap["nameWithOwner"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "nameWithOwner")
            }
          }

          /// Identifies if the repository is private.
          public var isPrivate: Bool {
            get {
              return resultMap["isPrivate"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "isPrivate")
            }
          }

          /// The description of the repository.
          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }

          /// Returns how many forks there are of this repository in the whole network.
          public var forkCount: Int {
            get {
              return resultMap["forkCount"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "forkCount")
            }
          }

          /// Returns a count of how many stargazers there are on this object
          public var stargazerCount: Int {
            get {
              return resultMap["stargazerCount"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "stargazerCount")
            }
          }

          /// The User owner of the repository.
          public var owner: Owner {
            get {
              return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "owner")
            }
          }

          /// The primary language of the repository's code.
          public var primaryLanguage: PrimaryLanguage? {
            get {
              return (resultMap["primaryLanguage"] as? ResultMap).flatMap { PrimaryLanguage(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "primaryLanguage")
            }
          }

          /// The HTTP URL for this repository
          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          public struct Owner: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Organization", "User"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("login", type: .nonNull(.scalar(String.self))),
                GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public static func makeOrganization(login: String, avatarUrl: String) -> Owner {
              return Owner(unsafeResultMap: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl])
            }

            public static func makeUser(login: String, avatarUrl: String) -> Owner {
              return Owner(unsafeResultMap: ["__typename": "User", "login": login, "avatarUrl": avatarUrl])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The username used to login.
            public var login: String {
              get {
                return resultMap["login"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "login")
              }
            }

            /// A URL pointing to the owner's public avatar.
            public var avatarUrl: String {
              get {
                return resultMap["avatarUrl"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "avatarUrl")
              }
            }
          }

          public struct PrimaryLanguage: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Language"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String) {
              self.init(unsafeResultMap: ["__typename": "Language", "name": name])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the current language.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }
          }
        }
      }
    }
  }
}

public final class ViewerIssuesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query viewerIssues($assignee: String, $creator: String, $mentioned: String, $after: String) {
      viewer {
        __typename
        issues(
          after: $after
          orderBy: {field: UPDATED_AT, direction: DESC}
          first: 10
          filterBy: {createdBy: $creator, mentioned: $mentioned, assignee: $assignee}
        ) {
          __typename
          pageInfo {
            __typename
            hasNextPage
            endCursor
            startCursor
          }
          nodes {
            __typename
            number
            title
            body
            url
            state
            labels(first: 5, orderBy: {field: CREATED_AT, direction: DESC}) {
              __typename
              nodes {
                __typename
                color
                name
              }
            }
            author {
              __typename
              login
            }
            repository {
              __typename
              name
              nameWithOwner
            }
            createdAt
            updatedAt
            closedAt
          }
        }
      }
    }
    """

  public let operationName: String = "viewerIssues"

  public var assignee: String?
  public var creator: String?
  public var mentioned: String?
  public var after: String?

  public init(assignee: String? = nil, creator: String? = nil, mentioned: String? = nil, after: String? = nil) {
    self.assignee = assignee
    self.creator = creator
    self.mentioned = mentioned
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["assignee": assignee, "creator": creator, "mentioned": mentioned, "after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("issues", arguments: ["after": GraphQLVariable("after"), "orderBy": ["field": "UPDATED_AT", "direction": "DESC"], "first": 10, "filterBy": ["createdBy": GraphQLVariable("creator"), "mentioned": GraphQLVariable("mentioned"), "assignee": GraphQLVariable("assignee")]], type: .nonNull(.object(Issue.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(issues: Issue) {
        self.init(unsafeResultMap: ["__typename": "User", "issues": issues.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of issues associated with this user.
      public var issues: Issue {
        get {
          return Issue(unsafeResultMap: resultMap["issues"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "issues")
        }
      }

      public struct Issue: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["IssueConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(pageInfo: PageInfo, nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "IssueConnection", "pageInfo": pageInfo.resultMap, "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Information to aid in pagination.
        public var pageInfo: PageInfo {
          get {
            return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct PageInfo: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PageInfo"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("endCursor", type: .scalar(String.self)),
              GraphQLField("startCursor", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hasNextPage: Bool, endCursor: String? = nil, startCursor: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage, "endCursor": endCursor, "startCursor": startCursor])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool {
            get {
              return resultMap["hasNextPage"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "hasNextPage")
            }
          }

          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? {
            get {
              return resultMap["endCursor"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "endCursor")
            }
          }

          /// When paginating backwards, the cursor to continue.
          public var startCursor: String? {
            get {
              return resultMap["startCursor"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "startCursor")
            }
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Issue"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("number", type: .nonNull(.scalar(Int.self))),
              GraphQLField("title", type: .nonNull(.scalar(String.self))),
              GraphQLField("body", type: .nonNull(.scalar(String.self))),
              GraphQLField("url", type: .nonNull(.scalar(String.self))),
              GraphQLField("state", type: .nonNull(.scalar(IssueState.self))),
              GraphQLField("labels", arguments: ["first": 5, "orderBy": ["field": "CREATED_AT", "direction": "DESC"]], type: .object(Label.selections)),
              GraphQLField("author", type: .object(Author.selections)),
              GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
              GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("closedAt", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(number: Int, title: String, body: String, url: String, state: IssueState, labels: Label? = nil, author: Author? = nil, repository: Repository, createdAt: String, updatedAt: String, closedAt: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Issue", "number": number, "title": title, "body": body, "url": url, "state": state, "labels": labels.flatMap { (value: Label) -> ResultMap in value.resultMap }, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "repository": repository.resultMap, "createdAt": createdAt, "updatedAt": updatedAt, "closedAt": closedAt])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Identifies the issue number.
          public var number: Int {
            get {
              return resultMap["number"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "number")
            }
          }

          /// Identifies the issue title.
          public var title: String {
            get {
              return resultMap["title"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "title")
            }
          }

          /// Identifies the body of the issue.
          public var body: String {
            get {
              return resultMap["body"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "body")
            }
          }

          /// The HTTP URL for this issue
          public var url: String {
            get {
              return resultMap["url"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "url")
            }
          }

          /// Identifies the state of the issue.
          public var state: IssueState {
            get {
              return resultMap["state"]! as! IssueState
            }
            set {
              resultMap.updateValue(newValue, forKey: "state")
            }
          }

          /// A list of labels associated with the object.
          public var labels: Label? {
            get {
              return (resultMap["labels"] as? ResultMap).flatMap { Label(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "labels")
            }
          }

          /// The actor who authored the comment.
          public var author: Author? {
            get {
              return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "author")
            }
          }

          /// The repository associated with this node.
          public var repository: Repository {
            get {
              return Repository(unsafeResultMap: resultMap["repository"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "repository")
            }
          }

          /// Identifies the date and time when the object was created.
          public var createdAt: String {
            get {
              return resultMap["createdAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "createdAt")
            }
          }

          /// Identifies the date and time when the object was last updated.
          public var updatedAt: String {
            get {
              return resultMap["updatedAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "updatedAt")
            }
          }

          /// Identifies the date and time when the object was closed.
          public var closedAt: String? {
            get {
              return resultMap["closedAt"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "closedAt")
            }
          }

          public struct Label: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["LabelConnection"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("nodes", type: .list(.object(Node.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(nodes: [Node?]? = nil) {
              self.init(unsafeResultMap: ["__typename": "LabelConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// A list of nodes.
            public var nodes: [Node?]? {
              get {
                return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
              }
            }

            public struct Node: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Label"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("color", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(color: String, name: String) {
                self.init(unsafeResultMap: ["__typename": "Label", "color": color, "name": name])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the label color.
              public var color: String {
                get {
                  return resultMap["color"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "color")
                }
              }

              /// Identifies the label name.
              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }
            }
          }

          public struct Author: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("login", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public static func makeBot(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "Bot", "login": login])
            }

            public static func makeEnterpriseUserAccount(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
            }

            public static func makeMannequin(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "Mannequin", "login": login])
            }

            public static func makeOrganization(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "Organization", "login": login])
            }

            public static func makeUser(login: String) -> Author {
              return Author(unsafeResultMap: ["__typename": "User", "login": login])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The username of the actor.
            public var login: String {
              get {
                return resultMap["login"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "login")
              }
            }
          }

          public struct Repository: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Repository"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String, nameWithOwner: String) {
              self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the repository.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The repository's name with owner.
            public var nameWithOwner: String {
              get {
                return resultMap["nameWithOwner"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "nameWithOwner")
              }
            }
          }
        }
      }
    }
  }
}

public final class ViewerOrgsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query viewerOrgs {
      viewer {
        __typename
        organizations(first: 20) {
          __typename
          totalCount
          edges {
            __typename
            node {
              __typename
              login
              avatarUrl
              location
            }
          }
        }
      }
    }
    """

  public let operationName: String = "viewerOrgs"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("organizations", arguments: ["first": 20], type: .nonNull(.object(Organization.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(organizations: Organization) {
        self.init(unsafeResultMap: ["__typename": "User", "organizations": organizations.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of organizations the user belongs to.
      public var organizations: Organization {
        get {
          return Organization(unsafeResultMap: resultMap["organizations"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "organizations")
        }
      }

      public struct Organization: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OrganizationConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("edges", type: .list(.object(Edge.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int, edges: [Edge?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "OrganizationConnection", "totalCount": totalCount, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }

        /// A list of edges.
        public var edges: [Edge?]? {
          get {
            return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["OrganizationEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "OrganizationEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge.
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Organization"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("login", type: .nonNull(.scalar(String.self))),
                GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
                GraphQLField("location", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(login: String, avatarUrl: String, location: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl, "location": location])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The organization's login name.
            public var login: String {
              get {
                return resultMap["login"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "login")
              }
            }

            /// A URL pointing to the organization's public avatar.
            public var avatarUrl: String {
              get {
                return resultMap["avatarUrl"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "avatarUrl")
              }
            }

            /// The organization's public profile location.
            public var location: String? {
              get {
                return resultMap["location"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "location")
              }
            }
          }
        }
      }
    }
  }
}

public final class WorkboardInfoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query WorkboardInfo {
      viewer {
        __typename
        issues(first: 3, states: OPEN, orderBy: {field: UPDATED_AT, direction: DESC}) {
          __typename
          totalCount
          edges {
            __typename
            node {
              __typename
              title
              number
              createdAt
              author {
                __typename
                login
              }
            }
          }
        }
        pullRequests(first: 3, states: OPEN) {
          __typename
          totalCount
          edges {
            __typename
            node {
              __typename
              title
              number
              author {
                __typename
                login
              }
              createdAt
            }
          }
        }
        topRepositories(first: 3, orderBy: {field: UPDATED_AT, direction: DESC}) {
          __typename
          edges {
            __typename
            node {
              __typename
              nameWithOwner
            }
          }
        }
        bio
        websiteUrl
      }
    }
    """

  public let operationName: String = "WorkboardInfo"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("issues", arguments: ["first": 3, "states": "OPEN", "orderBy": ["field": "UPDATED_AT", "direction": "DESC"]], type: .nonNull(.object(Issue.selections))),
          GraphQLField("pullRequests", arguments: ["first": 3, "states": "OPEN"], type: .nonNull(.object(PullRequest.selections))),
          GraphQLField("topRepositories", arguments: ["first": 3, "orderBy": ["field": "UPDATED_AT", "direction": "DESC"]], type: .nonNull(.object(TopRepository.selections))),
          GraphQLField("bio", type: .scalar(String.self)),
          GraphQLField("websiteUrl", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(issues: Issue, pullRequests: PullRequest, topRepositories: TopRepository, bio: String? = nil, websiteUrl: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "User", "issues": issues.resultMap, "pullRequests": pullRequests.resultMap, "topRepositories": topRepositories.resultMap, "bio": bio, "websiteUrl": websiteUrl])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of issues associated with this user.
      public var issues: Issue {
        get {
          return Issue(unsafeResultMap: resultMap["issues"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "issues")
        }
      }

      /// A list of pull requests associated with this user.
      public var pullRequests: PullRequest {
        get {
          return PullRequest(unsafeResultMap: resultMap["pullRequests"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pullRequests")
        }
      }

      /// Repositories the user has contributed to, ordered by contribution rank, plus repositories the user has created
      public var topRepositories: TopRepository {
        get {
          return TopRepository(unsafeResultMap: resultMap["topRepositories"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "topRepositories")
        }
      }

      /// The user's public profile bio.
      public var bio: String? {
        get {
          return resultMap["bio"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bio")
        }
      }

      /// A URL pointing to the user's public website/blog.
      public var websiteUrl: String? {
        get {
          return resultMap["websiteUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "websiteUrl")
        }
      }

      public struct Issue: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["IssueConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("edges", type: .list(.object(Edge.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int, edges: [Edge?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "IssueConnection", "totalCount": totalCount, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }

        /// A list of edges.
        public var edges: [Edge?]? {
          get {
            return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["IssueEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "IssueEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge.
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Issue"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("number", type: .nonNull(.scalar(Int.self))),
                GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
                GraphQLField("author", type: .object(Author.selections)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(title: String, number: Int, createdAt: String, author: Author? = nil) {
              self.init(unsafeResultMap: ["__typename": "Issue", "title": title, "number": number, "createdAt": createdAt, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Identifies the issue title.
            public var title: String {
              get {
                return resultMap["title"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "title")
              }
            }

            /// Identifies the issue number.
            public var number: Int {
              get {
                return resultMap["number"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "number")
              }
            }

            /// Identifies the date and time when the object was created.
            public var createdAt: String {
              get {
                return resultMap["createdAt"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "createdAt")
              }
            }

            /// The actor who authored the comment.
            public var author: Author? {
              get {
                return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "author")
              }
            }

            public struct Author: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("login", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public static func makeBot(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "Bot", "login": login])
              }

              public static func makeEnterpriseUserAccount(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
              }

              public static func makeMannequin(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "Mannequin", "login": login])
              }

              public static func makeOrganization(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "Organization", "login": login])
              }

              public static func makeUser(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "User", "login": login])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The username of the actor.
              public var login: String {
                get {
                  return resultMap["login"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "login")
                }
              }
            }
          }
        }
      }

      public struct PullRequest: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PullRequestConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("edges", type: .list(.object(Edge.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int, edges: [Edge?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "PullRequestConnection", "totalCount": totalCount, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }

        /// A list of edges.
        public var edges: [Edge?]? {
          get {
            return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["PullRequestEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "PullRequestEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge.
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["PullRequest"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("title", type: .nonNull(.scalar(String.self))),
                GraphQLField("number", type: .nonNull(.scalar(Int.self))),
                GraphQLField("author", type: .object(Author.selections)),
                GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(title: String, number: Int, author: Author? = nil, createdAt: String) {
              self.init(unsafeResultMap: ["__typename": "PullRequest", "title": title, "number": number, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "createdAt": createdAt])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Identifies the pull request title.
            public var title: String {
              get {
                return resultMap["title"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "title")
              }
            }

            /// Identifies the pull request number.
            public var number: Int {
              get {
                return resultMap["number"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "number")
              }
            }

            /// The actor who authored the comment.
            public var author: Author? {
              get {
                return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "author")
              }
            }

            /// Identifies the date and time when the object was created.
            public var createdAt: String {
              get {
                return resultMap["createdAt"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "createdAt")
              }
            }

            public struct Author: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("login", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public static func makeBot(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "Bot", "login": login])
              }

              public static func makeEnterpriseUserAccount(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
              }

              public static func makeMannequin(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "Mannequin", "login": login])
              }

              public static func makeOrganization(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "Organization", "login": login])
              }

              public static func makeUser(login: String) -> Author {
                return Author(unsafeResultMap: ["__typename": "User", "login": login])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The username of the actor.
              public var login: String {
                get {
                  return resultMap["login"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "login")
                }
              }
            }
          }
        }
      }

      public struct TopRepository: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["RepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("edges", type: .list(.object(Edge.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(edges: [Edge?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of edges.
        public var edges: [Edge?]? {
          get {
            return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["RepositoryEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("node", type: .object(Node.selections)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(node: Node? = nil) {
            self.init(unsafeResultMap: ["__typename": "RepositoryEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The item at the end of the edge.
          public var node: Node? {
            get {
              return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Repository"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(nameWithOwner: String) {
              self.init(unsafeResultMap: ["__typename": "Repository", "nameWithOwner": nameWithOwner])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The repository's name with owner.
            public var nameWithOwner: String {
              get {
                return resultMap["nameWithOwner"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "nameWithOwner")
              }
            }
          }
        }
      }
    }
  }
}

public final class IssueInfoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query issueInfo($owner: String!, $name: String!, $number: Int!) {
      repository(owner: $owner, name: $name) {
        __typename
        nameWithOwner
        issue(number: $number) {
          __typename
          title
          number
          author {
            __typename
            login
            avatarUrl
          }
          bodyText
          bodyHTML
          state
          closed
          closedAt
          createdAt
          timelineItems(first: 100) {
            __typename
            totalCount
            nodes {
              __typename
              ... on IssueComment {
                id
                author {
                  __typename
                  login
                  avatarUrl
                }
                bodyText
                bodyHTML
                url
                lastEditedAt
                publishedAt
              }
              ... on AddedToProjectEvent {
                id
                actor {
                  __typename
                  login
                  avatarUrl
                }
                createdAt
              }
              ... on AssignedEvent {
                id
                actor {
                  __typename
                  login
                  avatarUrl
                }
                assignee {
                  __typename
                  ... on User {
                    login
                  }
                  ... on Bot {
                    login
                  }
                  ... on Mannequin {
                    login
                  }
                  ... on Organization {
                    login
                  }
                }
              }
              ... on ClosedEvent {
                actor {
                  __typename
                  login
                }
              }
              ... on ReopenedEvent {
                actor {
                  __typename
                  login
                }
              }
              ... on CommentDeletedEvent {
                actor {
                  __typename
                  login
                }
              }
              ... on ConnectedEvent {
                actor {
                  __typename
                  login
                }
                source {
                  __typename
                  ... on PullRequest {
                    repository {
                      __typename
                      nameWithOwner
                    }
                    number
                  }
                  ... on Issue {
                    repository {
                      __typename
                      nameWithOwner
                    }
                    number
                  }
                }
                subject {
                  __typename
                  ... on PullRequest {
                    repository {
                      __typename
                      nameWithOwner
                    }
                    number
                  }
                  ... on Issue {
                    repository {
                      __typename
                      nameWithOwner
                    }
                    number
                  }
                }
              }
              ... on ConvertedNoteToIssueEvent {
                actor {
                  __typename
                  login
                }
              }
              ... on ReferencedEvent {
                actor {
                  __typename
                  login
                }
                commit {
                  __typename
                  commitUrl
                  message
                }
              }
              ... on LabeledEvent {
                actor {
                  __typename
                  login
                }
                label {
                  __typename
                  color
                  name
                }
              }
              ... on UnlabeledEvent {
                actor {
                  __typename
                  login
                }
                label {
                  __typename
                  color
                  name
                }
              }
              ... on SubscribedEvent {
                actor {
                  __typename
                  login
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "issueInfo"

  public var owner: String
  public var name: String
  public var number: Int

  public init(owner: String, name: String, number: Int) {
    self.owner = owner
    self.name = name
    self.number = number
  }

  public var variables: GraphQLMap? {
    return ["owner": owner, "name": name, "number": number]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("repository", arguments: ["owner": GraphQLVariable("owner"), "name": GraphQLVariable("name")], type: .object(Repository.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(repository: Repository? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "repository": repository.flatMap { (value: Repository) -> ResultMap in value.resultMap }])
    }

    /// Lookup a given repository by the owner and repository name.
    public var repository: Repository? {
      get {
        return (resultMap["repository"] as? ResultMap).flatMap { Repository(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "repository")
      }
    }

    public struct Repository: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Repository"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
          GraphQLField("issue", arguments: ["number": GraphQLVariable("number")], type: .object(Issue.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nameWithOwner: String, issue: Issue? = nil) {
        self.init(unsafeResultMap: ["__typename": "Repository", "nameWithOwner": nameWithOwner, "issue": issue.flatMap { (value: Issue) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The repository's name with owner.
      public var nameWithOwner: String {
        get {
          return resultMap["nameWithOwner"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "nameWithOwner")
        }
      }

      /// Returns a single issue from the current repository by number.
      public var issue: Issue? {
        get {
          return (resultMap["issue"] as? ResultMap).flatMap { Issue(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "issue")
        }
      }

      public struct Issue: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Issue"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("title", type: .nonNull(.scalar(String.self))),
            GraphQLField("number", type: .nonNull(.scalar(Int.self))),
            GraphQLField("author", type: .object(Author.selections)),
            GraphQLField("bodyText", type: .nonNull(.scalar(String.self))),
            GraphQLField("bodyHTML", type: .nonNull(.scalar(String.self))),
            GraphQLField("state", type: .nonNull(.scalar(IssueState.self))),
            GraphQLField("closed", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("closedAt", type: .scalar(String.self)),
            GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
            GraphQLField("timelineItems", arguments: ["first": 100], type: .nonNull(.object(TimelineItem.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(title: String, number: Int, author: Author? = nil, bodyText: String, bodyHtml: String, state: IssueState, closed: Bool, closedAt: String? = nil, createdAt: String, timelineItems: TimelineItem) {
          self.init(unsafeResultMap: ["__typename": "Issue", "title": title, "number": number, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "bodyText": bodyText, "bodyHTML": bodyHtml, "state": state, "closed": closed, "closedAt": closedAt, "createdAt": createdAt, "timelineItems": timelineItems.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the issue title.
        public var title: String {
          get {
            return resultMap["title"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "title")
          }
        }

        /// Identifies the issue number.
        public var number: Int {
          get {
            return resultMap["number"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "number")
          }
        }

        /// The actor who authored the comment.
        public var author: Author? {
          get {
            return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "author")
          }
        }

        /// Identifies the body of the issue rendered to text.
        public var bodyText: String {
          get {
            return resultMap["bodyText"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "bodyText")
          }
        }

        /// The body rendered to HTML.
        public var bodyHtml: String {
          get {
            return resultMap["bodyHTML"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "bodyHTML")
          }
        }

        /// Identifies the state of the issue.
        public var state: IssueState {
          get {
            return resultMap["state"]! as! IssueState
          }
          set {
            resultMap.updateValue(newValue, forKey: "state")
          }
        }

        /// `true` if the object is closed (definition of closed may depend on type)
        public var closed: Bool {
          get {
            return resultMap["closed"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "closed")
          }
        }

        /// Identifies the date and time when the object was closed.
        public var closedAt: String? {
          get {
            return resultMap["closedAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "closedAt")
          }
        }

        /// Identifies the date and time when the object was created.
        public var createdAt: String {
          get {
            return resultMap["createdAt"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "createdAt")
          }
        }

        /// A list of events, comments, commits, etc. associated with the issue.
        public var timelineItems: TimelineItem {
          get {
            return TimelineItem(unsafeResultMap: resultMap["timelineItems"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "timelineItems")
          }
        }

        public struct Author: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("login", type: .nonNull(.scalar(String.self))),
              GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeBot(login: String, avatarUrl: String) -> Author {
            return Author(unsafeResultMap: ["__typename": "Bot", "login": login, "avatarUrl": avatarUrl])
          }

          public static func makeEnterpriseUserAccount(login: String, avatarUrl: String) -> Author {
            return Author(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login, "avatarUrl": avatarUrl])
          }

          public static func makeMannequin(login: String, avatarUrl: String) -> Author {
            return Author(unsafeResultMap: ["__typename": "Mannequin", "login": login, "avatarUrl": avatarUrl])
          }

          public static func makeOrganization(login: String, avatarUrl: String) -> Author {
            return Author(unsafeResultMap: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl])
          }

          public static func makeUser(login: String, avatarUrl: String) -> Author {
            return Author(unsafeResultMap: ["__typename": "User", "login": login, "avatarUrl": avatarUrl])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The username of the actor.
          public var login: String {
            get {
              return resultMap["login"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "login")
            }
          }

          /// A URL pointing to the actor's public avatar.
          public var avatarUrl: String {
            get {
              return resultMap["avatarUrl"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "avatarUrl")
            }
          }
        }

        public struct TimelineItem: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["IssueTimelineItemsConnection"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              GraphQLField("nodes", type: .list(.object(Node.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(totalCount: Int, nodes: [Node?]? = nil) {
            self.init(unsafeResultMap: ["__typename": "IssueTimelineItemsConnection", "totalCount": totalCount, "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// Identifies the total count of items in the connection.
          public var totalCount: Int {
            get {
              return resultMap["totalCount"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "totalCount")
            }
          }

          /// A list of nodes.
          public var nodes: [Node?]? {
            get {
              return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
            }
            set {
              resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["AddedToProjectEvent", "AssignedEvent", "ClosedEvent", "CommentDeletedEvent", "ConnectedEvent", "ConvertedNoteToIssueEvent", "CrossReferencedEvent", "DemilestonedEvent", "DisconnectedEvent", "IssueComment", "LabeledEvent", "LockedEvent", "MarkedAsDuplicateEvent", "MentionedEvent", "MilestonedEvent", "MovedColumnsInProjectEvent", "PinnedEvent", "ReferencedEvent", "RemovedFromProjectEvent", "RenamedTitleEvent", "ReopenedEvent", "SubscribedEvent", "TransferredEvent", "UnassignedEvent", "UnlabeledEvent", "UnlockedEvent", "UnmarkedAsDuplicateEvent", "UnpinnedEvent", "UnsubscribedEvent", "UserBlockedEvent"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLTypeCase(
                  variants: ["IssueComment": AsIssueComment.selections, "AddedToProjectEvent": AsAddedToProjectEvent.selections, "AssignedEvent": AsAssignedEvent.selections, "ClosedEvent": AsClosedEvent.selections, "ReopenedEvent": AsReopenedEvent.selections, "CommentDeletedEvent": AsCommentDeletedEvent.selections, "ConnectedEvent": AsConnectedEvent.selections, "ConvertedNoteToIssueEvent": AsConvertedNoteToIssueEvent.selections, "ReferencedEvent": AsReferencedEvent.selections, "LabeledEvent": AsLabeledEvent.selections, "UnlabeledEvent": AsUnlabeledEvent.selections, "SubscribedEvent": AsSubscribedEvent.selections],
                  default: [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  ]
                )
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public static func makeCrossReferencedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "CrossReferencedEvent"])
            }

            public static func makeDemilestonedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "DemilestonedEvent"])
            }

            public static func makeDisconnectedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "DisconnectedEvent"])
            }

            public static func makeLockedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "LockedEvent"])
            }

            public static func makeMarkedAsDuplicateEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "MarkedAsDuplicateEvent"])
            }

            public static func makeMentionedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "MentionedEvent"])
            }

            public static func makeMilestonedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "MilestonedEvent"])
            }

            public static func makeMovedColumnsInProjectEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "MovedColumnsInProjectEvent"])
            }

            public static func makePinnedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "PinnedEvent"])
            }

            public static func makeRemovedFromProjectEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "RemovedFromProjectEvent"])
            }

            public static func makeRenamedTitleEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "RenamedTitleEvent"])
            }

            public static func makeTransferredEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "TransferredEvent"])
            }

            public static func makeUnassignedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "UnassignedEvent"])
            }

            public static func makeUnlockedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "UnlockedEvent"])
            }

            public static func makeUnmarkedAsDuplicateEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "UnmarkedAsDuplicateEvent"])
            }

            public static func makeUnpinnedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "UnpinnedEvent"])
            }

            public static func makeUnsubscribedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "UnsubscribedEvent"])
            }

            public static func makeUserBlockedEvent() -> Node {
              return Node(unsafeResultMap: ["__typename": "UserBlockedEvent"])
            }

            public static func makeIssueComment(id: GraphQLID, author: AsIssueComment.Author? = nil, bodyText: String, bodyHtml: String, url: String, lastEditedAt: String? = nil, publishedAt: String? = nil) -> Node {
              return Node(unsafeResultMap: ["__typename": "IssueComment", "id": id, "author": author.flatMap { (value: AsIssueComment.Author) -> ResultMap in value.resultMap }, "bodyText": bodyText, "bodyHTML": bodyHtml, "url": url, "lastEditedAt": lastEditedAt, "publishedAt": publishedAt])
            }

            public static func makeAddedToProjectEvent(id: GraphQLID, actor: AsAddedToProjectEvent.Actor? = nil, createdAt: String) -> Node {
              return Node(unsafeResultMap: ["__typename": "AddedToProjectEvent", "id": id, "actor": actor.flatMap { (value: AsAddedToProjectEvent.Actor) -> ResultMap in value.resultMap }, "createdAt": createdAt])
            }

            public static func makeAssignedEvent(id: GraphQLID, actor: AsAssignedEvent.Actor? = nil, assignee: AsAssignedEvent.Assignee? = nil) -> Node {
              return Node(unsafeResultMap: ["__typename": "AssignedEvent", "id": id, "actor": actor.flatMap { (value: AsAssignedEvent.Actor) -> ResultMap in value.resultMap }, "assignee": assignee.flatMap { (value: AsAssignedEvent.Assignee) -> ResultMap in value.resultMap }])
            }

            public static func makeClosedEvent(actor: AsClosedEvent.Actor? = nil) -> Node {
              return Node(unsafeResultMap: ["__typename": "ClosedEvent", "actor": actor.flatMap { (value: AsClosedEvent.Actor) -> ResultMap in value.resultMap }])
            }

            public static func makeReopenedEvent(actor: AsReopenedEvent.Actor? = nil) -> Node {
              return Node(unsafeResultMap: ["__typename": "ReopenedEvent", "actor": actor.flatMap { (value: AsReopenedEvent.Actor) -> ResultMap in value.resultMap }])
            }

            public static func makeCommentDeletedEvent(actor: AsCommentDeletedEvent.Actor? = nil) -> Node {
              return Node(unsafeResultMap: ["__typename": "CommentDeletedEvent", "actor": actor.flatMap { (value: AsCommentDeletedEvent.Actor) -> ResultMap in value.resultMap }])
            }

            public static func makeConnectedEvent(actor: AsConnectedEvent.Actor? = nil, source: AsConnectedEvent.Source, subject: AsConnectedEvent.Subject) -> Node {
              return Node(unsafeResultMap: ["__typename": "ConnectedEvent", "actor": actor.flatMap { (value: AsConnectedEvent.Actor) -> ResultMap in value.resultMap }, "source": source.resultMap, "subject": subject.resultMap])
            }

            public static func makeConvertedNoteToIssueEvent(actor: AsConvertedNoteToIssueEvent.Actor? = nil) -> Node {
              return Node(unsafeResultMap: ["__typename": "ConvertedNoteToIssueEvent", "actor": actor.flatMap { (value: AsConvertedNoteToIssueEvent.Actor) -> ResultMap in value.resultMap }])
            }

            public static func makeReferencedEvent(actor: AsReferencedEvent.Actor? = nil, commit: AsReferencedEvent.Commit? = nil) -> Node {
              return Node(unsafeResultMap: ["__typename": "ReferencedEvent", "actor": actor.flatMap { (value: AsReferencedEvent.Actor) -> ResultMap in value.resultMap }, "commit": commit.flatMap { (value: AsReferencedEvent.Commit) -> ResultMap in value.resultMap }])
            }

            public static func makeLabeledEvent(actor: AsLabeledEvent.Actor? = nil, label: AsLabeledEvent.Label) -> Node {
              return Node(unsafeResultMap: ["__typename": "LabeledEvent", "actor": actor.flatMap { (value: AsLabeledEvent.Actor) -> ResultMap in value.resultMap }, "label": label.resultMap])
            }

            public static func makeUnlabeledEvent(actor: AsUnlabeledEvent.Actor? = nil, label: AsUnlabeledEvent.Label) -> Node {
              return Node(unsafeResultMap: ["__typename": "UnlabeledEvent", "actor": actor.flatMap { (value: AsUnlabeledEvent.Actor) -> ResultMap in value.resultMap }, "label": label.resultMap])
            }

            public static func makeSubscribedEvent(actor: AsSubscribedEvent.Actor? = nil) -> Node {
              return Node(unsafeResultMap: ["__typename": "SubscribedEvent", "actor": actor.flatMap { (value: AsSubscribedEvent.Actor) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            public var asIssueComment: AsIssueComment? {
              get {
                if !AsIssueComment.possibleTypes.contains(__typename) { return nil }
                return AsIssueComment(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsIssueComment: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["IssueComment"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                  GraphQLField("author", type: .object(Author.selections)),
                  GraphQLField("bodyText", type: .nonNull(.scalar(String.self))),
                  GraphQLField("bodyHTML", type: .nonNull(.scalar(String.self))),
                  GraphQLField("url", type: .nonNull(.scalar(String.self))),
                  GraphQLField("lastEditedAt", type: .scalar(String.self)),
                  GraphQLField("publishedAt", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID, author: Author? = nil, bodyText: String, bodyHtml: String, url: String, lastEditedAt: String? = nil, publishedAt: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "IssueComment", "id": id, "author": author.flatMap { (value: Author) -> ResultMap in value.resultMap }, "bodyText": bodyText, "bodyHTML": bodyHtml, "url": url, "lastEditedAt": lastEditedAt, "publishedAt": publishedAt])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return resultMap["id"]! as! GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              /// The actor who authored the comment.
              public var author: Author? {
                get {
                  return (resultMap["author"] as? ResultMap).flatMap { Author(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "author")
                }
              }

              /// The body rendered to text.
              public var bodyText: String {
                get {
                  return resultMap["bodyText"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "bodyText")
                }
              }

              /// The body rendered to HTML.
              public var bodyHtml: String {
                get {
                  return resultMap["bodyHTML"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "bodyHTML")
                }
              }

              /// The HTTP URL for this issue comment
              public var url: String {
                get {
                  return resultMap["url"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "url")
                }
              }

              /// The moment the editor made the last edit
              public var lastEditedAt: String? {
                get {
                  return resultMap["lastEditedAt"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "lastEditedAt")
                }
              }

              /// Identifies when the comment was published at.
              public var publishedAt: String? {
                get {
                  return resultMap["publishedAt"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "publishedAt")
                }
              }

              public struct Author: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                    GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String, avatarUrl: String) -> Author {
                  return Author(unsafeResultMap: ["__typename": "Bot", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeEnterpriseUserAccount(login: String, avatarUrl: String) -> Author {
                  return Author(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeMannequin(login: String, avatarUrl: String) -> Author {
                  return Author(unsafeResultMap: ["__typename": "Mannequin", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeOrganization(login: String, avatarUrl: String) -> Author {
                  return Author(unsafeResultMap: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeUser(login: String, avatarUrl: String) -> Author {
                  return Author(unsafeResultMap: ["__typename": "User", "login": login, "avatarUrl": avatarUrl])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }

                /// A URL pointing to the actor's public avatar.
                public var avatarUrl: String {
                  get {
                    return resultMap["avatarUrl"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "avatarUrl")
                  }
                }
              }
            }

            public var asAddedToProjectEvent: AsAddedToProjectEvent? {
              get {
                if !AsAddedToProjectEvent.possibleTypes.contains(__typename) { return nil }
                return AsAddedToProjectEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsAddedToProjectEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["AddedToProjectEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                  GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID, actor: Actor? = nil, createdAt: String) {
                self.init(unsafeResultMap: ["__typename": "AddedToProjectEvent", "id": id, "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }, "createdAt": createdAt])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return resultMap["id"]! as! GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              /// Identifies the date and time when the object was created.
              public var createdAt: String {
                get {
                  return resultMap["createdAt"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "createdAt")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                    GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeEnterpriseUserAccount(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeMannequin(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeOrganization(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeUser(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login, "avatarUrl": avatarUrl])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }

                /// A URL pointing to the actor's public avatar.
                public var avatarUrl: String {
                  get {
                    return resultMap["avatarUrl"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "avatarUrl")
                  }
                }
              }
            }

            public var asAssignedEvent: AsAssignedEvent? {
              get {
                if !AsAssignedEvent.possibleTypes.contains(__typename) { return nil }
                return AsAssignedEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsAssignedEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["AssignedEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                  GraphQLField("assignee", type: .object(Assignee.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(id: GraphQLID, actor: Actor? = nil, assignee: Assignee? = nil) {
                self.init(unsafeResultMap: ["__typename": "AssignedEvent", "id": id, "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }, "assignee": assignee.flatMap { (value: Assignee) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var id: GraphQLID {
                get {
                  return resultMap["id"]! as! GraphQLID
                }
                set {
                  resultMap.updateValue(newValue, forKey: "id")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              /// Identifies the user or mannequin that was assigned.
              public var assignee: Assignee? {
                get {
                  return (resultMap["assignee"] as? ResultMap).flatMap { Assignee(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "assignee")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                    GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeEnterpriseUserAccount(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeMannequin(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeOrganization(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl])
                }

                public static func makeUser(login: String, avatarUrl: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login, "avatarUrl": avatarUrl])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }

                /// A URL pointing to the actor's public avatar.
                public var avatarUrl: String {
                  get {
                    return resultMap["avatarUrl"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "avatarUrl")
                  }
                }
              }

              public struct Assignee: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLTypeCase(
                      variants: ["User": AsUser.selections, "Bot": AsBot.selections, "Mannequin": AsMannequin.selections, "Organization": AsOrganization.selections],
                      default: [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      ]
                    )
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeUser(login: String) -> Assignee {
                  return Assignee(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public static func makeBot(login: String) -> Assignee {
                  return Assignee(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeMannequin(login: String) -> Assignee {
                  return Assignee(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Assignee {
                  return Assignee(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var asUser: AsUser? {
                  get {
                    if !AsUser.possibleTypes.contains(__typename) { return nil }
                    return AsUser(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsUser: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["User"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("login", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(login: String) {
                    self.init(unsafeResultMap: ["__typename": "User", "login": login])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The username used to login.
                  public var login: String {
                    get {
                      return resultMap["login"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "login")
                    }
                  }
                }

                public var asBot: AsBot? {
                  get {
                    if !AsBot.possibleTypes.contains(__typename) { return nil }
                    return AsBot(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsBot: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Bot"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("login", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(login: String) {
                    self.init(unsafeResultMap: ["__typename": "Bot", "login": login])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The username of the actor.
                  public var login: String {
                    get {
                      return resultMap["login"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "login")
                    }
                  }
                }

                public var asMannequin: AsMannequin? {
                  get {
                    if !AsMannequin.possibleTypes.contains(__typename) { return nil }
                    return AsMannequin(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsMannequin: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Mannequin"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("login", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(login: String) {
                    self.init(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The username of the actor.
                  public var login: String {
                    get {
                      return resultMap["login"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "login")
                    }
                  }
                }

                public var asOrganization: AsOrganization? {
                  get {
                    if !AsOrganization.possibleTypes.contains(__typename) { return nil }
                    return AsOrganization(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsOrganization: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Organization"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("login", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(login: String) {
                    self.init(unsafeResultMap: ["__typename": "Organization", "login": login])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The organization's login name.
                  public var login: String {
                    get {
                      return resultMap["login"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "login")
                    }
                  }
                }
              }
            }

            public var asClosedEvent: AsClosedEvent? {
              get {
                if !AsClosedEvent.possibleTypes.contains(__typename) { return nil }
                return AsClosedEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsClosedEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ClosedEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil) {
                self.init(unsafeResultMap: ["__typename": "ClosedEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }
            }

            public var asReopenedEvent: AsReopenedEvent? {
              get {
                if !AsReopenedEvent.possibleTypes.contains(__typename) { return nil }
                return AsReopenedEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsReopenedEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ReopenedEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil) {
                self.init(unsafeResultMap: ["__typename": "ReopenedEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }
            }

            public var asCommentDeletedEvent: AsCommentDeletedEvent? {
              get {
                if !AsCommentDeletedEvent.possibleTypes.contains(__typename) { return nil }
                return AsCommentDeletedEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsCommentDeletedEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["CommentDeletedEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil) {
                self.init(unsafeResultMap: ["__typename": "CommentDeletedEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }
            }

            public var asConnectedEvent: AsConnectedEvent? {
              get {
                if !AsConnectedEvent.possibleTypes.contains(__typename) { return nil }
                return AsConnectedEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsConnectedEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ConnectedEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                  GraphQLField("source", type: .nonNull(.object(Source.selections))),
                  GraphQLField("subject", type: .nonNull(.object(Subject.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil, source: Source, subject: Subject) {
                self.init(unsafeResultMap: ["__typename": "ConnectedEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }, "source": source.resultMap, "subject": subject.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              /// Issue or pull request that made the reference.
              public var source: Source {
                get {
                  return Source(unsafeResultMap: resultMap["source"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "source")
                }
              }

              /// Issue or pull request which was connected.
              public var subject: Subject {
                get {
                  return Subject(unsafeResultMap: resultMap["subject"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "subject")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }

              public struct Source: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Issue", "PullRequest"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLTypeCase(
                      variants: ["PullRequest": AsPullRequest.selections, "Issue": AsIssue.selections],
                      default: [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      ]
                    )
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makePullRequest(repository: AsPullRequest.Repository, number: Int) -> Source {
                  return Source(unsafeResultMap: ["__typename": "PullRequest", "repository": repository.resultMap, "number": number])
                }

                public static func makeIssue(repository: AsIssue.Repository, number: Int) -> Source {
                  return Source(unsafeResultMap: ["__typename": "Issue", "repository": repository.resultMap, "number": number])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var asPullRequest: AsPullRequest? {
                  get {
                    if !AsPullRequest.possibleTypes.contains(__typename) { return nil }
                    return AsPullRequest(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsPullRequest: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["PullRequest"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
                      GraphQLField("number", type: .nonNull(.scalar(Int.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(repository: Repository, number: Int) {
                    self.init(unsafeResultMap: ["__typename": "PullRequest", "repository": repository.resultMap, "number": number])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The repository associated with this node.
                  public var repository: Repository {
                    get {
                      return Repository(unsafeResultMap: resultMap["repository"]! as! ResultMap)
                    }
                    set {
                      resultMap.updateValue(newValue.resultMap, forKey: "repository")
                    }
                  }

                  /// Identifies the pull request number.
                  public var number: Int {
                    get {
                      return resultMap["number"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "number")
                    }
                  }

                  public struct Repository: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Repository"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(nameWithOwner: String) {
                      self.init(unsafeResultMap: ["__typename": "Repository", "nameWithOwner": nameWithOwner])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    /// The repository's name with owner.
                    public var nameWithOwner: String {
                      get {
                        return resultMap["nameWithOwner"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "nameWithOwner")
                      }
                    }
                  }
                }

                public var asIssue: AsIssue? {
                  get {
                    if !AsIssue.possibleTypes.contains(__typename) { return nil }
                    return AsIssue(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsIssue: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Issue"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
                      GraphQLField("number", type: .nonNull(.scalar(Int.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(repository: Repository, number: Int) {
                    self.init(unsafeResultMap: ["__typename": "Issue", "repository": repository.resultMap, "number": number])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The repository associated with this node.
                  public var repository: Repository {
                    get {
                      return Repository(unsafeResultMap: resultMap["repository"]! as! ResultMap)
                    }
                    set {
                      resultMap.updateValue(newValue.resultMap, forKey: "repository")
                    }
                  }

                  /// Identifies the issue number.
                  public var number: Int {
                    get {
                      return resultMap["number"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "number")
                    }
                  }

                  public struct Repository: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Repository"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(nameWithOwner: String) {
                      self.init(unsafeResultMap: ["__typename": "Repository", "nameWithOwner": nameWithOwner])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    /// The repository's name with owner.
                    public var nameWithOwner: String {
                      get {
                        return resultMap["nameWithOwner"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "nameWithOwner")
                      }
                    }
                  }
                }
              }

              public struct Subject: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Issue", "PullRequest"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLTypeCase(
                      variants: ["PullRequest": AsPullRequest.selections, "Issue": AsIssue.selections],
                      default: [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      ]
                    )
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makePullRequest(repository: AsPullRequest.Repository, number: Int) -> Subject {
                  return Subject(unsafeResultMap: ["__typename": "PullRequest", "repository": repository.resultMap, "number": number])
                }

                public static func makeIssue(repository: AsIssue.Repository, number: Int) -> Subject {
                  return Subject(unsafeResultMap: ["__typename": "Issue", "repository": repository.resultMap, "number": number])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var asPullRequest: AsPullRequest? {
                  get {
                    if !AsPullRequest.possibleTypes.contains(__typename) { return nil }
                    return AsPullRequest(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsPullRequest: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["PullRequest"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
                      GraphQLField("number", type: .nonNull(.scalar(Int.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(repository: Repository, number: Int) {
                    self.init(unsafeResultMap: ["__typename": "PullRequest", "repository": repository.resultMap, "number": number])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The repository associated with this node.
                  public var repository: Repository {
                    get {
                      return Repository(unsafeResultMap: resultMap["repository"]! as! ResultMap)
                    }
                    set {
                      resultMap.updateValue(newValue.resultMap, forKey: "repository")
                    }
                  }

                  /// Identifies the pull request number.
                  public var number: Int {
                    get {
                      return resultMap["number"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "number")
                    }
                  }

                  public struct Repository: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Repository"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(nameWithOwner: String) {
                      self.init(unsafeResultMap: ["__typename": "Repository", "nameWithOwner": nameWithOwner])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    /// The repository's name with owner.
                    public var nameWithOwner: String {
                      get {
                        return resultMap["nameWithOwner"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "nameWithOwner")
                      }
                    }
                  }
                }

                public var asIssue: AsIssue? {
                  get {
                    if !AsIssue.possibleTypes.contains(__typename) { return nil }
                    return AsIssue(unsafeResultMap: resultMap)
                  }
                  set {
                    guard let newValue = newValue else { return }
                    resultMap = newValue.resultMap
                  }
                }

                public struct AsIssue: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Issue"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("repository", type: .nonNull(.object(Repository.selections))),
                      GraphQLField("number", type: .nonNull(.scalar(Int.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(repository: Repository, number: Int) {
                    self.init(unsafeResultMap: ["__typename": "Issue", "repository": repository.resultMap, "number": number])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The repository associated with this node.
                  public var repository: Repository {
                    get {
                      return Repository(unsafeResultMap: resultMap["repository"]! as! ResultMap)
                    }
                    set {
                      resultMap.updateValue(newValue.resultMap, forKey: "repository")
                    }
                  }

                  /// Identifies the issue number.
                  public var number: Int {
                    get {
                      return resultMap["number"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "number")
                    }
                  }

                  public struct Repository: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["Repository"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(nameWithOwner: String) {
                      self.init(unsafeResultMap: ["__typename": "Repository", "nameWithOwner": nameWithOwner])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    /// The repository's name with owner.
                    public var nameWithOwner: String {
                      get {
                        return resultMap["nameWithOwner"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "nameWithOwner")
                      }
                    }
                  }
                }
              }
            }

            public var asConvertedNoteToIssueEvent: AsConvertedNoteToIssueEvent? {
              get {
                if !AsConvertedNoteToIssueEvent.possibleTypes.contains(__typename) { return nil }
                return AsConvertedNoteToIssueEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsConvertedNoteToIssueEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ConvertedNoteToIssueEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil) {
                self.init(unsafeResultMap: ["__typename": "ConvertedNoteToIssueEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }
            }

            public var asReferencedEvent: AsReferencedEvent? {
              get {
                if !AsReferencedEvent.possibleTypes.contains(__typename) { return nil }
                return AsReferencedEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsReferencedEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ReferencedEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                  GraphQLField("commit", type: .object(Commit.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil, commit: Commit? = nil) {
                self.init(unsafeResultMap: ["__typename": "ReferencedEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }, "commit": commit.flatMap { (value: Commit) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              /// Identifies the commit associated with the 'referenced' event.
              public var commit: Commit? {
                get {
                  return (resultMap["commit"] as? ResultMap).flatMap { Commit(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "commit")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }

              public struct Commit: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Commit"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("commitUrl", type: .nonNull(.scalar(String.self))),
                    GraphQLField("message", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(commitUrl: String, message: String) {
                  self.init(unsafeResultMap: ["__typename": "Commit", "commitUrl": commitUrl, "message": message])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The HTTP URL for this Git object
                public var commitUrl: String {
                  get {
                    return resultMap["commitUrl"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "commitUrl")
                  }
                }

                /// The Git commit message
                public var message: String {
                  get {
                    return resultMap["message"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "message")
                  }
                }
              }
            }

            public var asLabeledEvent: AsLabeledEvent? {
              get {
                if !AsLabeledEvent.possibleTypes.contains(__typename) { return nil }
                return AsLabeledEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsLabeledEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["LabeledEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                  GraphQLField("label", type: .nonNull(.object(Label.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil, label: Label) {
                self.init(unsafeResultMap: ["__typename": "LabeledEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }, "label": label.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              /// Identifies the label associated with the 'labeled' event.
              public var label: Label {
                get {
                  return Label(unsafeResultMap: resultMap["label"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "label")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }

              public struct Label: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Label"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("color", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(color: String, name: String) {
                  self.init(unsafeResultMap: ["__typename": "Label", "color": color, "name": name])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// Identifies the label color.
                public var color: String {
                  get {
                    return resultMap["color"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "color")
                  }
                }

                /// Identifies the label name.
                public var name: String {
                  get {
                    return resultMap["name"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "name")
                  }
                }
              }
            }

            public var asUnlabeledEvent: AsUnlabeledEvent? {
              get {
                if !AsUnlabeledEvent.possibleTypes.contains(__typename) { return nil }
                return AsUnlabeledEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsUnlabeledEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["UnlabeledEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                  GraphQLField("label", type: .nonNull(.object(Label.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil, label: Label) {
                self.init(unsafeResultMap: ["__typename": "UnlabeledEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }, "label": label.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              /// Identifies the label associated with the 'unlabeled' event.
              public var label: Label {
                get {
                  return Label(unsafeResultMap: resultMap["label"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "label")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }

              public struct Label: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Label"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("color", type: .nonNull(.scalar(String.self))),
                    GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(color: String, name: String) {
                  self.init(unsafeResultMap: ["__typename": "Label", "color": color, "name": name])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// Identifies the label color.
                public var color: String {
                  get {
                    return resultMap["color"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "color")
                  }
                }

                /// Identifies the label name.
                public var name: String {
                  get {
                    return resultMap["name"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "name")
                  }
                }
              }
            }

            public var asSubscribedEvent: AsSubscribedEvent? {
              get {
                if !AsSubscribedEvent.possibleTypes.contains(__typename) { return nil }
                return AsSubscribedEvent(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsSubscribedEvent: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["SubscribedEvent"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("actor", type: .object(Actor.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(actor: Actor? = nil) {
                self.init(unsafeResultMap: ["__typename": "SubscribedEvent", "actor": actor.flatMap { (value: Actor) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the actor who performed the event.
              public var actor: Actor? {
                get {
                  return (resultMap["actor"] as? ResultMap).flatMap { Actor(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "actor")
                }
              }

              public struct Actor: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Bot", "EnterpriseUserAccount", "Mannequin", "Organization", "User"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("login", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public static func makeBot(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Bot", "login": login])
                }

                public static func makeEnterpriseUserAccount(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "EnterpriseUserAccount", "login": login])
                }

                public static func makeMannequin(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Mannequin", "login": login])
                }

                public static func makeOrganization(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "Organization", "login": login])
                }

                public static func makeUser(login: String) -> Actor {
                  return Actor(unsafeResultMap: ["__typename": "User", "login": login])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The username of the actor.
                public var login: String {
                  get {
                    return resultMap["login"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "login")
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
