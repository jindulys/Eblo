//
//  OperationCondition.swift
//
//  Created by yansong li on 2016-07-16.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation

let OperationConditionKey = "OperationCondition"

/**
  A protocol for defining conditions that must be satisfied in order for an 
  operation to begin execution.
 */
public protocol OperationCondition {
  /**
    The name of the condition. This is used in userInfo dictionaries of `.ConditionFailed`
    errors as the value of the `OperationConditionKey` key.
   */
  static var name: String { get }
  
  /**
    Specifies whether multiple instances of the conditionalized operation may be executing
    simultaneously.
   */
  static var isMutuallyExclusive: Bool { get }
  
  /**
    Some conditions may have the ability to satisfy the condition if another operation is
    executed first. Use this method to return an operation that (for example) asks for
    permission to perform the operation
   
    - parameter operation: The `YSOperation` to which the Condition has been added.
    - returns: An `Operation`, if a dependency should be automatically added. Otherwise, `nil`.
    - note: Only a single operation may be returned as a dependency. If you find that
      you need to return multiple operations, then you should be expressing that as 
      multiple conditions. Alternatively, you could return a single `GroupOperation` that
      executes multiple operations internally.
   */
  func dependencyFor(operation: YSOperation) -> Operation?
  
  /// Evaluate the conditon, to see if it has been satisfied or not.
  func evaluateFor(operation: YSOperation, completion: (OperationConditionResult) -> Void)
}

public enum OperationConditionResult {
  case Satisfied
  case Failed(ErrorProtocol)
  
  var error: ErrorProtocol? {
    if case .Failed(let error) = self {
      return error
    }
    return nil
  }
}

/// Operation condition evaluator
struct OperationConditionEvaluator {
  /**
    static method to evaluate \a operation with \a conditions.
   */
  static func evaluate(conditions: [OperationCondition],
                       operation: YSOperation,
                       completion: ([ErrorProtocol]) -> Void) {
    let conditionGroup = DispatchGroup()
    
    var results = [OperationConditionResult?](repeating: .none, count: conditions.count)
    
    for (index, condition) in conditions.enumerated() {
      conditionGroup.enter()
      condition.evaluateFor(operation: operation) { result in
        results[index] = result
        conditionGroup.leave()
      }
    }
    
    conditionGroup.notify(queue: DispatchQueue.global()) {
      var failures: [ErrorProtocol] = results.flatMap { $0?.error }
      if operation.isCancelled {
        failures.append(YSOperationError.conditionFailed)
      }
      completion(failures)
    }
  }
}
