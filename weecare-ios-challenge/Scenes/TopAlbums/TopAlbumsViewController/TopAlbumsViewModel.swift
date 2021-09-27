//
//  TopAlbumsViewModel.swift
//  weecare-ios-challenge
//
//  Created by Miguel Fraire on 9/24/21.
//

import UIKit

class TopAlbumsViewModel {
    
    let cache = NSCache<NSString, UIImage>()
    private let iTunesAPI: ITunesAPI
    private let networking: Networking
    
    var reloadCollectionView: (()->())?
    var showError: (()->())?
    var showLoading: (()->())?
    var hideLoading: (()->())?
    var presentAlert: ((Error)->())?
    
    lazy var albums = [Album](){
        didSet{
            reloadCollectionView?()
        }
    }
    
    lazy var topAlbumsMenu = UIMenu(title: "", children: [
        UIAction(title: "Sort by album title", image: SFSybmols.albums) { action in
            self.albums.sort { $0.name < $1.name }
        },
        UIAction(title: "Sort by artist name", image: SFSybmols.artists) { action in
            self.albums.sort { $0.artistName < $1.artistName }
        },
        UIAction(title: "Sort by release date", image: SFSybmols.releaseDates) { action in
            self.albums.sort { $0.releaseDate < $1.releaseDate }
        }
    ])
    
    init(iTunesAPI: ITunesAPI, networking: Networking){
        self.iTunesAPI = iTunesAPI
        self.networking = networking
    }
    
    func loadData(){
        showLoading?()
        iTunesAPI.getTopAlbums(limit: 10) { [weak self] res in
            guard let self = self else { return }
            self.hideLoading?()
            switch res {
            case .success(let data):
                self.albums = data.feed.results
                
            case .failure(let err):
                debugPrint(err)
                DispatchQueue.main.async {
                    self.presentAlert?(err)
                }
            }
        }
    }
    
    func downloadImage(url: String, completion: @escaping (Result<UIImage?, Error>) -> ()){
        let request = APIRequest(url: url)
        networking.requestData(request) { res in
            completion(res.map { data in UIImage(data: data) })
        }
    }
    
    func getAlbum(at indexPath: IndexPath) -> Album{
        return albums[indexPath.row]
    }
}
