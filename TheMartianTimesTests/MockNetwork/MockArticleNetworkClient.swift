//
//  MockArticleNetworkClient.swift
//  TheMartianTimesTests
//
//  Created by Chanick on 7/18/21.
//

import Foundation
@testable import TheMartianTimes


enum BundleRequestError: Error {
    case invalidPath
    case invalidData
}

//
// MockArticleNetworkClient
// Load from local json file
//
class MockArticleNetworkClient : NetworkClient {
    var basePath: String = ""
    
    func request(method: HttpMethod, path: String, parameters: [String : Any]?, httpBody: Data?, callback: @escaping (NetworkClientResult<Data>) -> Void) {
        // load json file from local
        guard let url = Bundle(for: TheMartianTimesTests.self).url(forResource: path, withExtension: "json") else {
            callback(.failure([BundleRequestError.invalidPath.localizedDescription]))
            return
        }
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            callback(.success(data))
        } catch {
            // handle error
            callback(.failure([BundleRequestError.invalidData.localizedDescription]))
        }
    }
    
    func request<T>(method: HttpMethod, path: String, parameters: [String : Any]?, httpBody: Data?, callback: @escaping (NetworkClientResult<T>) -> Void) where T : Decodable, T : Encodable {
        // load json file from local
        request(method: method, path: path, parameters: parameters, httpBody: httpBody) { (dataResult) in
            switch dataResult {
            case .success(let data):
                do {
                    let codable = try JSONDecoder().decode(T.self, from: data)
                    callback(.success(codable))
                } catch let error {
                    callback(.failure([error.localizedDescription]))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func request<T>(method: HttpMethod, path: String, parameters: [String : Any]?, httpBody: Data?, keyPath: String?, complete: @escaping (NetworkClientResult<T>) -> Void) where T : Decodable, T : Encodable {
        //
    }
}
