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


public extension ZLGithubHttpClient{
    
    fileprivate static var realApolloCilent : ApolloClient?
    
    fileprivate var apolloClient: ApolloClient!{
        get{
            if  ZLGithubHttpClient.realApolloCilent != nil{
                return ZLGithubHttpClient.realApolloCilent
            }
            
            let httpTransport = HTTPNetworkTransport(url:URL.init(string: GithubGraphQLAPI)!)
            httpTransport.delegate = self
            ZLGithubHttpClient.realApolloCilent = ApolloClient.init(networkTransport: httpTransport)
            return ZLGithubHttpClient.realApolloCilent
        }
    }
    
    
    /**
     * @param serialNumber
     * @param block
     *  查询我的工作台信息
     */
    @objc func getWorkBoardInfo(serialNumber: String,block: @escaping GithubResponseSwift){
        let query = WorkboardInfoQuery()
        
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
                    let result = try! WorkboardInfoQuery.Data(jsonObject: deserialized)
                    resultData = result
                } else {
                    success = false
                    resultData = ZLGithubRequestErrorModel()
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
    
    
    func baseQuery<Query: GraphQLQuery>(query: Query,
                                        serialNumber: String,
                                        block: @escaping GithubResponseSwift){
        
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
    
}

extension ZLGithubHttpClient : HTTPNetworkTransportPreflightDelegate, HTTPNetworkTransportTaskCompletedDelegate{
    public func networkTransport(_ networkTransport: HTTPNetworkTransport, shouldSend request: URLRequest) -> Bool {
        return true
    }
    
    public func networkTransport(_ networkTransport: HTTPNetworkTransport, willSend request: inout URLRequest) {
        request.addValue("token \(self.token)", forHTTPHeaderField: "Authorization")
    }
    
    public func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          didCompleteRawTaskForRequest request: URLRequest,
                          withData data: Data?,
                          response: URLResponse?,
                          error: Error?){
        if let httpResponse = response as? HTTPURLResponse{
            if httpResponse.statusCode == 401 {
                ZLMainThreadDispatch({
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ZLGithubTokenInvalid_Notification"), object: nil)
                })
            }
        }
    }
    
    
}
