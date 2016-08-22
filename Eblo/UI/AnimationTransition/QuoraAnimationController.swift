//
//  QuoraAnimationController.swift
//  Eblo
//
//  Created by yansong li on 2016-08-21.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit

/// This is a protocol used by custom modal presentation.
/// Object adopt to this protocol is responsible for providing preanimation setting and desired
/// animation, since object itself has the knowledge about which kind animation it wants.
/// NOTE: This is view controller level custom transition animation.
public protocol EBPresentationDestinationViewController {
  
  /// prepare pre animation state before animation begin, usually set view to wanted state before
  /// animation begins.
  func preparePreTransitionState()
  
  /// set animation state which is the desired state view controller wants after animation.
  func setAnimationState()
}

class QuoraAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey:.from),
      let toVC = transitionContext.viewController(forKey:.to),
      let bloatVC = toVC as? EBPresentationDestinationViewController else {
        return
    }

    transitionContext.containerView.addSubview(toVC.view)
    transitionContext.containerView.bringSubview(toFront: fromVC.view)
    
    /// start prepare destination view controller state.
    bloatVC.preparePreTransitionState()
    
    let duration = transitionDuration(using: transitionContext)
    UIView.animateKeyframes(withDuration: duration,
                            delay: 0,
                            options: .calculationModeCubic,
                            animations: {
                              UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 3/5, animations: {
                                fromVC.view.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1)
                                fromVC.view.alpha = 0.0
                              })
                              UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 4/5, animations: {
                                bloatVC.setAnimationState()
                              })
                            }){ _ in
                                fromVC.view.layer.transform = CATransform3DIdentity
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                            }
  }
}
