//
//  PhotosService.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 07/12/23.
//

import Foundation
import Alamofire
import OSLog

struct PhotosService {
    
    func fetchPhotos(page: Int, perPage: Int, refresh: Bool = false) async -> Result<[Photo], NetworkError<UnsplashError>> {
        let url = PhotosEndpoint.photoList(page: page, perPage: perPage)
        
        if refresh {
            try? URLCache.shared.removeCachedResponse(for: url.asURLRequest())
        }
        
        let dataTask = Session.app.request(url)
            .validate()
            .serializingDecodable([Photo].self, automaticallyCancelling: true, decoder: JSONDecoder.defaultDecoder)
        
        let response = await dataTask.response
        
        switch response.result {
            case .success(let success):
                return .success(success)
            case .failure(let failure):
                return .failure(failure.asNetworkError(with: UnsplashError.self, data: response.data))
        }
    }
    
    func searchPhotos(page: Int, perPage: Int, refresh: Bool = false, query: String) async -> Result<[Photo], NetworkError<UnsplashError>> {
        let url = PhotosEndpoint.photoSearch(page: page, perPage: perPage, query: query)
        
        if refresh {
            try? URLCache.shared.removeCachedResponse(for: url.asURLRequest())
        }
        
        let dataTask = Session.app.request(url)
            .validate()
            .serializingDecodable(PhotosResult.self, automaticallyCancelling: true, decoder: JSONDecoder.defaultDecoder)
        
        let response = await dataTask.response
        
        switch response.result {
            case .success(let success):
                return .success(success.results)
            case .failure(let failure):
                return .failure(failure.asNetworkError(with: UnsplashError.self, data: response.data))
        }
    }
    
    func fetchDetails(for slug: String, refresh: Bool = false) async -> Result<Photo, NetworkError<UnsplashError>> {
        let url = PhotosEndpoint.photoDetails(slug: slug)
        
        if refresh {
            try? URLCache.shared.removeCachedResponse(for: url.asURLRequest())
        }
        
        let dataTask = Session.app.request(url)
            .validate()
            .serializingDecodable(Photo.self, automaticallyCancelling: true, decoder: JSONDecoder.defaultDecoder)
        
        let response = await dataTask.response
        
        switch response.result {
            case .success(let success):
                return .success(success)
            case .failure(let failure):
                return .failure(failure.asNetworkError(with: UnsplashError.self, data: response.data))
        }
    }
}
