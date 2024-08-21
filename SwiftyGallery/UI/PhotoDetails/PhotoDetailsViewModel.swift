//
//  PhotoDetailsViewModel.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 23/12/23.
//

import Foundation
import Combine

class PhotoDetailsViewModel {
    
    private let service = PhotosService()
    private var subscriptions: Set<AnyCancellable> = []
    
    @Published private(set) var photo: Photo
    @Published private(set) var isLoading = false
    @Published private(set) var error: NetworkError<BaseError>?
    
    init(photo: Photo) {
        self.photo = photo
        fetchDetails(refresh: false)
    }
    
    private func fetchDetails(refresh: Bool) {
        guard !isLoading else { return }
        
        if (isLoading) {
            return
        }
        
        isLoading = true
        error = nil
        Task {
            let result = await service.fetchDetails(for: photo.slug, refresh: refresh)
            
            switch result {
                case .success(let photo):
                    await MainActor.run {
                        self.photo = photo
                    }
                case .failure(let error):
                    await MainActor.run {
                        self.error = error
                    }
            }
            
            await MainActor.run {
                isLoading = false
            }
        }.store(in: &subscriptions)
    }
    
    func refresh() {
        fetchDetails(refresh: true)
    }
}
