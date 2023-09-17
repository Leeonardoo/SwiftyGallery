//
//  Endpoint.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 28/08/23.
//

import Foundation
import Alamofire

protocol Endpoint: URLRequestConvertible {
    
    var baseUrl: URL? { get }
    
    var method: HTTPMethod { get }
    
    var headers: [String: String] { get }
    
    var path: String { get }
    
    var query: Parameters? { get }
    
    var body: Parameters? { get }
    
    var queryEncoding: ParameterEncoding { get }
    
    var bodyEncoding: ParameterEncoding { get }
    
}

extension Endpoint {
    
    var baseUrl: URL {
        let urlString = "http://localhost:3000"
        return URL(string: urlString)!
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var query: Parameters? {
        return nil
    }
    
    var body: Parameters? {
        return nil
    }
    
    var queryEncoding: ParameterEncoding {
        URLEncoding.queryString
    }
    
    var bodyEncoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        guard let baseUrl else {
            throw AFError.parameterEncoderFailed(reason: .missingRequiredComponent(.url))
        }
        
        var urlRequest = URLRequest(url: baseUrl.appendingPathComponent(path))
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Common Headers
        //    urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        //    urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        
        // Custom headers
        headers.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Query parameters
        if let query {
            do {
                urlRequest = try queryEncoding.encode(urlRequest, with: query)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .customEncodingFailed(error: error))
            }
        }
        
        // Body parameters
        if let body {
            do {
                urlRequest = try bodyEncoding.encode(urlRequest, with: body)
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        return urlRequest
    }
}
