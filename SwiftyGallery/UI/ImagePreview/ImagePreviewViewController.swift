//
//  ImagePreviewViewController.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 28/12/23.
//

import SwiftUI
import Nuke

class ImagePreviewViewController : UIViewController {
    
    private let imageURL: URL
    
    private let zoomableImageView: ZoomableImageView = {
        let imageView = ZoomableImageView()
        return imageView
    }()
    
    init(imageURL: URL) {
        self.imageURL = imageURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Preview".localized
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnTap = true
        navigationController?.barHideOnTapGestureRecognizer.canBePrevented(by: zoomableImageView.doubleTapRecognizer)
        zoomableImageView.doubleTapRecognizer.delegate = self
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        
        navigationItem.scrollEdgeAppearance = navBarAppearance
        
        setupViews()
        setupConstraints()
        
        zoomableImageView.imageView.request = ImageRequest(url: imageURL)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            if let scrollView = self?.zoomableImageView {
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            }
        }, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(zoomableImageView)
    }
    
    private func setupConstraints() {
        zoomableImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ImagePreviewViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        otherGestureRecognizer == navigationController?.barHideOnTapGestureRecognizer
    }
}

@available(iOS 17.0, *)
#Preview {
    ImagePreviewViewController(imageURL: URL(string: demoPhoto.urls.full)!)
}
