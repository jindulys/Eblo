//
//  EBURIResolver.swift
//  Eblo
//
//  Created by yansong li on 2016-08-19.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit

/// The URISource Protocol. Any one adopt to this protocol should provide a URI.
public protocol URISource {
  /// URI computed variable.
  var URI: String { get }
}

/// The URIAction takes in a uiviewcontroller to use.
/// This controller might be a controller parsed by URIMatcher.
/// Or might be the controller to handle app interraction based on concrete situation.
public typealias URIAction = (UIViewController) -> Void

/// The URIHandler takes in an action to perform. or passed in the view controller we get from the
/// second parameter to perform the action defined from the source part.
public typealias URIHandler = (URIAction, UIViewController?) -> Void

/// URI Resolver.
public class EBURIResolver {
  /// Route to the view controller indicated by uri.
  public static func routeWithURI(_ uri: URISource, source: UIViewController) -> Void {
    let defaultHandler: URIHandler = { (action, controller) in
      action(source)
    }
    self.routeWithURI(uri, handler: defaultHandler)
  }

  public static func routeWithURI(_ uri: URISource, action: @escaping URIAction) -> Void {
    let defaultHandler: URIHandler = { (discardOne, controller) in
      if let validController = controller {
        action(validController)
      }
    }
    self.routeWithURI(uri, handler: defaultHandler)
  }

  private static func routeWithURI(_ uri: URISource, handler: URIHandler) -> Void {
    if !uri.URI.hasPrefix("Eblo/") {
      return
    }
    for matcher in URIMatcherManager.matchers() {
      if matcher.handleURI(uri, handler: handler) {
        return
      }
    }
    handler(self.emptyAction(), nil)
  }
  
  private static func emptyAction() -> URIAction {
    return { controller in
      print("Empty Aciton")
    }
  }
}
