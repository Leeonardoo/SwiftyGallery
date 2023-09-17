//
//  NetworkError.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 28/08/23.
//

import Foundation

/// Represents all the possible errors that are handled by the app.
///
/// - Parameters:
///   - E: The type of the error body witch should be a CustomStringConvertible
///    to be easily transformed to a String
enum NetworkError<E: Decodable & CustomStringConvertible>: LocalizedError {
    
    case errorBody(_ error: E, code: Int)
    case network
    case unknown(code: Int)
    
    /// A common description representing each state
    var localizedDescription: String {
        get {
            switch self {
                case .errorBody(let error, _):
                    let errorString = String(describing: error)
                    
                    if !errorString.isEmpty {
                        return errorString
                    } else {
                        return "Something went wrong, try again.".localized
                    }
                    
                case .network:
                    return "It looks like you're offline. Check your connection and try again.".localized
                    
                case .unknown:
                    return "Something went wrong, try again.".localized
            }
        }
    }
    
    /// A common error icon (systemName) representing each state
    var iconSystemName: String {
        return switch self {
            case .errorBody:
                "exclamationmark.octagon"
            case .network:
                "wifi.slash"
            case .unknown:
                "exclamationmark.octagon"
        }
    }
    
    /// The error code of the request or -1 if it doesn't exist
    var code: Int {
        return switch self {
            case .errorBody(_, let code):
                code
            case .network:
                -1
            case .unknown(let code):
                code
        }
    }
    
    var errorResponse: E? {
        get {
            return if case .errorBody(let error, _) = self {
                error
            } else {
                nil
            }
        }
    }
}
