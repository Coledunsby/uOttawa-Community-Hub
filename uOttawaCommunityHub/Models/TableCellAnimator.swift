//
//  TableCellAnimator.swift
//  uOttawaCommunityHub
//
//  Created by Cole Dunsby on 2015-12-06.
//  Copyright © 2015 Cole Dunsby. All rights reserved.
//

import UIKit

protocol TableCellAnimatorProtocol: UINavigationControllerDelegate {
    var lastSelectedIndexPath: NSIndexPath? { get set }
    func selectedCellSnapshot() -> UIView
}

class TableCellAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        
        if let fromVCProtocol = fromVC as? TableCellAnimatorProtocol {
            transitionContext.containerView()?.insertSubview(toVC.view, belowSubview: fromVC.view)
            
            let cellView = fromVCProtocol.selectedCellSnapshot()
            transitionContext.containerView()?.addSubview(cellView)
            
            let width = fromVC.view.bounds.size.width
            toVC.view.transform = CGAffineTransformMakeTranslation(width, 0.0)
            
            UIApplication.sharedApplication().windows[0].backgroundColor = .whiteColor()
            
            let duration = transitionDuration(transitionContext)
            
            UIView.animateWithDuration(duration/4, animations: { () -> Void in
                fromVC.view.transform = CGAffineTransformMakeTranslation(-width, 0.0)
                }) { (finished) -> Void in
                    UIView.animateWithDuration(duration/4, animations: { () -> Void in
                        cellView.center = CGPointMake(cellView.center.x, cellView.bounds.size.height / 2 + fromVC.topLayoutGuide.length)
                        }, completion: { (finished) -> Void in
                            UIView.animateWithDuration(duration/4, animations: { () -> Void in
                                toVC.view.transform = CGAffineTransformIdentity
                                }, completion: { (finished) -> Void in
                                    UIView.animateWithDuration(duration/4, animations: { () -> Void in
                                        cellView.alpha = 0.0
                                        }, completion: { (finished) -> Void in
                                            fromVC.view.transform = CGAffineTransformIdentity
                                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                                    })
                            })
                    })
            }
        }
    }
    
}
