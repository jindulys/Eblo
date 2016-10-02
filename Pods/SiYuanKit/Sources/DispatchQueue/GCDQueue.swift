//
//  GCDQueue.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-21.
//
//
// NOTE: No dependency

import Foundation

public enum GCDQueue: Comparable {
  /// The main queue
  case main

  /// The default QOS
  case `default`

  /// Use for user initiated tasks which do not impact the UI. Such as data processing.
  case initiated

  /// Use for user initiated tasks which do impact the UI - e.g. a rendering pipeline.
  case interactive

  /// Use for non-user initiated task.
  case utility

  /// Background QOS is a severly limited class, should not be used for anything
  /// when the app is active.
  case background

  /// A serial queue, with a name and QOS class.
  indirect case serial(String, GCDQueue)

  /// A concurrent queue, which a name and QOS class.
  indirect case concurrent(String, GCDQueue)

  /// DummySerial queue for comparison.
  private var dummySerial: GCDQueue {
    return .serial("dummy", .background)
  }

  /// DummyConcurrent queue for comparison.
  private var dummyConcurrent: GCDQueue {
    return .concurrent("dummy", .background)
  }

  /// queue attribute.
  private var qos_attributes: DispatchQoS {
    switch self {
    case .initiated:
      return DispatchQoS.userInitiated
    case .interactive:
      return DispatchQoS.userInteractive
    case .utility:
      return DispatchQoS.utility
    case .background:
      return DispatchQoS.background
    default:
      return DispatchQoS.default
    }
  }

  /// global queue attribute.
  private var qos_global_attributes: DispatchQoS.QoSClass {
    switch self {
    case .initiated:
      return .userInitiated
    case .interactive:
      return .userInteractive
    case .utility:
      return .utility
    case .background:
      return .background
    default:
      return .default
    }
  }

  /// The DispatchQueue.
  public var queue: DispatchQueue {
    switch self {
    case .main:
      return .main
    case .interactive, .initiated, .background, .utility:
      return DispatchQueue.global(qos: qos_global_attributes)
    case let .serial(name, qos) where qos < dummySerial:
      if #available(iOS 10.0, *) {
        return DispatchQueue(label: name, qos: qos.qos_attributes)
      } else {
        // Fallback on earlier versions
        return .main
      }
    case let .concurrent(name, qos) where qos < dummyConcurrent:
      return DispatchQueue(label: name, qos: qos.qos_attributes, attributes: .concurrent)
    default:
      return .main
    }
  }

  // TODO(simonli): for now only support async with work block, the other potential
  // parameters use Default value.
  /**
    Async takes a block parameter and run asynchronously.
    
    - parameter execute: the block to be executed.
  */
  public func async(execute: @escaping () -> Void) {
    self.queue.async(execute: execute)
  }

  /**
   Sync takes a block parameter and run asynchronously.
   - NOTE: carefully use sync, do not sync on serial queue.
   
   - parameter execute: the block to be executed.
   */
  public func sync(execute: () -> Void) {
    self.queue.sync(execute: execute)
  }

  public func after(when: Double, execute: @escaping () -> Void) {
    let delayTime = DispatchTime.now() + when
    self.queue.asyncAfter(deadline: delayTime, execute: execute)
  }

  /// Run the block if we are in main thread, or add this block to main queue 
  /// asynchronously.
  static public func runOrAddMainQueue(block: @escaping () -> Void) {
    if Thread.isMainThread {
      block()
    } else {
      GCDQueue.main.async(execute: block)
    }
  }
}

public func <(lhs: GCDQueue, rhs: GCDQueue) -> Bool {
  switch (lhs, rhs) {
  case (.interactive, .serial),
       (.initiated, .serial),
       (.background, .serial),
       (.utility, .serial),
       (.`default`, .serial),
       (.interactive, .concurrent),
       (.initiated, .concurrent),
       (.background, .concurrent),
       (.utility, .concurrent),
       (.`default`, .concurrent):
    return true
  default:
    return false
  }
}

public func ==(lhs: GCDQueue, rhs: GCDQueue) -> Bool {
  switch (lhs, rhs) {
  case (.main, .main):
    return true
  case (.interactive, .interactive):
    return true
  case (.initiated, .initiated):
    return true
  case (.background, .background):
    return true
  case (.`default`, .`default`):
    return true
  case (.utility, .utility):
    return true
  case (.serial, .serial):
    return true
  case (.concurrent, .concurrent):
    return true
  default:
    return false
  }
}

