//
//  PhotosEndpoint.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 07/12/23.
//

import Foundation
import Alamofire

enum PhotosEndpoint: Endpoint {
    
    case photoList(page: Int, perPage: Int)
    case photoSearch(page: Int, perPage: Int, query: String)
    
    var method: HTTPMethod {
        switch self {
            case .photoList(_, _), .photoSearch(_, _, _): .get
        }
    }
    
    var path: String {
        switch self {
            case .photoList(_, _):
                return "photos"
            case .photoSearch(_, _, _):
                return "search/photos"
        }
    }
    
    var query: Parameters? {
        switch self {
            case .photoList(let page, let perPage):
                let params: [String: Any] = [
                    "page": page,
                    "per_page": perPage
                ]
                
                return params
                
            case .photoSearch(let page, let perPage, let query):
                let params: [String: Any] = [
                    "page": page,
                    "per_page": perPage,
                    "query": query
                ]
                
                //TODO: Test if it actually becomes URL encoded
                
                return params
                
        }
    }
}
