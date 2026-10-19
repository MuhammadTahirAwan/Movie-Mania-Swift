//
//  NetworkService.swift
//  Basic_Networking_Swift
//
//  Created by Tahir Awan on 13/10/2026.
//

import Foundation

protocol NetworkServiceProtocol{
    /// Sends an endpoint and decodes the JSON response into `T`.
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        as Type: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void
    )
}


final class NetworkService: NetworkServiceProtocol{
    
    
    private let session: URLSession
    private let baseURL: String
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared,
         baseURL: String = APPConfig.shared.baseURL,
         decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.baseURL = baseURL
        
        
        // Automatically converts "total_pages" -> "totalPages", "poster_path" -> "posterPath", etc.
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder = decoder
    }
    
    
    
    func request<T>(
        _ endpoint: Endpoint,
        as Type: T.Type,
        completion: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
        
            
            
            let finish: (Result<T, APIError>) -> Void = { result in
                
                DispatchQueue.main.async{
                    
                    completion(result)
                }
            }
            
            let request: URLRequest
            do {
                request = try endpoint.makeRequest(baseURL: baseURL)
                print(request)
            } catch let error as APIError {
                finish(.failure(error))
                return
            } catch {
                finish(.failure(.invalidURL))
                return
            }
            
            let task = session.dataTask(with: request) { data, response, error in
                // 1. Transport-level error.
                if let error {
                    finish(.failure(.transport(error.localizedDescription)))
                    return
                }
                
                // 2. Must be an HTTP response.
                guard let http = response as? HTTPURLResponse else {
                    finish(.failure(.invalidResponse))
                    return
                }
                
                // 3. Status code must be in the 2xx success range.
                guard (200...299).contains(http.statusCode) else {
                    finish(.failure(.unacceptableStatusCode(http.statusCode)))
                    return
                }
                
                // 4. We need a body to decode.
                guard let data, !data.isEmpty else {
                    finish(.failure(.emptyData))
                    return
                }
                
                // 5. Decode JSON → model.
                do {
                    let decoded = try self.decoder.decode(T.self, from: data)
                    finish(.success(decoded))
                } catch {
                    finish(.failure(.decoding(error.localizedDescription)))
                }
            }
            task.resume()
    }
    
    
    
}
