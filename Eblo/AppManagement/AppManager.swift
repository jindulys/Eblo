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
  /// This guys is the boss who manages this App's screen.
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
      self.rootController?.setNavigationBarHidden(false, animated: false)
      self.rootController?.navigationBar.isTranslucent = false
			// CONFIGURE POINT: set the view controller you want as the first view controller
			// on screen.
      self.rootController?.setViewControllers([LoadingViewController()],
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
    // Add in loading view controller to smooth the screen transition.
    self.waitForAnimationAndExecute { 
      if self.rootController?.viewControllers.count == 1 &&
        self.rootController?.viewControllers[0] is LoadingViewController {
        return
      }
      // NOTE: WOW, swift type checking could work directly with optional!
      if self.topController() is LoadingViewController {
        return
      }
      self.replaceRootWithControllers([LoadingViewController()], animated: true)
    }
    // TODO(simonli): Following part might involve network request to get correct 
    // instructions about next step. Stay tuned.
    // NOTE: for now I am using a fake wait then navigate to Portal Screen.
    GCDQueue.main.after(when: 1.2) {
      // COFIGURE POINT
      self.waitForAnimationAndExecute(block: { 
        self.replaceRootWithControllers([PortalViewController()], animated: true)
      })
    }
  }
  
  /// Nav to main Screen and Nav to URI if presents.
  // CONFIGURE POINT
  public func goToMainWith(URI: URISource?) {
    guard self.canNavigate else {
      // TODO(simonli): log system.
      print("Should call `allowNavigation()` before doing any UI related operation.")
      return
    }
    // Try to find a kind of `mainController`.
    var mainController: UIViewController = (self.rootController?.viewControllers.first)!
    if (mainController is MainViewController) == false {
      // CONFIGURE POINT
      mainController = MainViewController()
    }
    // Top most view controller dismiss itself.
    // Usually do not need to do this.
    // The special case here is that:
    // A view controller custom presents an other view controller
    // use the following method to find the top most non-nav view controller(since this is the 
    // view controller take over the full screen). then let it do custom dismiss.
    // Otherwise we will get a black screen since view hierarchy is not add to window.(Weired though)
    if let topVisibleViewController = self.topVisibleController() {
      topVisibleViewController.dismiss(animated: true, completion: nil)
    }
    // TODO(simonli): Following part might involve network request to get correct
    // instructions about next step. Stay tuned.
    // NOTE: for now I am using a fake wait then navigate to Main Screen.
    GCDQueue.main.after(when: 0.2) {
      let newControllers: [UIViewController] = [mainController]
      self.waitForAnimationAndExecute(block: { 
        self.replaceRootWithControllers(newControllers, animated: false)
      })
    }
  }
  
  /// Nav to Eblo Screen and Nav to URI if presents.
  // CONFIGURE POINT
  public func goToEbloWith(URI: URISource?) {
    guard self.canNavigate else {
      // TODO(simonli): log system.
      print("Should call `allowNavigation()` before doing any UI related operation.")
      return
    }
    // Try to find a kind of `mainController`.
    var controller: UIViewController = (self.rootController?.viewControllers.first)!
    if !(controller is EbloBlogViewController) {
      // CONFIGURE POINT
      controller = EbloBlogViewController()
    }
    // Top most view controller dismiss itself.
    // Usually do not need to do this.
    // The special case here is that:
    // A view controller custom presents an other view controller
    // use the following method to find the top most non-nav view controller(since this is the
    // view controller take over the full screen). then let it do custom dismiss.
    // Otherwise we will get a black screen since view hierarchy is not add to window.(Weired though)
    if let topVisibleViewController = self.topVisibleController() {
      topVisibleViewController.dismiss(animated: true, completion: nil)
    }
    // TODO(simonli): Following part might involve network request to get correct
    // instructions about next step. Stay tuned.
    // NOTE: for now I am using a fake wait then navigate to Main Screen.
    GCDQueue.main.after(when: 0.2) {
      let newControllers: [UIViewController] = [controller]
      self.waitForAnimationAndExecute(block: {
        self.replaceRootWithControllers(newControllers, animated: false)
      })
    }
  }

  /// Push `controller` to the top of Nav Stack.
  public func pushToNavTop(controller: UIViewController) {
    self.topController()?.navigationController?.pushViewController(controller, animated: true)
  }

  /// Present `controller` to the top of Nav Stack.
  public func presentToNavTop(controller: UIViewController) {
    /// Dismiss the potential alert view controller first.
    self.topVisibleController()?.dismiss(animated: true, completion: nil)
    self.topVisibleController()?.present(controller, animated: true, completion: nil)
  }
	
/** UNComment Following to do some test work.
	
	/// Nav to main Screen and Nav to URI if presents.
	// CONFIGURE POINT
	public func goToMainWith(URI: URISource?) {
		guard self.canNavigate else {
			// TODO(simonli): log system.
			print("Should call `allowNavigation()` before doing any UI related operation.")
			return
		}
		// Try to find a kind of `mainController`.
		var mainController: UIViewController = (self.rootController?.viewControllers.first)!
		if (mainController is ViewController) == false {
			// CONFIGURE POINT
			mainController = ViewController()
		}
		// Top most view controller dismiss itself.
		// Usually do not need to do this.
		// The special case here is that:
		// A view controller custom presents an other view controller
		// use the following method to find the top most non-nav view controller(since this is the
		// view controller take over the full screen). then let it do custom dismiss.
		// Otherwise we will get a black screen since view hierarchy is not add to window.(Weired though)
		if let topVisibleViewController = self.topVisibleController() {
			topVisibleViewController.dismiss(animated: true, completion: nil)
		}
		// TODO(simonli): Following part might involve network request to get correct
		// instructions about next step. Stay tuned.
		// NOTE: for now I am using a fake wait then navigate to Main Screen.
		GCDQueue.main.after(when: 1.2) {
			let newControllers: [UIViewController] = [mainController]
			self.waitForAnimationAndExecute(block: {
				self.replaceRootWithControllers(newControllers, animated: false)
			})
		}
	}

*/

  // MARK: - Private
	
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

  /// Return the topViewController, which is the toppest navigation stack's topViewController.                         
  private func topController() -> UIViewController? {
    var topViewController = self.rootController?.topViewController
    while let topController = topViewController,
      let topNavController = topController.presentedViewController as? UINavigationController {
      topViewController = topNavController.topViewController
    }
    return topViewController
  }

  /// Return the topVisibleController, which is the top most visible one.
  private func topVisibleController() -> UIViewController? {
    var topVisibleViewController = self.rootController?.topViewController
    while let topController = topVisibleViewController,
      let topPresentedController = topController.presentedViewController,
      (topPresentedController is UIAlertController) == false {
        if let topNavController = topPresentedController as? UINavigationController {
          topVisibleViewController = topNavController.topViewController
        } else {
          topVisibleViewController = topPresentedController
        }
    }
    return topVisibleViewController
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
    UIApplication.shared.resignFirstResponder()
    GCDQueue.main.after(when: 0.2) {
      // Reset animation.
      self.resetAnimateTimer()
      // Dismiss any presented view controller from current top most nav stack's top view controller.
      self.rootController?.topViewController?.dismiss(animated: false, completion: nil)
      if let existingControllers = self.rootController?.viewControllers
        , existingControllers != controllers {
        self.rootController?.setViewControllers(controllers, animated: animated)
      }
      completion?()
    }
  }

  /// Executing a block when no animation happenning.
  private func waitForAnimationAndExecute(block: @escaping () -> ()) {
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
