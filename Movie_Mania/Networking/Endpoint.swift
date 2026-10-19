//
//  Endpoint.swift
//  Basic_Networking_Swift
//
//  Created by Tahir Awan on 13/10/2026.
//

import Foundation


enum HTTPMethod: String{
    
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case put = "PUT"
    case delete = "DELETE"
}


struct Endpoint{
    
    let method: HTTPMethod
    let path: String
    let queryItems: [URLQueryItem]
    let body: Data?
    
    init(method: HTTPMethod = .get, path: String = "", queryItems: [URLQueryItem] = [], body: Data? = nil) {
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.body = body
        
        print(self)
    }
    
    
    func makeRequest(baseURL: String) throws -> URLRequest{
        
        guard var components = URLComponents(string: baseURL) else{
            
            throw APIError.invalidURL
        }
        
        components.path += path
        
        if !queryItems.isEmpty{ components.queryItems = queryItems}
        
        guard let url = components.url else { throw APIError.invalidURL }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval  = 20
        
        if let body{
            
            request.httpBody = body
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        print(request.url)
        return request
        
    }
}


extension Endpoint{
    
    
    /// GET /users — demonstrates a path parameter.
    static func movie() -> Endpoint{
        
        Endpoint(method: .get,
                 path: "/top_rated",
                 queryItems: [URLQueryItem(name: "api_key", value: APPConfig.shared.apiKey),
                              URLQueryItem(name: "language:", value: "en-US"),
                              URLQueryItem(name: "page", value: "1")])
    }
    
    static func img() -> Endpoint{
        
        Endpoint(method: .get)
    }
}
