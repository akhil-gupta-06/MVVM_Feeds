//
//  NetworkClient.swift
//  MVVM_Feeds
//
//  Created by Akhil Gupta on 10/1/26.
//

import UIKit
enum NetworkClientError: Error {
    case parsingFailed
    case invalidURL
    case invalidReponse
}

enum Constants {
    static let baseURL = "https://some-api.com"
}

struct EmptyResponse: Decodable {}


actor NetworkClient {
    static let shared = NetworkClient()
    
    private init() {
        
    }
    
    
    func makeCall<T: Decodable>(path: String,
                                httpMethod: String = "GET",
                                queryParams: [String: String]? = nil,
                                headers: [String: String]? = nil,
                                body:Encodable? = nil) async throws -> T {
        
        guard !path.isEmpty else {
            throw NetworkClientError.invalidURL
        }
        
        guard var urlcomponents = await URLComponents(string: Constants.baseURL + path),
              let requestURL = urlcomponents.url else {
            throw NetworkClientError.invalidURL
        }
        
        if let queryItems = queryParams, !queryItems.isEmpty {
            urlcomponents.queryItems = queryItems.map {
                URLQueryItem(name: $0.key, value: $0.value)
            }
        }
        
        var request = URLRequest(url: requestURL)
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        request.httpMethod = httpMethod
        if let httpBody = body {
            request.httpBody = try JSONEncoder().encode(httpBody)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpsResponse = response as? HTTPURLResponse, (200..<300).contains(httpsResponse.statusCode) else {
            throw NetworkClientError.invalidReponse
        }
        return try JSONDecoder().decode(T.self, from: data)
    }

//    func makeCallNoResponse(path: String,
//                            httpMethod: String = "DELETE",
//                            headers: [String: String]? = nil) async throws {
//        guard !path.isEmpty else { throw NetworkClientError.invalidURL }
//        guard let url = URL(string: Constants.baseURL + path) else {
//            throw NetworkClientError.invalidURL
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = httpMethod
//        headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
//        let (_, response) = try await URLSession.shared.data(for: request)
//        guard let httpResponse = response as? HTTPURLResponse,
//              (200..<300).contains(httpResponse.statusCode) else {
//            throw NetworkClientError.invalidReponse
//        }
//    }
}
