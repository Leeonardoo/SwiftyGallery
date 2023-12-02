//
//  PhotoCardBig.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 17/09/23.
//

import UIKit
import SwiftUI
import SnapKit
import NukeUI
import Nuke

/*
 {
 "id": "6NAbqcv3fpg",
 "slug": "a-valley-with-a-river-running-through-it-6NAbqcv3fpg",
 "created_at": "2023-09-24T01:05:02Z",
 "updated_at": "2023-09-28T14:50:55Z",
 "promoted_at": "2023-09-26T10:32:01Z",
 "width": 6881,
 "height": 4587,
 "color": "#404040",
 "blur_hash": "LDAm;lD%WARj_NITWCay-@D%afoe",
 "description": "Horseshoe Bend",
 "alt_description": "a valley with a river running through it",
 "breadcrumbs": [],
 "urls": {
 "raw": "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA\u0026ixlib=rb-4.0.3",
 "full": "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy\u0026cs=srgb\u0026fm=jpg\u0026ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA\u0026ixlib=rb-4.0.3\u0026q=85",
 "regular": "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA\u0026ixlib=rb-4.0.3\u0026q=80\u0026w=1080",
 "small": "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA\u0026ixlib=rb-4.0.3\u0026q=80\u0026w=400",
 "thumb": "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy\u0026cs=tinysrgb\u0026fit=max\u0026fm=jpg\u0026ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA\u0026ixlib=rb-4.0.3\u0026q=80\u0026w=200",
 "small_s3": "https://s3.us-west-2.amazonaws.com/images.unsplash.com/small/photo-1695515115475-dc5495581ea8"
 },
 "links": {
 "self": "https://api.unsplash.com/photos/a-valley-with-a-river-running-through-it-6NAbqcv3fpg",
 "html": "https://unsplash.com/photos/a-valley-with-a-river-running-through-it-6NAbqcv3fpg",
 "download": "https://unsplash.com/photos/6NAbqcv3fpg/download?ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA",
 "download_location": "https://api.unsplash.com/photos/6NAbqcv3fpg/download?ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA"
 },
 "likes": 65,
 "liked_by_user": false,
 "current_user_collections": [],
 "sponsorship": null,
 "topic_submissions": {},
 "premium": false,
 "plus": false,
 "user": {
 "id": "dg4S8j5TzmE",
 "updated_at": "2023-09-28T21:42:35Z",
 "username": "karsten116",
 "name": "Karsten Winegeart",
 "first_name": "Karsten",
 "last_name": "Winegeart",
 "twitter_username": "karsten116",
 "portfolio_url": null,
 "bio": "IG - @karsten116",
 "location": "Austin Texas",
 "links": {
 "self": "https://api.unsplash.com/users/karsten116",
 "html": "https://unsplash.com/@karsten116",
 "photos": "https://api.unsplash.com/users/karsten116/photos",
 "likes": "https://api.unsplash.com/users/karsten116/likes",
 "portfolio": "https://api.unsplash.com/users/karsten116/portfolio",
 "following": "https://api.unsplash.com/users/karsten116/following",
 "followers": "https://api.unsplash.com/users/karsten116/followers"
 },
 "profile_image": {
 "small": "https://images.unsplash.com/profile-1583427783052-3da8ceab5579image?ixlib=rb-4.0.3\u0026crop=faces\u0026fit=crop\u0026w=32\u0026h=32",
 "medium": "https://images.unsplash.com/profile-1583427783052-3da8ceab5579image?ixlib=rb-4.0.3\u0026crop=faces\u0026fit=crop\u0026w=64\u0026h=64",
 "large": "https://images.unsplash.com/profile-1583427783052-3da8ceab5579image?ixlib=rb-4.0.3\u0026crop=faces\u0026fit=crop\u0026w=128\u0026h=128"
 },
 "instagram_username": "karsten116",
 "total_collections": 1,
 "total_likes": 635,
 "total_photos": 774,
 "accepted_tos": true,
 "for_hire": true,
 "social": {
 "instagram_username": "karsten116",
 "portfolio_url": null,
 "twitter_username": "karsten116",
 "paypal_email": null
 }
 }
 }
 */

class PhotoCardCell: UICollectionViewCell {
    
    static let identifier = "PhotoCardCell"
    
    private let imageView: LazyImageView = {
        let view = LazyImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        
        view.request = ImageRequest(url: URL(string: "https://images.unsplash.com/photo-1695515115475-dc5495581ea8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxhbGx8NDJ8fHx8fHwyfHwxNjk1OTQwMzM4fA&ixlib=rb-4.0.3&q=80&w=400")!)
        
        return view
    }()
    
    private let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
    
    private lazy var bottomBlurView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        return blurEffectView
    }()
    
    private let bottomContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let profileImageView: LazyImageView = {
        let view = LazyImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.imageView.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.processors = [ImageProcessors.Circle()]
        
        view.request = ImageRequest(url: URL(string: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3wxMjA3fDB8MXxzZWFyY2h8M3x8cHJvZmlsZXxlbnwwfHx8fDE2OTYyMDE2NzV8MA&ixlib=rb-4.0.3&q=80&w=400")!)
        
        return view
    }()
    
    private let userLabelView: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Karsten Winegeart"
        view.font = .preferredFont(forTextStyle: .caption1, weight: .medium)
        view.adjustsFontForContentSizeCategory = true
        view.textColor = .white
        
        return view
    }()
    
    private let favoriteButton: UIButton = {
        let view = UIButton(type: .system)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .white
        
        //        view.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        //        view.tintColor = .systemRed
        
        return view
    }()
    
    private lazy var buttonBlurView: UIVisualEffectView = {
        let blurEffectView = CustomIntensityVisualEffectView(effect: blurEffect, intensity: 0.4)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.clipsToBounds = true
        
        return blurEffectView
    }()
    
    private let favoriteContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        setupViews()
        configureConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        
        contentView.addSubview(bottomBlurView)
        bottomBlurView.contentView.addSubview(bottomContentView)
        bottomContentView.addSubview(profileImageView)
        bottomContentView.addSubview(userLabelView)
        
        contentView.addSubview(buttonBlurView)
        buttonBlurView.contentView.addSubview(favoriteContentView)
        favoriteContentView.addSubview(favoriteButton)
        
        self.contentView.layer.cornerRadius = 12
        self.contentView.clipsToBounds = true
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        bottomBlurView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(6)
            make.bottom.lessThanOrEqualToSuperview().inset(5)
            make.leading.equalToSuperview().inset(6)
            make.size.equalTo(28)
        }
        
        userLabelView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.trailing.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).inset(-6)
        }
        
        favoriteContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        buttonBlurView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(8)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
            make.size.equalTo(24)
        }
        
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        buttonBlurView.layer.cornerRadius = buttonBlurView.frame.width / 2
    }
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 215, height: 350)) {
    PhotoCardCell()
}

class CustomIntensityVisualEffectView: UIVisualEffectView {
    
    /// Create visual effect view with given effect and its intensity
    ///
    /// - Parameters:
    ///   - effect: visual effect, eg UIBlurEffect(style: .dark)
    ///   - intensity: custom intensity from 0.0 (no effect) to 1.0 (full effect) using linear scale
    init(effect: UIVisualEffect, intensity: CGFloat) {
        super.init(effect: nil)
        animator = UIViewPropertyAnimator(duration: 0, curve: .linear) { [unowned self] in self.effect = effect }
        animator.fractionComplete = intensity
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: Private
    private var animator: UIViewPropertyAnimator!
    
}
