//
//  PhotosViewController.swift
//  L1_GBVk
//
//  Created by Andrew on 18/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
import Foundation

class PhotosViewController: UICollectionViewController {

    var friendName: String = ""
    var friendId: Int = 0

    var selectedIndexPath = IndexPath(row: 0, section: 0)
    var photosToDisplay: [String] = []
    let presentTransition = CustomPresentModalAnimator()
    let dismissTransition = CustomDismissModalAnimator()
    let vkServices = VKServices()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = friendName
        vkServices.getPhotos(id: friendId) { (photos) in
            guard let photosWeb = photos else { return }
            var tempArray: [String] = []
            for url in photosWeb {
               tempArray.append(url.photoURL)
            }
            self.photosToDisplay = tempArray
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photosToDisplay.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvatarCell.reuseIdentifier, for: indexPath) as? AvatarCell else { return UICollectionViewCell() }
//        let photosArray = keysForPhotos()
//        let likesArray = valuesForLikes()
        let imageURL = URL(string: photosToDisplay[indexPath.row])
        cell.avatarImageView.load(url: imageURL!) // АНВРАП ССАНЫЙ
            return cell
        }
    
    func getImagesArray(_ URLArray :[String]) -> [UIImage] {
        var ImageViewsArray: [UIImage] = []
        for string in URLArray {
            let url = URL(string: string)
            let image = UIImageView()
            image.load(url: url!)
            guard let uiImage = image.image else { return [] }
            ImageViewsArray.append(uiImage)
        }
        return ImageViewsArray
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        let fullScreenGallery = storyboard!.instantiateViewController(withIdentifier: "FullScreenImagePresenter") as! FullScreenImagePresenterViewController
        
        fullScreenGallery.transitioningDelegate = self
        fullScreenGallery.imagesToDisplay = getImagesArray(photosToDisplay)
        fullScreenGallery.indexPathToScrollTo = selectedIndexPath
        
        present(fullScreenGallery, animated: true, completion: nil )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FullScreenImagePresenterViewController {
            destination.imagesToDisplay = getImagesArray(photosToDisplay)
            destination.indexPathToScrollTo = selectedIndexPath
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
