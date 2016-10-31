//
//  InitiatedDataManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-30.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import Foundation
import SiYuanKit

/// Protocol to notify the subscripter the event of this Manager.
protocol InitiatedDataManagerSubScriberDelegate: class {
  /// This company manager has produced a new set of data.
  func hasNewDataSet() -> Void
}

/// The data manager which could tell its subscriber that new data has arrived.
class InitiatedDataManager {

  /// Potentional subscriber, which will be notified when there have some updates of database.
  weak var subscriber: InitiatedDataManagerSubScriberDelegate?

  /// Notify the subscriber that data has changed.
  func notifySubscriber() {
    GCDQueue.main.async {
      if let subscriber = self.subscriber {
        subscriber.hasNewDataSet()
      }
    }
  }
}
