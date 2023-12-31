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
    
    private var currentQuery = ""
    let searchSubject = PassthroughSubject<String, Never>()
    
    init() {
        fetchPhotos()
        
        searchSubject
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] query in
                guard let self else { return }
                
                if query != currentQuery {
                    currentQuery = query
                    refresh()
                }
            }.store(in: &subscriptions)
    }
    
    func fetchPhotos() {
        guard !isLoading, !endReached else { return }
        
        isLoadingSubject.send(true)
        errorSubject.send(nil)
        Task {
            let result = if currentQuery.isEmpty {
                await service.fetchPhotos(page: currentPage, perPage: 26)
            } else {
                await service.searchPhotos(page: currentPage, perPage: 26, query: currentQuery)
            }
            
            switch result {
                case .success(let photos):
                    self.currentPage += 1
                    self.endReached = photos.isEmpty || photos.count < 26
                    let items = (self.photos + photos).unique(by: \.id)
                    self.photosSubject.send(items)
                case .failure(let error):
                    self.errorSubject.send(error)
            }
            
            self.isLoadingSubject.send(false)
        }.store(in: &subscriptions)
    }
    
    func refresh() {
        currentPage = 1
        endReached = false
        photosSubject.send([])
        fetchPhotos()
    }
    
    func retry() {
        fetchPhotos()
    }
}
