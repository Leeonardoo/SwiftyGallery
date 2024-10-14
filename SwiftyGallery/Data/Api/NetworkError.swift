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
enum NetworkError<E: ErrorMapper>: LocalizedError {
    
    case errorBody(_ error: E, code: Int)
    case http(code: Int)
    case internalServerError
    case serverError(code: Int)
    case network
    case connectError
    case timeout
    case notFound
    case responseSerialization(code: Int)
    case untrustedConnection
    case unknown(code: Int)
    
    /// A common description representing each state
    var localizedDescription: String {
        get {
            switch self {
            case .errorBody(let error, _):
                let errorString = String(describing: error)
                return errorString
                
            case .http(let code):
                return "The server was unable to process your request. Check the information or contact support. Error: \(code)"
                
            case .internalServerError:
                return "An internal server error occurred. Try again or contact support. Error: 500"
                
            case .serverError(let code):
                return "Some error happened on the server. Try again or contact support. Error: \(code)"
                
            case .network:
                return "Something went wrong. The server might be offline or your connection may be unstable. Try again."
                
            case .connectError:
                return "Unable to connect. The server might be offline or your connection may be unstable. Please try again."
                
            case .timeout:
                return "Timeout. Processing took longer than allowed, try again or contact support."
                
            case .notFound:
                return "We couldn't find the content you're looking for. Please try again."
                
            case .responseSerialization:
                return "The server sent invalid data. Check if the app is updated and try again or contact support."
                
            case .untrustedConnection:
                return "The connection to the server was not validated and for security reasons we won't continue. Please check if the date and time are correct and try again or contact support."
                
            case .unknown:
                return "Something went wrong. Check the information and try again."
            }
        }
    }
    
    /// A common error icon (systemName) representing each state
    var iconSystemName: String {
        switch self {
        case .errorBody, .http(_), .internalServerError, .serverError(_):
            return "exclamationmark.octagon"
        case .network, .connectError, .timeout:
            return "wifi.slash"
        case .notFound, .responseSerialization(_):
            return "rectangle.portrait.slash"
        case .untrustedConnection:
            return "lock.slash"
        case .unknown:
            return "exclamationmark.octagon"
        }
    }
    
    /// The error code of the request or -1 if it doesn't exist
    var code: Int {
        switch self {
        case .errorBody(_, let code):
            return code
        case .http(let code):
            return code
        case .internalServerError:
            return 500
        case .serverError(let code):
            return code
        case .network, .connectError, .timeout:
            return -1
        case .notFound:
            return 404
        case .responseSerialization:
            return -1
        case .untrustedConnection:
            return -1
        case .unknown:
            return -1
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
