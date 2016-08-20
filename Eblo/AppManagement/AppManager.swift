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
  var canNavigate: Bool = false
  
  /// Whether or not we are in the middle of UI related animating.
  var animating: Bool = false

  var rootController: UINavigationController?

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
      self.rootController?.setViewControllers([EBPortalViewController()], animated: true)
      appdelegate.window??.rootViewController = self.rootController!
      appdelegate.window??.makeKeyAndVisible()
    }
    GCDQueue.runOrAddMainQueue(block: creatRootNav)
  }

  func goToPortalWith(URI: URISource) {
    guard self.canNavigate else {
      // TODO(simonli): log system.
      print("Should call `allowNavigation()` before doing any UI related operation.")
      return
    }
    
  }

  // MARK: Private
  
  func createRootNavigationController() -> UINavigationController {
    let nav = UINavigationController(navigationBarClass: nil, toolbarClass: nil)
    return nav
  }
  
  // MARK: - View Controller Hierarchy
  
  /// Return the topViewController of current view controller stack.
  func topController() -> UIViewController? {
    var topViewController = self.rootController?.topViewController
    while let topController = topViewController,
      topNavController = topController.presentedViewController as? UINavigationController {
      topViewController = topNavController.topViewController
    }
    return topViewController
  }

  // MARK: - UI
  
  /// Executing a block when no animation happenning.
  func waitForAnimationAndExecute(block: () -> ()) {
    let wrapper = {
      if (self.animating) {
        print("Potentially dangerous while animation occuring!")
        block()
      }
    }
    //
    if !self.animating {
      GCDQueue.runOrAddMainQueue(block: wrapper)
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
