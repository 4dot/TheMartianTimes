//
//  MockArticleNetworkManager.swift
//  TheMartianTimesTests
//
//  Created by Chanick on 7/18/21.
//

import Foundation
@testable import TheMartianTimes



//
// MockArticleNetworkManager
//
struct MockArticleNetworkManager: NetworkManager {
    var client: NetworkClient
    var relativePath: String
    
    init(client: NetworkClient) {
        self.client = client
        self.relativePath = ""
    }
    
    /**
     * @desc Request article List from local Json file
     */
    func requestArticlesrequestArticles(_ page: Int = 0, callback: ArticlesCompletionBlock?) {
        client.request(method: .get, path: path, parameters: nil, httpBody: nil, callback: { (result: NetworkClientResult<[Article]>) in
            callback?(result)
        })
    }
}

