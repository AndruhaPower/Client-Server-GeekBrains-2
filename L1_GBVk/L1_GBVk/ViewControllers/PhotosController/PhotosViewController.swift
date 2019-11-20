//
//  PhotosViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
import Foundation
import Realm
import RealmSwift

final class PhotosViewController: UICollectionViewController {

    var friendId: Int = 0
    var photosToDisplay: [Photo] = []
    private let numberOfSections: Int = 1
    private let presentTransition = CustomPresentModalAnimator()
    private let dismissTransition = CustomDismissModalAnimator()
    private let vkServices = VKServices()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCollectionVIew()
        self.getPhotosData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosToDisplay.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.reuseIdentifier, for: indexPath) as? AvatarCell else { return UICollectionViewCell() }
        
        cell.indexPath = indexPath
        let photo = self.photosToDisplay[indexPath.row]
        let operationQueue = OperationQueue()
        let operation = LoadImageOperation()
        operation.url = URL(string: photo.photoURL)
        operationQueue.addOperation(operation)
        operation.completion = { image in
            if cell.indexPath == indexPath {
                cell.avatarImageView.image = image
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let fullScreenViewController = FullScreenImagePresenterViewController()
        fullScreenViewController.imagesToDisplay = self.photosToDisplay
        fullScreenViewController.indexPathToScrollTo = indexPath
        self.navigationController?.pushViewController(fullScreenViewController, animated: true)
    }
    
    private func getPhotosData() {
        self.vkServices.getPhotos(id: self.friendId) { resultPhotos in
            guard let photos = resultPhotos else { return }
            self.photosToDisplay = photos
            DispatchQueue.main.async {  [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func configCollectionVIew() {
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = PhotosCollectionViewLayout()
        self.collectionView.backgroundColor = .darkGray
    }
}

extension PhotosViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return presentTransition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissTransition
    }
    
}
