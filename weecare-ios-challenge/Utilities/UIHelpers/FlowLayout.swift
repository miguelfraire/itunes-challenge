//
//  FlowLayout.swift
//  weecare-ios-challenge
//
//  Created by Miguel Fraire on 9/25/21.
//

import Foundation
import UIKit

enum FlowLayout {
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let viewWidth = view.frame.width,
            numberOfItemsPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 3 : 2,
            minimumItemSpacing: CGFloat = 10,
            padding: CGFloat = 10,
            availableWidth = viewWidth - (padding * 2) - (minimumItemSpacing * 2),
            itemWidth = availableWidth / numberOfItemsPerRow

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.4)
        flowLayout.sectionInsetReference = .fromSafeArea
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.scrollDirection = .vertical

        return flowLayout
    }
}
