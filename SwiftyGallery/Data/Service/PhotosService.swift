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
    
    func fetchPhotos(page: Int, perPage: Int, refresh: Bool = false, query: String? = nil) async -> Result<[Photo], NetworkError<NothingDecodable>> {
        let url = PhotosEndpoint.photoList(page: page, perPage: perPage, query: query)
        
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
                return .failure(failure.asNetworkError(with: NothingDecodable.self, data: response.data))
        }
    }
}
