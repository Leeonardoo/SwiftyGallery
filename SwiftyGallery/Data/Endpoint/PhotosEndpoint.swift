//
//  PhotosEndpoint.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 07/12/23.
//

import Foundation
import Alamofire

enum PhotosEndpoint: Endpoint {
    
    case photoList(page: Int, perPage: Int, query: String? = nil)
    
    var method: HTTPMethod {
        switch self {
            case .photoList(_, _, _): .get
        }
    }
    
    var path: String {
        switch self {
            case .photoList(_, _, let query):
                return if query != nil {
                    "search/photos"
                } else {
                    "photos"
                }
        }
    }
    
    var query: Parameters? {
        switch self {
            case .photoList(let page, let perPage, let query):
                var params: [String: Any] = [
                    "page": page,
                    "per_page": perPage
                ]
                
                if let query {
                    params["query"] = query
                }
                
                //TODO: Test if it actually becomes URL encoded
                
                return params
        }
    }
}
