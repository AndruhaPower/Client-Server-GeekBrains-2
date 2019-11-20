//
//  PhotosCollectionViewLayout.swift
//  L1_GBVk
//
//  Created by Andrew on 10/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

final class PhotosCollectionViewLayout: UICollectionViewLayout {
    
    private var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private let columnsCount: CGFloat = 2
    private let cellHeight: CGFloat = 256
    private var totalCellHeight: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        self.cacheAttributes = [:]
        guard let collectionView = self.collectionView else { return }
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        guard itemCount > 0 else { return }
        
        let bigCellWidth = collectionView.bounds.width
        if self.columnsCount == 0 { return }
        let smallCellWidth = collectionView.bounds.width / self.columnsCount
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        for index in 0..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isBigCell = (((index + 1) % (Int(self.columnsCount) + 1)) == 0)
            
            if isBigCell {
                attributes.frame = CGRect(x: 0, y: lastY, width: bigCellWidth, height: self.cellHeight)
                lastY += self.cellHeight
            } else {
                attributes.frame = CGRect(x: lastX, y: lastY, width: smallCellWidth, height: self.cellHeight)
                
                let isLastColumn = (index + 2) % (Int(self.columnsCount) + 1) == 0 || index == (itemCount - 1)
                
                if isLastColumn {
                    lastX = 0
                    lastY += self.cellHeight
                } else {
                    lastX += smallCellWidth
                }
            }
            self.cacheAttributes[indexPath] = attributes
        }
        self.totalCellHeight = lastY
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return self.cacheAttributes.values.filter { rect.intersects($0.frame) }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return self.cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView?.bounds.width ?? 0, height: totalCellHeight)
    }
}
