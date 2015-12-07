//
//  TableCellAnimator.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-06.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit
import ChameleonFramework
import EasyAnimation

protocol TableCellAnimatorFromProtocol: UINavigationControllerDelegate {
    var lastSelectedIndexPath: NSIndexPath? { get set }
    func selectedCellView() -> UIView
    func selectedCellImage() -> UIImage
}

protocol TableCellAnimatorToProtocol: UINavigationControllerDelegate {
    weak var snapshotImageView: UIImageView! { get set }
}

class TableCellAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        if let fromVCProtocol = fromVC as? TableCellAnimatorFromProtocol, toVCProtocol = toVC as? TableCellAnimatorToProtocol {
            transitionContext.containerView()?.insertSubview(toVC.view, belowSubview: fromVC.view)
            toVC.view.frame = CGRect(origin: CGPoint(x: 0, y: 44), size: toVC.view.frame.size)
            
            let cellView = fromVCProtocol.selectedCellView()
            cellView.frame = CGRect(origin: CGPoint(x: 0, y: cellView.frame.origin.y + 64), size: cellView.frame.size)
            transitionContext.containerView()?.addSubview(cellView)
            
            let width = fromVC.view.bounds.size.width
            toVC.view.transform = CGAffineTransformMakeTranslation(width, 0.0)
            
            UIApplication.sharedApplication().windows[0].backgroundColor = FlatBlack()
            
            let duration = transitionDuration(transitionContext)
            
            UIView.animateAndChainWithDuration(duration/4, delay: 0.0, options: [], animations: {
                //1st animation
                fromVC.view.transform = CGAffineTransformMakeTranslation(-width, 0.0)
                
                }, completion:nil).animateWithDuration(duration/4, animations: {
                    //2nd animation
                    cellView.center.y = cellView.bounds.size.height / 2 + fromVC.topLayoutGuide.length + 64
                    
                }).animateWithDuration(duration/4, animations: {
                    //3rd animation
                    toVC.view.transform = CGAffineTransformIdentity
                    
                }).animateWithDuration(duration/4, animations: {
                    //4th animation
                    cellView.alpha = 0.0
                    
                    }, completion: {_ in
                        //animation completed
                        
                        fromVC.view.transform = CGAffineTransformIdentity
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                })

            toVCProtocol.snapshotImageView.image = fromVCProtocol.selectedCellImage()
        }
    }
    
}
