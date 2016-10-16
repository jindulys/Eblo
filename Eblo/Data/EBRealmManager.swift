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
  
  // MARK: - Helper
  func writeWithLocalFile() {
    if let path = Bundle.main.path(forResource: "companies", ofType: "json") {
      do {
        let data = try NSData(contentsOfFile: path ,options: .dataReadingMapped)
        let jsonResult = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? NSDictionary
        if let companies = jsonResult?["companies"] as? NSArray {
          realmQueue.async {
            let realm = try! Realm()
            try! realm.write {
              for company in companies {
                if let aCompany = company as? NSDictionary, let name = aCompany["name"] as? String,
                  let url = aCompany["blogURL"] as? String {
                  let createdCompany = EBCompany()
                  createdCompany.companyName = name
                  createdCompany.blogURL = url
                  createdCompany.UUID = createdCompany.companyName + createdCompany.blogURL
                  createdCompany.blogTitle = name
                  realm.add(createdCompany, update: true)
                }
              }
            }
          }
          for company in companies {
            if let aCompany = company as? NSDictionary {
              print(aCompany["blogURL"])
            }
          }
        }
      } catch {
        // TODO(simonli:) handle local file error.
      }
    }
  }
}
