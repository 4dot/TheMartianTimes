//
//  ArticleNetworkManager.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/22/21.
//

import Foundation

//
// ArticleNetworkManager
// Request Article List
//
typealias ArticlesCompletionBlock = (NetworkClientResult<[Article]>) -> (Void)


struct ArticleNetworkManager: NetworkManager {
    let client: NetworkClient
    var relativePath: String
    
    
    init(client: NetworkClient) {
        self.client = client
        
        // full path : https://s1.nyt.com/ios-newsreader/candidates/test/articles.json
        self.relativePath = ""
    }
    
    /**
     * @desc Request Article List with parameters
     */
    mutating func requestArticles(_ page: Int = 0, callback: ArticlesCompletionBlock?) {
        
        client.request(method: .get, path: path, parameters: nil, httpBody: nil) { (result) in
            switch result {
            case .success(let data):
                do {
                    let articles = try JSONDecoder().decode([Article].self, from: data)
                    callback?(.success(articles))
                } catch let error {
                    callback?(.failure([error.localizedDescription]))
                }
            case .failure(let error):
                callback?(.failure(error))
            }
        }
    }
    
}
