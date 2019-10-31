//
//  FullScreenImagePresenterViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 24/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//


import UIKit

final class FullScreenImagePresenterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let reuseIdentifier = "fullScreenCollectionViewCellIdentifier"
    private var newCellIndexPath = IndexPath(row: 0, section: 0)
    private var oldCellIndexPath = IndexPath(row: 0, section: 0)
    private var scrollChangedDirection: Bool = false
    private let numberOfSections = 1
    var imagesToDisplay: [Photo] = []
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var indexPathToScrollTo = IndexPath(row: 0, section: 0) {
         didSet {
             self.collectionView.scrollToItem(at: indexPathToScrollTo, at:UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
         }
     }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imagesToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomFullScreenCollectionViewCell.reuseIdentifier, for: indexPath) as? CustomFullScreenCollectionViewCell else { return UICollectionViewCell() }
        
        cell.indexPath = indexPath
        let photo = self.imagesToDisplay[indexPath.row]
        let operationQueue = OperationQueue()
        let operation = LoadImageOperation()
        operation.url = URL(string: photo.photoURL)
        operationQueue.addOperation(operation)
        operation.completion = { image in
            if cell.indexPath == indexPath {
                cell.imageView.image = image
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        self.newCellIndexPath = indexPath
        
        var scroll = ScrollDirection.right
        if (self.newCellIndexPath.row - self.oldCellIndexPath.row > 0) {
            scroll = ScrollDirection.right
        } else if (self.newCellIndexPath.row - self.oldCellIndexPath.row < 0) {
            scroll = ScrollDirection.left
        }
        
        if (self.oldCellIndexPath.row == self.imagesToDisplay.count - 1) {
            scroll = ScrollDirection.left
        }
        
        cell.alpha = 0
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 1) {
            cell.alpha = 1
            cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        switch scroll {
            
        case .right:
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
            if (indexPath.row < imagesToDisplay.count - 1) {
                let oldIndexPath = IndexPath(row: indexPath.row + 1, section: 0)
                if let oldCell = self.collectionView.cellForItem(at: oldIndexPath) {
                    UIView.animate(withDuration: 0.8) {
                        oldCell.alpha = 0.5
                        oldCell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    }
                }
            }
        }
        self.oldCellIndexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.5,
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                            cell.alpha = 0
            },
                           completion: { _ in
                            self.navigationController?.popViewController(animated: true)
            })
            
        }
    }
   
    private func configureCollectionView() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CustomFullScreenCollectionViewCell.self, forCellWithReuseIdentifier: CustomFullScreenCollectionViewCell.reuseIdentifier)
        self.setupCollectionViewAppearance()

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipedToDismiss))
        swipeDown.direction = .down
        swipeDown.delegate = self
        view.addGestureRecognizer(swipeDown)
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
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
        
        self.collectionView.collectionViewLayout = flowLayout
        self.collectionView.backgroundColor = .black
        self.collectionView.isPagingEnabled = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            self.setupCollectionViewAppearance()
        }
    }
    
    @objc func swipedToDismiss() {
        if let cell = collectionView.cellForItem(at: newCellIndexPath) {
            UIView.animate(withDuration: 0.5,
                           animations: {
                            cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                            cell.alpha = 0
            },
                           completion: { _ in
                            self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

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
