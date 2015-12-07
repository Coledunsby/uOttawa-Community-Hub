//
//  FiltersCollectionViewController.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-11-29.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

class FiltersCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var filters: [CHFilter] = []
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // MARK: - Private Functions
    
    private func fetchData() {
        let query = CHFilter.query()
        query?.orderByAscending("name")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            self.filters.removeAll()
            
            for object in objects! {
                self.filters.append(object as! CHFilter)
            }
            
            self.collectionView!.reloadData()
        })
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(sender: UIButton) {
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIButton) {
        
    }
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let filter = filters[indexPath.row]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FilterCollectionViewCell
        cell.nameLabel.text = filter.name
        //cell.imgView.image =
    
        return cell
    }

    // MARK: - UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 5
        let width = (view.frame.size.width - CGFloat((columns + 1) * spacing)) / columns
        return CGSize(width: width, height: width)
    }
    
}
