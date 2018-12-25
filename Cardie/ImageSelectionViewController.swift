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
    
    let imageDataRequest = DataRequest<Image>(dataSource: "Images")
    var imageData = [Image]()
    
    @IBOutlet weak var initialImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var initialDimView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialDimView.alpha = 0
        backButton.alpha = 0
        
        
        if let availableImage = image, let availableCategory = category {
            initialImageView.image = availableImage
            categoryLabel.text = availableCategory.categoryName
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func loadData() {
        imageDataRequest.getData{ [weak self] dataResult in
            switch dataResult {
            case .failure:
                print("Could not load images")
            case .success(let images):
                self?.imageData = images
                DispatchQueue.main.async {
                    self?.setupUI()
                }
            }
        }
    }
    
    func setupUI() {
        
        UIView.animate(withDuration: 0.5) {
            self.initialDimView.alpha = 1
            self.backButton.alpha = 1
        }
        
        scrollView.contentSize.width = self.scrollView.frame.width * CGFloat(imageData.count + 1)
        
        for (i, image) in imageData.enumerated() {
            let frame = CGRect(x: self.scrollView.frame.width * CGFloat(i + 1), y: 0, width: self.scrollView.frame.width, height: self.scrollView.frame.height)
            
            guard let photoView = Bundle.main.loadNibNamed("PhotoView", owner: self, options: nil)?.first as? PhotoView else {return}
            
            photoView.frame = frame
            photoView.imageView.image = UIImage(named: image.imageName)!
            
            photoView.descriptionLabel.text = image.description
            photoView.photographerLabel.text = image.photographer
            
            scrollView.addSubview(photoView)
        }
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.setContentOffset(CGPoint.zero, animated: false)
        }) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                self.initialDimView.alpha = 0
                sender.alpha = 0
            }, completion: { _ in
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
}

extension ImageSelectionViewController:Scaling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView? {
        return initialImageView
    }
}
