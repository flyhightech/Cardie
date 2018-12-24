//
//  ScaleTransitioningDelegate.swift
//  Cardie
//
//  Created by Bernard Huff on 12/23/18.
//  Copyright © 2018 Flyhightech.LLC. All rights reserved.
//

import UIKit

protocol Scaling {
    func scalingImageView(transition: ScaleTransitioningDelegate) -> UIImageView?
}

enum TransitionState {
    case begin
    case end
}

class ScaleTransitioningDelegate: NSObject {
    let animationDuration = 0.5
}

extension ScaleTransitioningDelegate : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let backgroundVC = transitionContext.viewController(forKey: .from) else {return}
        guard let foregroundVC = transitionContext.viewController(forKey: .to) else {return}
        
        guard let backgroundImageView = (backgroundVC as? Scaling)?.scalingImageView(transition: self) else {return}
        
        guard let foregroundImageView = (foregroundVC as? Scaling)?.scalingImageView(transition: self) else {return}
        
        let imageViewSnapshot = UIImageView(image: backgroundImageView.image)
        imageViewSnapshot.contentMode = .scaleAspectFill
        imageViewSnapshot.layer.masksToBounds = true
        
        backgroundImageView.isHidden = true
        foregroundImageView.isHidden = true
        
        let foregroundBGColor = foregroundVC.view.backgroundColor
        foregroundVC.view.backgroundColor = UIColor.clear
        containerView.backgroundColor = UIColor.white
        
        containerView.addSubview(backgroundVC.view)
        containerView.addSubview(foregroundVC.view)
        containerView.addSubview(imageViewSnapshot)
    }
    
}
