//
//  Paging.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 12/12/23.
//

import Foundation

enum PagingState<Content, Failure> {
    case loading(Content)
    case success(Content)
    case error(Content, Failure)
}
