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
    
    private var shadowLayer: CAShapeLayer!
    
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
        
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
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
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 12).cgPath
            
            shadowLayer.shadowColor = UIColor.darkGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 6
            shadowLayer.shadowOffset = .zero
            shadowLayer.shouldRasterize = true
            shadowLayer.rasterizationScale = UIScreen.current?.scale ?? 1
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if shadowLayer != nil {
            shadowLayer.rasterizationScale = UIScreen.current?.scale ?? 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.transform = .identity
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.transform = .identity
        }
    }
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 215, height: 350)) {
    PhotoCardCell()
}
