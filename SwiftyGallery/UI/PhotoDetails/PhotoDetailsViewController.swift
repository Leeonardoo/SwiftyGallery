//
//  PhotoDetailsViewController.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 23/12/23.
//

import UIKit
import Combine
import SwiftUI
import SnapKit
import NukeUI
import Nuke

class PhotoDetailsViewController: UIViewController {
    
    private let viewModel: PhotoDetailsViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alwaysBounceVertical = true
        
        return view
    }()
    
    private let imageView: LazyImageView = {
        let view = LazyImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.contentMode = .scaleAspectFill
        view.placeholderView = nil
        view.clipsToBounds = true
        
        return view
    }()
    
    init(photo: Photo) {
        self.viewModel = PhotoDetailsViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Details".localized
        navigationItem.largeTitleDisplayMode = .never
        
        setupViews()
        setupConstraints()
        setupObservers()
    }
    
    private func setupObservers() {
        viewModel.photoPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photo in
                guard let self = self else { return }
                configure(with: photo)
            }
            .store(in: &subscriptions)
    }
    
    private func configure(with photo: Photo) {
        imageView.request = ImageRequest(url: URL(string: photo.urls.regular)!)
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.8)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    let navController = UINavigationController(rootViewController: PhotoDetailsViewController(photo: demoPhoto))
    
    return navController
}
