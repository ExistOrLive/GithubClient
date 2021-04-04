//
//  ZLGithubHttpClient_GraphQL.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import Apollo

public typealias GithubResponseSwift = (Bool,Any?,String) -> Void

let GithubGraphQLAPI = "https://api.github.com/graphql"


private class ZLTokenIntercetor : ApolloInterceptor {
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void){
        request.addHeader(name:"Authorization", value: "token \(ZLGithubHttpClient.default().token)")
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}

private class ZLTokenInvalidDealIntercetor : ApolloInterceptor {
    
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void){
       
        if let httpResponse = response?.httpResponse{
            if httpResponse.statusCode == 401 {
                ZLMainThreadDispatch({
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ZLGithubTokenInvalid_Notification"), object: nil)
                })
            }
        }
        chain.proceedAsync(request: request, response: response, completion: completion)
    }
}

private struct ZLNetworkInterceptorProvider: InterceptorProvider {
    
    // These properties will remain the same throughout the life of the `InterceptorProvider`, even though they
    // will be handed to different interceptors.
    private let store: ApolloStore
    private let client: URLSessionClient
    
    init(store: ApolloStore,
         client: URLSessionClient) {
        self.store = store
        self.client = client
    }
    
    func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        return [
            ZLTokenIntercetor(),
            MaxRetryInterceptor(),
            LegacyCacheReadInterceptor(store: self.store),
            NetworkFetchInterceptor(client: self.client),
            ZLTokenInvalidDealIntercetor(),
            ResponseCodeInterceptor(),
            LegacyParsingInterceptor(cacheKeyForObject: self.store.cacheKeyForObject),
            AutomaticPersistedQueryInterceptor(),
            LegacyCacheWriteInterceptor(store: self.store)
        ]
    }
}




public extension ZLGithubHttpClient{
    
    fileprivate static var realApolloCilent : ApolloClient = {
        
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        
        let client = URLSessionClient()
        let provider = ZLNetworkInterceptorProvider(store: store, client: client)
            
        let networkTransport = RequestChainNetworkTransport(interceptorProvider: provider, endpointURL: URL.init(string: GithubGraphQLAPI)!)
        
        return ApolloClient.init(networkTransport:networkTransport, store: store)
    }()
    
    
    fileprivate var apolloClient: ApolloClient!{
        ZLGithubHttpClient.realApolloCilent
    }
    
    func baseQuery<Query: GraphQLQuery>(query: Query,
                                        serialNumber: String,
                                        block: @escaping GithubResponseSwift){
        
        analytics.log(.URLUse(url: query.operationName))
        
        self.apolloClient.fetch(query: query){ result in
            var resultData : Any? = nil
            var success = false
            switch result{
            case .success(_):do{
                if let data = try? result.get().data{
                    success = true
                    let json = data.jsonObject
                    let serialized = try! JSONSerialization.data(withJSONObject: json, options: [])
                    let deserialized = try! JSONSerialization.jsonObject(with: serialized, options: []) as! JSONObject
                    let result = try! type(of: query).Data(jsonObject: deserialized)
                    resultData = result
                } else {
                    success = false
                    let errorModel = ZLGithubRequestErrorModel()
                    if let error = try? result.get().errors?.first{
                        errorModel.message = error.localizedDescription
                    }
                    resultData = errorModel
                }
            }
                break
            case .failure(let error):do{
                success = false
                let errorModel = ZLGithubRequestErrorModel()
                errorModel.message = error.localizedDescription
                resultData = errorModel
            }
                break
            }
            block(success,resultData,serialNumber)
        }
        
    }
    
    
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的工作台信息
     */
    @objc func getWorkBoardInfo(serialNumber: String,block: @escaping GithubResponseSwift){
        let query = WorkboardInfoQuery()
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的组织信息
     */
    @objc func getOrgs(serialNumber: String,block: @escaping GithubResponseSwift){
        let query = ViewerOrgsQuery()
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的issue
     */
    @objc func getMyIssues(assignee: String?,
                           createdBy: String?,
                           mentioned: String?,
                           after: String?,
                           serialNumber: String,
                           block: @escaping GithubResponseSwift){
       
        let query = ViewerIssuesQuery(assignee: assignee, creator: createdBy, mentioned: mentioned, after: after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    
    /**
     * @param query  查询条件 archived:false sort:created-desc is:open is:issue mentions:@me
     * @param block
     *  搜索issue
     */
    @objc func searchIssues(after: String?,
                            query: String,
                            serialNumber: String,
                            block: @escaping GithubResponseSwift){
        let query = SearchIssuesQuery(after: after, query: query)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的repo
     */
    @objc func getMyTopRepo(after: String?,
                            serialNumber: String,
                            block: @escaping GithubResponseSwift){
        let query = ViewerTopRepositoriesQuery(after: after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的pr
     */
    @objc func getMyPRs(state: ZLGithubPullRequestState,
                        after: String?,
                        serialNumber: String,
                        block: @escaping GithubResponseSwift){
        var pullRequestState : PullRequestState
        switch state {
        case .opened:
            pullRequestState = .open
        case .closed:
            pullRequestState = .closed
        case .merged:
            pullRequestState = .merged
        @unknown default:
            pullRequestState = .open
        }
        let query = ViewerPullRequestQuery(state: [pullRequestState], after: after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param login
     * @param repoName
     *  @param number
     *  查询某个issue
     */
    
    @objc func getIssueInfo(login : String,
                            repoName : String,
                            number : Int,
                            after : String?,
                            serialNumber: String,
                            block: @escaping GithubResponseSwift){
        let query = IssueInfoQuery(owner: login, name: repoName, number: number, after:after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }
    
    /**
     * @param login
     * @param repoName
     *  @param number
     *  查询某个pr
     */

    
    @objc func getPRInfo(login : String,
                   repoName : String,
                   number : Int,
                   after : String?,
                   serialNumber: String,
                   block: @escaping GithubResponseSwift) {
        let query = PrInfoQuery(owner: login, name: repoName, number: number, after: after)
        self.baseQuery(query: query, serialNumber: serialNumber, block: block)
    }

    
}



