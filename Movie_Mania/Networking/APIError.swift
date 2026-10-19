//
//  APIError.swift
//  Basic_Networking_Swift
//
//  Created by Tahir Awan on 10/10/2026.
//

import Foundation


enum APIError: LocalizedError {
    /// URLComponents/URLRequest could not be built.
    case invalidURL
    /// Transport-level failure (no connection, timeout, DNS, …).
    case transport(String)
    /// Response was not an HTTPURLResponse.
    case invalidResponse
    /// Server returned a non-2xx status code.
    case unacceptableStatusCode(Int)
    /// Body was empty when a body was expected.
    case emptyData
    /// JSONDecoder failed to map the payload to the model.
    case decoding(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .transport(let error):
            return "Network error: \(error)."
        case .invalidResponse:
            return "The server returned an unexpected response."
        case .unacceptableStatusCode(let code):
            return "Request failed with HTTP status code \(code)."
        case .emptyData:
            return "The server returned no data."
        case .decoding(let message):
            return "Failed to parse the response: \(message)"
        }
    }
}
