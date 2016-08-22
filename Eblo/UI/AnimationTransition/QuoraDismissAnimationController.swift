//
//  QuoraDismissAnimationController.swift
//  Eblo
//
//  Created by yansong li on 2016-08-21.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit

class QuoraDismissAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.3
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey:.from),
      let toVC = transitionContext.viewController(forKey:.to) else {
        return
    }
    //let containerView = transitionContext.containerView
    //UIApplication.shared.keyWindow?.addSubview(toVC.view)
    // Setup To VC.
    toVC.view.alpha = 0.6
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    //toVC.view.layer.transform = CATransform3DMakeScale(0.8, 0.8, 1)
    transitionContext.containerView.addSubview(toVC.view)
    
    let duration = transitionDuration(using: transitionContext)
    
    UIView.animateKeyframes(withDuration: duration,
                            delay: 0,
                            options: .calculationModeCubic,
                            animations: {
                              UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 3/5, animations: {
                                fromVC.view.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1)
                                fromVC.view.alpha = 0.0
                              })
                              UIView.addKeyframe(withRelativeStartTime: 1/5, relativeDuration: 4/5, animations: {
                                toVC.view.layer.transform = CATransform3DIdentity
                                toVC.view.alpha = 1.0
                              })
    }) { _ in
      fromVC.view.layer.transform = CATransform3DIdentity
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      //UIApplication.shared.keyWindow?.addSubview(toVC.view)
    }
  }
}
