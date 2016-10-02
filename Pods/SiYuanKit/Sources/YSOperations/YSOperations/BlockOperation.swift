//
//  BlockOperation.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-16.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation

public typealias OperationBlock = (@escaping (Void) -> Void) -> Void

public class BlockOperation: YSOperation {
  private let block: OperationBlock?
  
  /**
    The designated initializer.
   
    - parameter block: The closure to run when the operation executes. This
    closure will be run on an arbitrary queue. The parameter passed to the
    block **MUST** be invoked by your code, or else the `BlockOperation`
    will never finish executing. If this parameter is `nil`, the operation
    will immediately finish.
   */
  init(block: OperationBlock? = nil) {
    self.block = block
    super.init()
  }
  
  /**
    A convenience initializer to execute a block on the main queue.
   
    - parameter mainQueueBlock: The block to execute on the main queue. Note
    that this block does not have a "continuation" block to execute (unlike
    the designated initializer). The operation will be automatically ended
    after the `mainQueueBlock` is executed.
   */
  convenience init(mainQueueBlock: @escaping (Void) -> Void) {
    self.init(block: { continuation in
      DispatchQueue.main.async {
        mainQueueBlock()
        continuation()
      }
    })
  }
  
  override func execute() {
    guard let block = block else {
      finish()
      return
    }
    
    block {
      self.finish()
    }
  }
  
  override func finished(errors: [Error]) {
  }
}
