//
//  SingleLineDetailView.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 31/12/23.
//

import SwiftUI

class SingleLineDetailView: UIView {
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.textAlignment = .right
        return label
    }()
    
    var icon: UIImage? {
        didSet {
            self.iconView.image = icon
        }
    }
    
    var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    var detail: String? {
        didSet {
            self.detailLabel.text = detail
        }
    }
    
    init(icon: UIImage? = nil, title: String? = nil, detail: String? = nil) {
        self.icon = icon
        self.title = title
        self.detail = detail
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(detailLabel)
        
        iconView.image = icon
        titleLabel.text = title
        detailLabel.text = detail
    }
    
    private func setupConstraints() {
        iconView.snp.makeConstraints { make in
            make.size.equalTo(24)
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.leading.equalToSuperview()
            make.firstBaseline.equalTo(titleLabel.snp.firstBaseline)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(8)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview()
        }
    }
    
}

@available(iOS 17.0, *)
#Preview {
    let container = UIView()
    let view = SingleLineDetailView(icon: UIImage(systemName: "square.and.arrow.down")!, title: "Downloads", detail: "123.456.789")
    
    view.translatesAutoresizingMaskIntoConstraints = false
    container.addSubview(view)
    
    view.snp.makeConstraints { make in
        make.center.equalToSuperview()
        make.width.equalToSuperview()
    }
    
    return container
}
