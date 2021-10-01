//
//  TopAlbumsViewController.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

final class TopAlbumsViewController: DataLoadingViewController {
    
    private var viewModel: TopAlbumsViewModel
    private var collectionView: UICollectionView!
    
    init(viewModel: TopAlbumsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Top Albums"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        initViewModel()
    }
    
    private func configureViewController(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .organize, primaryAction: .none, menu: viewModel.topAlbumsMenu)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: FlowLayout.createTwoColumnFlowLayout(in: view))
        collectionView.register(TopAlbumsCollectionViewCell.self, forCellWithReuseIdentifier: TopAlbumsCollectionViewCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        view.addSubview(collectionView)
    }
    
    private func initViewModel() {
        viewModel.reloadCollectionView = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.presentAlert = { err in
            let alert = UIAlertController(title: "Network Error", message: err.localizedDescription, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        viewModel.showLoading = { self.showLoadingView() }
        
        viewModel.hideLoading = { self.dismissLoadingView() }
        
        viewModel.loadData()
    }
}

// MARK: - UICollectionView DataSource & Delegate Methods

extension TopAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopAlbumsCollectionViewCell.reuseID, for: indexPath) as! TopAlbumsCollectionViewCell
        let cellAlbum = viewModel.getAlbum(at: indexPath)
        cell.artistNameLabel.text = cellAlbum.artistName
        cell.albumLabel.text = cellAlbum.name
        cell.newAlbumIcon.image = cellAlbum.releaseDate.isInThisWeek ? Images.newAlbumIcon : nil
        
        if let imageURL = cellAlbum.artworkUrl100 {
            if let image = viewModel.cache.object(forKey: imageURL as NSString) {
               cell.albumImageView.image = image
           } else {
               viewModel.downloadImage(url: imageURL) { [weak self] res in
                   guard let self = self else { return }
                   switch res {
                   case .success(let image):
                       guard let image = image else { return }
                       self.viewModel.cache.setObject(image, forKey: imageURL as NSString)
                       DispatchQueue.main.async { cell.albumImageView.image = image }
                       
                   case .failure(let err):
                       debugPrint(err)
                   }
               }
           }
        }
        
        return cell
    }
}


