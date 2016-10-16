//
//  EBRealmManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-15.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import SiYuanKit

/// The realm manager which is responsible for read/write management of a realm file.
class EBRealmManager {

  static let sharedInstance = EBRealmManager()

  /// Use a serial Queue as the write queue.
  let realmQueue = GCDQueue.serial("Realm", .initiated)

  // MARK: - Queries
  func allCompanies() -> Results<EBCompany>? {
    let realm = try! Realm()
    return realm.objects(EBCompany.self)
  }
  
  // MARK: - Delete
  func deleteAllCompanies() {
    realmQueue.async {
      do {
        let realm = try Realm()
        try realm.write {
          let allCompanies = self.allCompanies()
          if let companies = allCompanies {
            for company in companies {
              realm.delete(company)
            }
          }
        }
      } catch {
        // TODO(simonli): fix error case
        print("Realm Write Error!")
      }
    }
  }
  
  // MARK: - Write
  
  /// Write transction with block
  func writeWithBlock(_ block: @escaping (Realm) -> ()) {
    realmQueue.async {
      do {
        let realm = try! Realm()
        let writeWrapper = {
          block(realm)
        }
        try realm.write(writeWrapper)
      } catch {
        // TODO(simonli): fix error case
        print("Realm Write Error!")
      }

    }
  }
}
