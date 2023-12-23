//
//  PhotoDetailsViewModel.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 23/12/23.
//

import Foundation
import Combine

class PhotoDetailsViewModel {
    
    private let photoSubject: CurrentValueSubject<Photo, Never>
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
    
    init(photo: Photo) {
        self.photoSubject = CurrentValueSubject(photo)
    }
}
