//
//  Time.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-23.
//
//
// NOTE: No dependency

import Foundation

public struct Time {
  private static let wastingTimeGroup = DispatchGroup()
  
  /// This method will run a specific time until time expire, this will block your current thread.
  public static func longRun(duration: Double) {
    let localConcurrentQueue = GCDQueue.concurrent("localConcurrent", .utility)
    localConcurrentQueue.sync {
      wastingTimeGroup.enter()
    }
    localConcurrentQueue.after(when: duration) { 
      wastingTimeGroup.leave()
    }
    wastingTimeGroup.wait()
  }
}
