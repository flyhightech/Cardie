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
        
        let transitionStateA = TransitionState.begin
        let transitionStateB = TransitionState.end
        
        prepareViews(for: transitionStateA, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        
        foregroundVC.view.layoutIfNeeded()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.prepareViews(for: transitionStateB, containerView: containerView, backgroundVC: backgroundVC, backgroundImageView: backgroundImageView, foregroundImageView: foregroundImageView, snapshotImageView: imageViewSnapshot)
        }) { _ in
            backgroundVC.view.transform = .identity
            imageViewSnapshot.removeFromSuperview()
            backgroundImageView.isHidden = false
            foregroundImageView.isHidden = false
            
            foregroundVC.view.backgroundColor = foregroundBGColor
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    
    func prepareViews(for state: TransitionState, containerView: UIView, backgroundVC:UIViewController, backgroundImageView: UIImageView, foregroundImageView:UIImageView, snapshotImageView: UIImageView) {
        
        switch state {
        case .begin:
            backgroundVC.view.transform = .identity
            backgroundVC.view.alpha = 1
            
            snapshotImageView.frame = containerView.convert(backgroundImageView.frame, from: backgroundImageView.superview)
        case .end:
            backgroundVC.view.alpha = 0
            snapshotImageView.frame = containerView.convert(foregroundImageView.frame, from: foregroundImageView.superview)
        
        }
    }
}

extension ScaleTransitioningDelegate:UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if fromVC is Scaling && toVC is Scaling {
            return self
        } else {
            return nil
        }
    }
    
}
