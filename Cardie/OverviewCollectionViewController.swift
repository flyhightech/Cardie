//
//  OverviewCollectionViewController.swift
//  Cardie
//
//  Created by Bernard Huff on 12/5/18.
//  Copyright © 2018 Flyhightech.LLC. All rights reserved.
//

import UIKit

class OverviewCollectionViewController: UICollectionViewController {
    
    let categoryDataRequest = DataRequest<Category>(dataSource: "Categories")
    var categoryData = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        categoryDataRequest.getData{ [weak self] dataResult in
            switch dataResult {
            case .failure:
                print("Could not load categories")
            case .success(let cateogires):
                self?.categoryData = cateogires
                self?.collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let category = sender as! Category
            guard let image = UIImage(named: category.categoryImageName) else {return}
            let imageSelectionVC = segue.destination as! ImageSelectionViewController
            imageSelectionVC.image = image
            imageSelectionVC.category = category
        }
    }
}

// MARK: - CollectionView DataSource
extension OverviewCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CategoryCollectionViewCell else {fatalError("Could not create proper cateogry cell for collection view")}
        
        let category = categoryData[indexPath.item]
        
        guard let image = UIImage(named: category.categoryImageName) else {fatalError("Could not load image for cell")}
        
        cell.backgroundImageView.image = image
        cell.categoryLabel.text = category.categoryName
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension OverviewCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.layer.cornerRadius = 14
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let category = categoryData[indexPath.item]
        self.performSegue(withIdentifier: "showDetail", sender: category)
    }
}

// MARK: - CollectionView Layout Delegate
extension OverviewCollectionViewController : UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
}
