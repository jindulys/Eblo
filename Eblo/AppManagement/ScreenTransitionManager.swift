//
//  ScreenTransitionManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-29.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit

/// The protocol defines a transition view controller.
protocol TransitionViewController {
  var sourceScreenName: String { get }
}

enum TransitionMethod: String {
  case NAV = "navigate"
  case POP = "present"
  case UNKNOWN = "unknown"

  /// Return a transitionMethod from a string.
  static func transitionMethodFor(str: String) -> TransitionMethod {
    if str == "navigate" {
      return .NAV
    } else if str == "present" {
      return .POP
    } else {
      return .UNKNOWN
    }
  }
}

/// A manager whose responsibility is to generate the path for screen transition.
class ScreenTransitionManager {
  /// Transition Routes Table all the transition management are here.
  static let transitionRoutesTable =
    [ "MainViewController" :
        ["companyBlogList" : (TransitionMethod.NAV, "CompanyBlogListViewController"),
         "editRecord" : (TransitionMethod.POP, "EditRecordViewController")]
  ]

  /// Transition screen with source view controller, entryPoint, and params.
  @discardableResult public static func transitionScreenWith(viewController: TransitionViewController,
                                                             entryPoint: String,
                                                             params: String? = nil) -> String? {
    guard let routesTable =
      self.transitionRoutesTable[viewController.sourceScreenName],
      let (transitionMethod, toViewController) = routesTable[entryPoint] else {
      return nil
    }
    var baseURI = "Eblo/"
    // NOTE: append destination view controller name.
    baseURI.append("\(toViewController)/")
    // NOTE: append action.
    baseURI.append("action=\(transitionMethod.rawValue)&")
    if let passedParams = params {
      baseURI.append(passedParams)
    }
    if let viewController = viewController as? UIViewController {
      EBURIResolver.routeWithURI(baseURI, source: viewController)
    }
    return baseURI
  }
}
