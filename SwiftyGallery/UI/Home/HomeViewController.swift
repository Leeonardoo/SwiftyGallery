//
//  HomeViewController.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 21/08/23.
//

import UIKit

class HomeViewController: UICollectionViewController {
    
    private lazy var dataSource = makeDataSource()
    
    private let flowLayout: UICollectionViewLayout = {
        return UICollectionViewCompositionalLayout { index, env in
            let desiredWidth: CGFloat = 230
            
            let itemCount = env.container.effectiveContentSize.width / desiredWidth
            
            let fractionWidth: CGFloat = 1 / (itemCount.rounded())
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fractionWidth), heightDimension: .absolute(280))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(280))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.edgeSpacing = .init(leading: nil, top: .fixed(8), trailing: nil, bottom: nil)
            group.interItemSpacing = .fixed(8)
            group.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
            return NSCollectionLayoutSection(group: group)
        }
    }()
    
    init() {
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Home".localized
        navigationItem.largeTitleDisplayMode = .always
        
        setupCollectionView()
        applySnapshot()
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCardCell.self, forCellWithReuseIdentifier: PhotoCardCell.identifier)
    }
}

//MARK: - DataSource
extension HomeViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Int>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Int>
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCardCell.identifier,
                    for: indexPath) as? PhotoCardCell
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([1])
        snapshot.appendItems([1, 2, 3, 4, 5, 6])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - CollectionViewDelegate
extension HomeViewController {
    
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 215, height: 350)) {
    HomeViewController()
}

