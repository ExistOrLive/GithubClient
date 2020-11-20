//
//  ZLGithubHttpClient_GraphQL.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import Foundation
import Apollo

typealias GithubResponseSwift = (Bool,Any?,String) -> Void

let GithubGraphQLAPI = "https://api.github.com/graphql"


 extension ZLGithubHttpClient{
    
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
    
    @objc func getWorkBoardInfo(block: @escaping GithubResponseSwift,serialNumber: String){
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
