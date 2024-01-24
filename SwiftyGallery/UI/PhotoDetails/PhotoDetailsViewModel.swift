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
    
    let photoSubject: CurrentValueSubject<Photo, Never>
    var photoPublisher: AnyPublisher<Photo, Never> {
        get {
            photoSubject.eraseToAnyPublisher()
        }
    }
    var photo: Photo {
        get {
            photoSubject.value
        }
    }
    
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        get {
            isLoadingSubject.eraseToAnyPublisher()
        }
    }
    var isLoading: Bool {
        get {
            isLoadingSubject.value
        }
    }
    
    private let errorSubject = CurrentValueSubject<NetworkError<NothingDecodable>?, Never>(nil)
    var errorPublisher: AnyPublisher<NetworkError<NothingDecodable>?, Never> {
        get {
            errorSubject.eraseToAnyPublisher()
        }
    }
    var error: NetworkError<NothingDecodable>? {
        get {
            errorSubject.value
        }
    }
    
    
    init(photo: Photo) {
        self.photoSubject = CurrentValueSubject(photo)
        fetchDetails(refresh: false)
    }
    
    private func fetchDetails(refresh: Bool) {
        guard !isLoading else { return }
        
        isLoadingSubject.send(true)
        errorSubject.send(nil)
        Task {
            let result = await service.fetchDetails(for: self.photo.slug, refresh: refresh)
            
            switch result {
                case .success(let photo):
                    self.photoSubject.send(photo)
                case .failure(let error):
                    self.errorSubject.send(error)
            }
            
            self.isLoadingSubject.send(false)
        }.store(in: &subscriptions)
    }
    
    func refresh() {
        fetchDetails(refresh: true)
    }
}
