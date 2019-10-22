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

class PhotosViewController: UICollectionViewController {

    var friendId: Int = 0

    var photosToDisplay: [Photo] = []
    let presentTransition = CustomPresentModalAnimator()
    let dismissTransition = CustomDismissModalAnimator()
    let vkServices = VKServices()
    
    private var fullScreenViewController: FullScreenImagePresenterViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configCollectionVIew()
        self.getPhotosData()

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosToDisplay.count
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

        self.fullScreenViewController?.imagesToDisplay = self.photosToDisplay
        self.fullScreenViewController?.indexPathToScrollTo = indexPath
    }
    
    private func getPhotosData() {
        self.vkServices.getPhotos(id: self.friendId) { resultPhotos in
            guard let photos = resultPhotos else { return }
            self.photosToDisplay = photos
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func configCollectionVIew() {
        self.collectionView.dataSource = self
        self.collectionView.collectionViewLayout = PhotosCollectionViewLayout()
        self.collectionView.backgroundColor = .darkGray
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FullScreenImagePresenterViewController {
            self.fullScreenViewController = destination
        }
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
