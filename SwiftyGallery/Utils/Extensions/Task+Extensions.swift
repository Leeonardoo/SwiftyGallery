//
//  Task+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 10/12/23.
//

import Combine

extension Task {
    func store(in set: inout Set<AnyCancellable>) {
        set.insert(AnyCancellable(cancel))
    }
}
