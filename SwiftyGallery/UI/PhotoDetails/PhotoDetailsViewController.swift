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
import SafariServices

//Views
//Downloads
//Date
//Camera
//Location

//Favorite button (somewhere)
//Download button and select size (menu)

//Zoom image in another screen
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
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let userImageView: LazyImageView = {
        let view = LazyImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.contentMode = .scaleAspectFill
        view.placeholderView = nil
        view.clipsToBounds = true
        view.processors = [ImageProcessors.Circle()]
        
        return view
    }()
    
    private lazy var userDetailsContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [userNameLabelView, userSubtitleContainer])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 2
        
        return view
    }()
    
    private let userNameLabelView: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .subheadline, weight: .medium)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .label
        
        return view
    }()
    
    private lazy var userSubtitleContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [userSubtitleLabelView, userSubtitleIconView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = 4
        
        return view
    }()
    
    private let userSubtitleLabelView: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .footnote)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .secondaryLabel
        
        return view
    }()
    
    private let userSubtitleIconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let descriptionLabelView: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .body)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .label
        
        return view
    }()
    
    init(photo: Photo) {
        self.viewModel = PhotoDetailsViewModel(photo: photo)
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Details".localized
        navigationItem.largeTitleDisplayMode = .never
        
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupObservers()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "square.and.arrow.up"),
                primaryAction: UIAction(handler: { [weak self] action in
                    guard let self = self,
                          let url = URL(string: viewModel.photo.links.html) else { return }
                    
                    let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                    activityViewController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItems?.first
                    self.present(activityViewController, animated: true)
                })
            )
        ]
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
        imageView.request = ImageRequest(url: URL(string: photo.urls.full)!)
        let imageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(imageTapGestureRecognizer)
        
        userImageView.request = ImageRequest(url: URL(string: photo.user.profileImage.large)!)
        
        userSubtitleIconView.isHidden = !photo.user.forHire && photo.sponsorship?.tagline == nil
        
        userNameLabelView.text = photo.plus ? "Unsplash+" : photo.user.name
        userSubtitleLabelView.textColor = photo.user.forHire && !photo.plus ? .tintColor : .secondaryLabel
        
        if photo.plus {
            let attributedString = NSMutableAttributedString()
            attributedString.append(
                NSAttributedString(string: "In collaboration with".localized + " ")
            )
            attributedString.append(
                NSAttributedString(string: photo.user.name,
                                   attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                .underlineColor: UIColor.tintColor,
                                                .foregroundColor: UIColor.tintColor])
            )
            
            userSubtitleLabelView.attributedText = attributedString
        } else if photo.user.forHire {
            userSubtitleLabelView.text = "Available for hire".localized
            userSubtitleIconView.image = UIImage(systemName: "checkmark.circle.fill",
                                                 withConfiguration: UIImage.SymbolConfiguration(pointSize: userSubtitleLabelView.font.pointSize)
            )
            
            userSubtitleIconView.tintColor = .tintColor
        } else if let sponsorship = photo.sponsorship {
            userSubtitleLabelView.text = sponsorship.tagline
            
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(didTapSponsorshipTagline)
            )
            userSubtitleLabelView.addGestureRecognizer(tapGestureRecognizer)
            userSubtitleLabelView.isUserInteractionEnabled = true
            
            userSubtitleIconView.image = UIImage(systemName: "arrow.up.forward",
                                                 withConfiguration: UIImage.SymbolConfiguration(pointSize: userSubtitleLabelView.font.pointSize))
            
            userSubtitleIconView.tintColor = .secondaryLabel
        } else {
            userSubtitleLabelView.text = photo.user.username
        }
        
        descriptionLabelView.text = photo.description
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(userImageView)
        scrollView.addSubview(userDetailsContainer)
        scrollView.addSubview(descriptionLabelView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.7)
        }
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.size.equalTo(42)
        }
        
        userDetailsContainer.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(userImageView)
            make.bottom.lessThanOrEqualTo(userImageView)
            make.centerY.equalTo(userImageView)
            make.leading.equalTo(userImageView.snp.trailing).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        userNameLabelView.setContentHuggingPriority(.required, for: .horizontal)
        userNameLabelView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        userSubtitleIconView.setContentHuggingPriority(.required, for: .horizontal)
        userSubtitleIconView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        descriptionLabelView.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
    }
    
    @objc private func didTapSponsorshipTagline() {
        guard let sponsorship = viewModel.photo.sponsorship,
              let url = URL(string: sponsorship.taglineUrl) else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        present(safariViewController, animated: true)
    }
    
    @objc private func didTapImage() {
        guard let url = URL(string: viewModel.photo.urls.full) else { return }
        
        let vc = ImagePreviewViewController(imageURL: url)
        navigationController?.pushViewController(vc, animated: true)
    }
}

@available(iOS 17.0, *)
#Preview {
    let navController = UINavigationController(rootViewController: PhotoDetailsViewController(photo: demoPhoto))
    
    return navController
}
