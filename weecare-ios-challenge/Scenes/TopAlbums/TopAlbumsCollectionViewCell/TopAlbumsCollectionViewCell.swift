//
//  TopAlbumsCollectionViewCell.swift
//  weecare-ios-challenge
//
//  Created by Alex Livenson on 9/13/21.
//

import UIKit

final class TopAlbumsCollectionViewCell: UICollectionViewCell {
    
    static let reuseID = "TopAlbumCollectionViewCell"
    let containerView = UIView()
    let albumImageView = UIImageView()
    let stackView = UIStackView()
    let albumLabel = UILabel()
    let artistNameLabel = UILabel()
    let newAlbumIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureShadow()
        configureCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureShadow(){
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.4
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    private func configureStackView(){
        stackView.axis = .vertical
        stackView.addArrangedSubview(albumLabel)
        stackView.addArrangedSubview(artistNameLabel)
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .secondarySystemBackground
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        
        let albumFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 22 : 14
        albumLabel.numberOfLines = 2
        albumLabel.lineBreakMode = .byWordWrapping
        albumLabel.font = UIFont.systemFont(ofSize: albumFontSize, weight: .bold)

        let artistFontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 18 : 12
        artistNameLabel.numberOfLines = 1
        albumLabel.lineBreakMode = .byTruncatingTail
        artistNameLabel.font = UIFont.systemFont(ofSize: artistFontSize)
    }
    
    private func configureIcon(){
        let iconSize = contentView.frame.width * 0.25
        newAlbumIcon.frame = CGRect(x: contentView.frame.width - iconSize, y: 0, width: iconSize, height: iconSize)
        newAlbumIcon.tintColor = .systemYellow
    }
    
    private func configureCellLayout() {
        albumImageView.backgroundColor = .lightGray.withAlphaComponent(0.5)
        albumImageView.contentMode = .scaleToFill
        
        configureStackView()
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        [albumImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        configureIcon()
        albumImageView.addSubview(newAlbumIcon)
        
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // ImageView
            albumImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            albumImageView.heightAnchor.constraint(equalTo: albumImageView.widthAnchor),
            
            // Stack
            stackView.topAnchor.constraint(equalTo: albumImageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}
