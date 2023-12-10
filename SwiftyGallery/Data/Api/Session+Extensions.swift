//
//  Session+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 29/08/23.
//

import Foundation
import Alamofire

#if DEBUG
import Pulse
#endif

extension Session {
    static let app = {
#if DEBUG
        URLSessionProxyDelegate.enableAutomaticRegistration()
        Experimental.URLSessionProxy.shared.isEnabled = true
#endif
        return Session(configuration: URLSessionConfiguration.af.default)
    }()
}
