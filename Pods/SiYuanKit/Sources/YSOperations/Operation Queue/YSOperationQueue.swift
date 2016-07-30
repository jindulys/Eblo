//
//  OperationQueue.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-17.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation

/**
  `YSOperationQueue` is an `OperationQueue` subclass that implements a large
  number of "extra features" related to the `YSOperation` class:
 
  - Notifying a delegate of all operation completion
  - Extracting generated dependencies from operation conditions
  - Setting up dependencies to enforce mutual exclusivity
 */
public class YSOperationQueue: OperationQueue {
  
  public override func addOperation(_ op: Operation) {
    if let op = op as? YSOperation {
      let delegate = BlockObserver(startHandler: nil,
                                   produceHandler: { [weak self] in
                                     self?.addOperation($1)
                                   },
                                   finishHandler: nil)
      op.addObserver(observer: delegate)
      
      let dependenciesFromConditions = op.conditions.flatMap {
        $0.dependencyFor(operation:op)
      }
      
      for dependency in dependenciesFromConditions {
        op.addDependency(dependency)
        self.addOperation(dependency)
      }
      
      let concurrencyCategories: [String] = op.conditions.flatMap { condition in
        if condition.dynamicType.isMutuallyExclusive { return nil }
        return "\(condition.dynamicType)"
      }
      if !concurrencyCategories.isEmpty {
        let exclusivityController = ExclusivityController.sharedExclusivityController
        exclusivityController.add(operation: op, categories: concurrencyCategories)
        op.addObserver(observer: BlockObserver { operation, _ in
            ExclusivityController.sharedExclusivityController.remove(operation: operation, categories: concurrencyCategories)
        })
      }
      op.willEnqueue()
    } else {
      op.addCompletionBlock {
        // TODO(simonli): notify delegate about the completion of this operation
      }
    }
    super.addOperation(op)
  }
}
