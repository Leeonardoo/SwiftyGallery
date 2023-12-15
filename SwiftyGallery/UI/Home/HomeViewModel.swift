//
//  HomeViewModel.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 10/12/23.
//

import Foundation
import Combine

class HomeViewModel {
    
    private let service = PhotosService()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private var currentPage = 1
    private var endReached = false
    
    private let photosSubject = CurrentValueSubject<[Photo], Never>([])
    var photosPublisher: AnyPublisher<[Photo], Never> {
        get {
            photosSubject.eraseToAnyPublisher()
        }
    }
    var photos: [Photo] {
        get {
            photosSubject.value
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
    
    init() {
        fetchPhotos()
    }
    
    func fetchPhotos() {
        guard !isLoading, !endReached else { return }
        
        isLoadingSubject.send(true)
        Task {
            let result = await service.fetchPhotos(page: currentPage, perPage: 20)
            
            switch result {
                case .success(let photos):
                    self.currentPage += 1
                    self.endReached = photos.isEmpty || photos.count < 20
                    self.photosSubject.send(self.photos + photos)
                case .failure(let error):
                    self.errorSubject.send(error)
            }
            
            self.isLoadingSubject.send(false)
        }.store(in: &subscriptions)
    }
    
    func refresh() {
        currentPage = 1
        endReached = false
        fetchPhotos()
    }
    
    func retry() {
        fetchPhotos()
    }
}
