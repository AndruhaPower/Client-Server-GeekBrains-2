//
//  FullScreenImagePresenterViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 24/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class FullScreenImagePresenterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var fullScreenCollectionView: UICollectionView!
private let reuseIdentifier = "fullScreenCollectionViewCellIdentifier"
    var friendToDisplay: RFriend?
    var imagesToDisplay: [UIImage] = []
    var indexPathToScrollTo = IndexPath(row:0, section:0)
    var newCellIndexPath = IndexPath(row: 0, section: 0)
    var oldCellIndexPath = IndexPath(row: 0, section: 0)
    var scrollChangedDirection: Bool = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fullScreenCollectionView.dataSource = self
        fullScreenCollectionView.delegate = self
        
        setupCollectionViewAppearance()
        
        fullScreenCollectionView.scrollToItem(at: indexPathToScrollTo, at:UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedToDismiss))
        
        swipeDown.delegate = self
        //swipeDown.delegate = fullScreenCollectionView as? UIGestureRecognizerDelegate
        view.addGestureRecognizer(swipeDown)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let image = imagesToDisplay[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FullScreenCollectionViewCell
        cell.friendsImageView.image = image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //update new cell index for scroll direction detection
        newCellIndexPath = indexPath
        //print("from cell: \(oldCellIndexPath) to cell: \(newCellIndexPath)")
        
        //detect scroll direction by indexPath change
        var scroll = ScrollDirection.right
        
        if (newCellIndexPath.row - oldCellIndexPath.row > 0) {
            scroll = ScrollDirection.right
        } else if (newCellIndexPath.row - oldCellIndexPath.row < 0) {
            scroll = ScrollDirection.left
        }
        
        if (oldCellIndexPath.row == imagesToDisplay.count - 1) {
            scroll = ScrollDirection.left
        }
        
        //fade-in new cell
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1) {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            //debug - cell borders ON, uncomment below
            //      cell.layer.borderColor = UIColor.white.cgColor
            //      cell.layer.borderWidth = 5.0
        }
        
        switch scroll {
            
        case .right:
            //print("scroll right")
            
            //fade-out old cell
            if (indexPath.row > 0) {
                let oldIndexPath = IndexPath(row: indexPath.row - 1, section: 0)
                if let oldCell = collectionView.cellForItem(at: oldIndexPath) {
                    UIView.animate(withDuration: 0.8) {
                        oldCell.alpha = 0.5
                        oldCell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    }
                }
            }
            
        case .left:
            //print("scroll left")
            
            //fade-out old cell
            if (indexPath.row < imagesToDisplay.count - 1) {
                let oldIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
                if let oldCell = collectionView.cellForItem(at: oldIndexPath) {
                    UIView.animate(withDuration: 0.8) {
                        oldCell.alpha = 0.5
                        oldCell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    }
                }
            }
        }
        oldCellIndexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            
            UIView.animate(withDuration: 0.5,
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                            cell.alpha = 0
            },
                           completion: { _ in
                            self.dismiss(animated: true, completion: nil)
            })
            
        }
    }
   //////////
    private func setupCollectionViewAppearance() {
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.scrollDirection = .horizontal
        
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        if (width < height) {
            flowLayout.minimumLineSpacing = 0
            flowLayout.itemSize = CGSize(width: width, height: width)
            
        } else {
            flowLayout.minimumLineSpacing = width/2
            flowLayout.itemSize = CGSize(width: height, height: height)
        }
        
        fullScreenCollectionView.collectionViewLayout = flowLayout
        fullScreenCollectionView.backgroundColor = .black
        fullScreenCollectionView.isPagingEnabled = true
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            setupCollectionViewAppearance()
        } else {
            setupCollectionViewAppearance()
        }
    }
    
    @objc func swipedToDismiss() {
        if let cell = fullScreenCollectionView.cellForItem(at: newCellIndexPath) {
            print("swiped down to dismiss")
            UIView.animate(withDuration: 0.5,
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                            cell.alpha = 0
            },
                           completion: { _ in
                            self.dismiss(animated: true, completion: nil)
            })
            
        }
    }
    
}

//MARK: Extensions
extension FullScreenImagePresenterViewController {
    enum ScrollDirection {
        case right
        case left
    }
}

extension FullScreenImagePresenterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
