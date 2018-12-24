//
//  ImageSelectionViewController.swift
//  Cardie
//
//  Created by Bernard Huff on 12/23/18.
//  Copyright © 2018 Flyhightech.LLC. All rights reserved.
//

import UIKit

class ImageSelectionViewController: UIViewController {

    var image:UIImage?
    var category:Category?
    
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let availableImage = image, let availableCategory = category {
            initialImageView.image = availableImage
            categoryLabel.text = availableCategory.categoryName
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
