//
//  AppManager.swift
//  Eblo
//
//  Created by yansong li on 2016-08-14.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import SiYuanKit

/**
 This AppManager is responsible for manage the screens of this app.
 Its responsibility includes:
 
 - create root view controller(Navigation) for this app.
 
 - transfer view controller hierarchy.
 */
public final class AppManager: NSObject {

  /// Indicate whether or not the App is suitable to deal with UI related work.
  /// We use this variable here because sometimes you need other work to be done before
  /// updating UI.
  private var canNavigate: Bool = false
  
  /// Whether or not we are in the middle of UI related animating.
  private var animating: Bool = false

  /// The rootController which is this App's root navigation controller.
  /// This guys is the boss who decides app's screen.
  private var rootController: UINavigationController?
  
  /// The animationTimer to reset `animating` after a short period of time.
  private var animationTimer: Timer = Timer()

  // MARK: Public
  public static let sharedInstance = AppManager()
  
  /// Call this method to allow UI related operation.
  public func allowNavigation() {
    self.canNavigate = true
  }

  /// Create the root navigation controller and set it as the rootViewController of
  /// Appdelegate.
  public func createRootNavigationControllerWithAppDelegate(_ appdelegate: UIApplicationDelegate) {
    let creatRootNav = {
      self.rootController = self.createRootNavigationController()
      // CONFIGURE POINT: set the view controller you want as the first view controller
      // on screen.
      self.rootController?.setViewControllers([EBLoadingViewController()],
                                              animated: true)
      appdelegate.window??.rootViewController = self.rootController!
      appdelegate.window??.makeKeyAndVisible()
    }
    GCDQueue.runOrAddMainQueue(block: creatRootNav)
  }

  /// Nav to Portal Screen and Nav to URI if presents.
  // CONFIGURE POINT
  public func goToPortalWith(URI: URISource?) {
    guard self.canNavigate else {
      // TODO(simonli): log system.
      print("Should call `allowNavigation()` before doing any UI related operation.")
      return
    }
    self.waitForAnimationAndExecute { 
      if self.rootController?.viewControllers.count == 1 &&
        self.rootController?.viewControllers[0] is EBLoadingViewController {
        return
      }
      // NOTE: WOW, swift type checking could work directly with optional!
      if self.topController() is EBLoadingViewController {
        return
      }
      self.replaceRootWithControllers([EBLoadingViewController()], animated: true)
    }
    // TODO(simonli): Following part might involve network request to get correct 
    // instructions about next step. Stay tuned.
    // NOTE: for now I am using a fake wait then navigate to Portal Screen.
    GCDQueue.main.after(when: 1.2) {
      // COFIGURE POINT
      self.waitForAnimationAndExecute(block: { 
        self.replaceRootWithControllers([EBPortalViewController()], animated: true)
      })
    }
  }

  // MARK: Private
  
  private func createRootNavigationController() -> UINavigationController {
    let nav = UINavigationController(navigationBarClass: nil, toolbarClass: nil)
    return nav
  }
  
  // MARK: - Helpers
  private func resetAnimateTimer() {
    self.animationTimer.invalidate()
    self.animationTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                               target: self,
                                               selector:#selector(turnOffAnimate),
                                               userInfo: nil,
                                               repeats: false)
  }
  
  @objc private func turnOffAnimate() {
    self.animating = false
  }
  
  // MARK: - View Controller Hierarchy Helpers
  
  /// Return the topViewController of current view controller stack.
  private func topController() -> UIViewController? {
    var topViewController = self.rootController?.topViewController
    while let topController = topViewController,
      topNavController = topController.presentedViewController as? UINavigationController {
      topViewController = topNavController.topViewController
    }
    return topViewController
  }

  // MARK: - UI Helpers
  
  /// Replace root controller(Nav Controller) stack.
  /// - parameter controllers: controllers to replace.
  /// - parameter animated: whether or not you want to animated.
  /// - parameter completion: completion block.
  func replaceRootWithControllers(_ controllers:[UIViewController],
                                  animated: Bool,
                                  completion: (() -> ())? = nil) {
    self.animating = true
    // We are about to replace the controllers. let's ensure the keyboard is dismissed
    // first.
    UIApplication.shared().resignFirstResponder()
    GCDQueue.main.after(when: 0.2) {
      // Reset animation.
      self.resetAnimateTimer()
      // Dismiss any presented view controller.
      self.rootController?.topViewController?.dismiss(animated: false, completion: nil)
      if let existingControllers = self.rootController?.viewControllers
        where existingControllers != controllers {
        self.rootController?.setViewControllers(controllers, animated: animated)
      }
      completion?()
    }
  }
  
  /// Executing a block when no animation happenning.
  private func waitForAnimationAndExecute(block: () -> ()) {
    let wrapper = {
      if (self.animating) {
        print("Potentially dangerous while animation occuring!")
      }
      block()
    }
    //
    if !self.animating {
      GCDQueue.runOrAddMainQueue(block: wrapper)
      return
    }
    GCDQueue.background.async {
      while self.animating {
#if DEBUG
        print("Sleeping")
#endif
        Thread.sleep(forTimeInterval: 0.01)
      }
      GCDQueue.runOrAddMainQueue(block: wrapper)
    }
  }
}
