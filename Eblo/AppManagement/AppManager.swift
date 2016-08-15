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
 
 - create root view controller for this app.
 
 - transfer view controller hierarchy.
 
 NOTE: I decided to use Navigation Controller as a root view controller.
 */
public final class AppManager: NSObject {
  
  /// Indicate whether or not the App is suitable to deal with UI related work.
  /// We use this variable here is because sometimes you need other work to be done before
  /// updating UI.
  var canNavigate: Bool = false
  
  var rootController: UINavigationController?
  
  // MARK: Public
  public static let sharedInstance = AppManager()
  
  /// Call this method to allow UI related operation.
  public func allowNavigation() {
    self.canNavigate = true
  }
  
  /// Create the root navigation controller and set it as the rootViewController of
  /// Appdelegate.
  func createRootNavigationControllerWithAppDelegate(_ appdelegate: UIApplicationDelegate) {
    let creatRootNav = {
      self.rootController = self.createRootNavigationController()
      self.rootController?.setViewControllers([ViewController()], animated: true)
      appdelegate.window??.rootViewController = self.rootController!
      appdelegate.window??.makeKeyAndVisible()
    }
    GCDQueue.runOrAddMainQueue(block: creatRootNav)
  }
  
  // MARK: Private
  
  func createRootNavigationController() -> UINavigationController {
    let nav = UINavigationController(navigationBarClass: nil, toolbarClass: nil)
    return nav
  }
  
  
}
