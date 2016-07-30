//
//  OperationQueue.swift
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
      let dependenciesFromConditions = op.conditions.flatMap {
        $0.dependencyFor(operation:op)
      }
      for dependency in dependenciesFromConditions {
        op.addDependency(dependency)
        self.addOperation(op)
      }
      // TODO(simonli): deal with mutual exclusivity.
      op.willEnqueue()
    } else {
      op.addCompletionBlock {
        // TODO(simonli): notify delegate about the completion of this operation
      }
    }
    super.addOperation(op)
  }
}
