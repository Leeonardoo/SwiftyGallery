//
//  AFError+NetworkError.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 28/08/23.
//

import Foundation
import Alamofire

extension AFError {
    func asNetworkError<E: ErrorMapper>(with errorType: E.Type, data: Data?) -> NetworkError<E> {
        
        switch self {
        case .serverTrustEvaluationFailed(_):
            return .untrustedConnection
            
        case .responseSerializationFailed:
            return .responseSerialization(code: responseCode ?? -1)
            
        case .invalidURL(_):
            return .notFound
            
        case .responseValidationFailed(_):
            guard self.responseCode != 404 else {
                return .notFound
            }
            
            if self.responseCode != 422 {
                //Log firebase tag NETWORK_ERROR_HTTP_EXCEPTION
                // param error_code = self.responseCode
            }
            
            if let errorData = data,
               let errorBody = try? JSONDecoder().decode(errorType.self, from: errorData),
               !errorBody.isEmpty {
                return .errorBody(errorBody, code: self.responseCode ?? -1)
            } else {
                guard let code = self.responseCode else {
                    return .unknown(code: -1)
                }
                
                switch code {
                case 500:
                    return .internalServerError
                    
                case 525:
                    return .untrustedConnection
                    
                case 400...499:
                    return .http(code: code)
                    
                case 500...599:
                    return .serverError(code: code)
                    
                default:
                    return .unknown(code: code)
                }
            }
            
        case .sessionTaskFailed(let error):
            if let error = error as? URLError {
                switch error.code {
                case .timedOut:
                    return .timeout
                    
                case .secureConnectionFailed:
                    return .untrustedConnection
                    
                case .cannotConnectToHost:
                    return .connectError
                    
                case .notConnectedToInternet, .networkConnectionLost:
                    return .network
                    
                default:
                    return .unknown(code: -1)
                }
            }
            
            return .network
            
        default:
            return .unknown(code: self.responseCode ?? -1)
        }
    }
}
