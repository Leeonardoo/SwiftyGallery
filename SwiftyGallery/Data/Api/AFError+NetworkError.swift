//
//  AFError+NetworkError.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 28/08/23.
//

import Foundation
import Alamofire

extension AFError {
    func asNetworkError<E: Decodable & CustomStringConvertible>(with errorType: E.Type, data: Data?) -> NetworkError<E> {
        switch self {
               
            case .responseValidationFailed(_):
                if let errorData = data {
                    do {
                        let errorBody = try JSONDecoder().decode(errorType.self, from: errorData)
                        return .errorBody(errorBody, code: self.responseCode ?? -1)
                    } catch {
                        return .unknown(code: self.responseCode ?? -1)
                    }
                } else {
                    return .unknown(code: self.responseCode ?? -1)
                }
                
            case .sessionTaskFailed(_):
                return .network
                
            default:
                return .unknown(code: self.responseCode ?? -1)
        }
    }
}
