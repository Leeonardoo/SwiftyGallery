//
//  PreviewContainer.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 27/09/23.
//

import SwiftUI
import UIKit

struct PreviewContainer<T: UIView>: UIViewRepresentable {
    
    let view: T
    
    init(_ viewBuilder: @escaping () -> T) {
        
        view = viewBuilder()
    }
    
    // MARK: - UIViewRepresentable
    func makeUIView(context: Context) -> T {
        return view
    }
    
    func updateUIView(_ view: T, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
