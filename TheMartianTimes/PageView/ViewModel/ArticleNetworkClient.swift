//
//  ArticleNetworkClient.swift
//  TheMartianTimes
//
//  Created by Chanick on 6/22/21.
//

import Foundation


//
// ArticleeNetworkClient
//
class ArticleeNetworkClient : NetworkClient {
    var basePath: String {
        return baseUrl.absoluteString
    }
    
    // Base URL
    let baseUrl = URL(string: Constants.Network.ArticleURL)!
    private let session: URLSession
    
    /**
     * @desc Init
     * @param URLSession, Set a URLSession.shared
     */
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    /**
     * @desc Network Request using parameters
     * @param method, path, parameters
     * @return callback
     */
    func request(method: HttpMethod, path: String, parameters: [String : Any]? = nil, httpBody: Data? = nil, callback: @escaping (NetworkClientResult<Data>) -> Void) {
        
        guard let url = URL(string: path, relativeTo: baseUrl) else {
            return
        }
        
        // Create URL request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = httpBody
        
        let task = session.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            
            DispatchQueue.main.async {
                if let data = data, (200..<300).contains(httpResponse.statusCode) {
                    callback(.success(data))
                } else if let error = error {
                    callback(.failure([error.localizedDescription]))
                }
            }
        }
        
        task.resume()
    }
    
    /**
     * @desc Network Request using parameters
     * @return Decode to Specific Result Type
     */
    func request<T>(method: HttpMethod, path: String, parameters: [String : Any]? = nil, httpBody: Data? = nil, callback: @escaping (NetworkClientResult<T>) -> Void) where T : Decodable, T : Encodable {
        
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
    
    /**
     * @desc Network Request using parameters
     * @return Decode to Specific Result Type with key path
     */
    func request<T>(method: HttpMethod, path: String, parameters: [String : Any]? = nil, httpBody: Data? = nil, keyPath: String?, complete callback: @escaping (NetworkClientResult<T>) -> Void) where T : Decodable, T : Encodable {
        
        request(method: method, path: path, parameters: parameters, httpBody: nil) { (dataResult) in
            switch dataResult {
            case .success(let data):
                do {
                    var nestedData = data
                    
                    if let keyPath = keyPath,
                       let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                        // data to json
                        if let nestedJson = json[keyPath] {
                            nestedData = try JSONSerialization.data(withJSONObject: nestedJson, options: .prettyPrinted)
                        }
                    }
                    
                    let codable = try JSONDecoder().decode(T.self, from: nestedData)
                    callback(.success(codable))
                } catch let error {
                    callback(.failure([error.localizedDescription]))
                }
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
}
