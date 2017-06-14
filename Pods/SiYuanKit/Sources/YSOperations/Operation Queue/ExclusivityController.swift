//
//  ExclusivityController.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-21.
//
//

import Foundation

/**
  `ExclusivityController` is a singleton to keep track of all the in-flight
  `Operation` instances that have declared themselves as requiring mutual exclusivity.
  We use a singleton because mutual exclusivity must be enforced across the entire app,
  regardless of the `OperationQueue` on which an `Operation` was executed.
 */
class ExclusivityController {
  /// Singleton instance.
  static let sharedExclusivityController = ExclusivityController()
  
  /// Private Queue for execution.
  private let serialQueue = DispatchQueue(label: "exclusiveQueue")
  
  /// Dictionary for storing categories and operation list.
  private var operations: [String: [YSOperation]] = [:]
  
  /// Add operation with categories which are exclusive one.
  func add(operation: YSOperation, categories:[String]) {
    serialQueue.sync { 
      for category in categories {
        self.add(operation: operation, category: category)
      }
    }
  }
  
  func remove(operation: YSOperation, categories:[String]) {
    serialQueue.async { 
      for category in categories {
        self.remove(operation: operation, category: category)
      }
    }
  }
  
  func add(operation: YSOperation, category: String) {
    var existingOperations = operations[category] ?? []
    if let dependency = existingOperations.last {
      operation.addDependency(dependency)
    }
    existingOperations.append(operation)
    operations[category] = existingOperations
  }
  
  func remove(operation: YSOperation, category: String) {
    let matchingOperations = operations[category]
    
    if var operationsWithThisCategory = matchingOperations,
      let index = operationsWithThisCategory.index(of:operation) {
      operationsWithThisCategory.remove(at: index)
      operations[category] = operationsWithThisCategory
    }
  }
}
