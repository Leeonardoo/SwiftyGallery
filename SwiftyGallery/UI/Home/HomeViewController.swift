//
//  HomeViewController.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 21/08/23.
//

import UIKit
import Combine
import Nuke
import OSLog

class HomeViewController: UICollectionViewController {
    
    private let viewModel = HomeViewModel()
    private var subscriptions: Set<AnyCancellable> = []
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
    
    private lazy var searchController = UISearchController(searchResultsController: nil)
    private let prefetcher = ImagePrefetcher(destination: .diskCache)
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        return view
    }()
    
    private lazy var errorIcon: UIImageView = {
        let configuration = UIImage.SymbolConfiguration(paletteColors: [.systemGray])
        let view = UIImageView(image: UIImage(systemName: "exclamationmark.triangle.fill",
                                              withConfiguration: configuration))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var errorLabel: UILabel = {
        let view = UILabel()
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.textColor = .secondaryLabel
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var errorContainer: UIStackView = {
        let view = UIStackView(arrangedSubviews: [errorIcon, errorLabel])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .center
        
        return view
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
        collectionView.keyboardDismissMode = .onDrag
        collectionView.isPrefetchingEnabled = true
        collectionView.prefetchDataSource = self
        
        setupViews()
        setupConstraints()
        setupCollectionView()
        setupSearchController()
        applySnapshot()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = traitCollection.verticalSizeClass == .compact
        
        if traitCollection.verticalSizeClass != .compact {
            navigationController?.isNavigationBarHidden = false
        }
        
        prefetcher.priority = .normal
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.isNavigationBarHidden = false
        prefetcher.priority = .veryLow
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        Logger.viewController.info("verticalSizeClass compact: \(self.traitCollection.verticalSizeClass == .compact)")
        navigationController?.hidesBarsOnSwipe = traitCollection.verticalSizeClass == .compact
        
        if traitCollection.verticalSizeClass != .compact {
            navigationController?.isNavigationBarHidden = false
        }
    }
    
    private func setupObservers() {
        viewModel.$photos
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photos in
                self?.applySnapshot(photos: photos)
            }.store(in: &subscriptions)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                
                if viewModel.photos.isEmpty && isLoading {
                    activityIndicator.startAnimating()
                    activityIndicator.isHidden = false
                } else {
                    activityIndicator.stopAnimating()
                    activityIndicator.isHidden = true
                }
            }.store(in: &subscriptions)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                
                guard let error = error else {
                    errorContainer.isHidden = true
                    return
                }
                guard viewModel.photos.isEmpty else {
                    errorContainer.isHidden = true
                    return
                }
                
                errorContainer.isHidden = false
                errorLabel.text = error.localizedDescription
                
                let configuration = UIImage.SymbolConfiguration(paletteColors: [.systemGray])
                errorIcon.image = UIImage(systemName: error.iconSystemName,
                                          withConfiguration: configuration)
            }
            .store(in: &subscriptions)
    }
    
    private func setupCollectionView() {
        collectionView.register(PhotoCardCell.self, forCellWithReuseIdentifier: PhotoCardCell.identifier)
    }
    
    private func setupViews() {
        view.addSubview(activityIndicator)
        view.addSubview(errorContainer)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.automaticallyShowsSearchResultsController = true
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchBar.placeholder = "Search".localized
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        errorIcon.snp.makeConstraints { make in
            make.size.equalTo(40)
        }
        errorContainer.snp.makeConstraints { make in
            make.top.greaterThanOrEqualToSuperview().inset(32)
            make.bottom.lessThanOrEqualToSuperview().inset(32)
            make.leading.greaterThanOrEqualToSuperview().inset(32)
            make.trailing.lessThanOrEqualToSuperview().inset(32)
            make.center.equalToSuperview()
        }
    }
}

//MARK: - SearchController
extension HomeViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchSubject.send(searchController.searchBar.text ?? "")
    }
}

//MARK: - DataSource
extension HomeViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Photo>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Photo>
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCardCell.identifier,
                    for: indexPath) as? PhotoCardCell
                cell?.photo = item
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true, photos: [Photo]? = nil) {
        var snapshot = Snapshot()
        snapshot.appendSections([1])
        snapshot.appendItems(photos ?? [])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - CollectionViewDelegate
extension HomeViewController {
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photo = (cell as? PhotoCardCell)?.photo {
            let urls = [URL(string: photo.user.profileImage.large),
                        URL(string: photo.urls.full)].compactMap { $0 }
            
            prefetcher.startPrefetching(with: urls)
            
            if indexPath.row == viewModel.photos.count - 8 {
                viewModel.fetchPhotos()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let photo = (cell as? PhotoCardCell)?.photo {
            let urls = [URL(string: photo.user.profileImage.large),
                        URL(string: photo.urls.full)].compactMap { $0 }
            
            prefetcher.stopPrefetching(with: urls)
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = viewModel.photos[indexPath.row]
        let viewController = PhotoDetailsViewController(photo: photo)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}

//MARK: - TabBarReselectHandler
extension HomeViewController : TabBarReselectHandler {
    
    func didReselectTab() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

//MARK: - PrefetchDataSource
extension HomeViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let photos = indexPaths.map { viewModel.photos[$0.row] }
        let urls = photos.flatMap { photo in
            [URL(string: photo.user.profileImage.small),
             URL(string: photo.user.profileImage.large),
             URL(string: photo.urls.regular),
             URL(string: photo.urls.full)]
        }.compactMap { $0 }
        
        prefetcher.startPrefetching(with: urls)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        let photos = indexPaths.map { viewModel.photos[$0.row] }
        let urls = photos.flatMap { photo in
            [URL(string: photo.user.profileImage.small),
             URL(string: photo.user.profileImage.large),
             URL(string: photo.urls.regular),
             URL(string: photo.urls.full)]
        }.compactMap { $0 }
        
        prefetcher.stopPrefetching(with: urls)
    }
}

@available(iOS 17.0, *)
#Preview(traits: .fixedLayout(width: 215, height: 350)) {
    UINavigationController(rootViewController: HomeViewController())
}

