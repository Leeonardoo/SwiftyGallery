//
//  HomeViewModel.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 10/12/23.
//

import Foundation
import Combine

class HomeViewModel {
    
    private let pageSize = 26
    
    private let service = PhotosService()
    
    private var subscriptions: Set<AnyCancellable> = []
    
    private var currentPage = 1
    private var endReached = false
    
    
    @Published private(set) var photos = [Photo]()
    @Published private(set) var isLoading = false
    @Published private(set) var error: NetworkError<BaseError>?
    
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
        
        isLoading = true
        error = nil
        Task {
            let result = if currentQuery.isEmpty {
                await service.fetchPhotos(page: currentPage, perPage: pageSize)
            } else {
                await service.searchPhotos(page: currentPage, perPage: pageSize, query: currentQuery)
            }
            
            switch result {
                case .success(let photos):
                    self.currentPage += 1
                    self.endReached = photos.isEmpty || photos.count < pageSize
                    let items = (self.photos + photos).unique(by: \.id)
                    await MainActor.run {
                        self.photos = items
                    }
                case .failure(let error):
                    await MainActor.run {
                        self.error = error
                    }
            }
            
            await MainActor.run {
                self.isLoading = false
            }
        }.store(in: &subscriptions)
    }
    
    func refresh() {
        currentPage = 1
        endReached = false
        photos = []
        fetchPhotos()
    }
    
    func retry() {
        fetchPhotos()
    }
}
