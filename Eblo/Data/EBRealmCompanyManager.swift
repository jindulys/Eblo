//
//  EBRealmManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-15.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import SiYuanKit
import SafariServices

let localJSONGotIn = "localJSONGotIn"

/// Protocol to notify the subscripter the event of this Manager.
protocol EBRealmCompanyManagerDelegate: class {
  /// This company manager has produced a new set of data.
  func hasNewDataSet() -> Void
}

/// The realm manager which is responsible for read/write management of a realm file.
class EBRealmCompanyManager {

  static let sharedInstance = EBRealmCompanyManager()

  /// Use a serial Queue as the write queue.
  let realmQueue = GCDQueue.serial("Realm", .initiated)
  
  weak var subscriber: EBRealmCompanyManagerDelegate?

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
          self.notifySubscriber()
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
        self.notifySubscriber()
      } catch {
        // TODO(simonli): fix error case
        print("Realm Write Error!")
      }

    }
  }
  
  // MARK: - Helper
  func writeWithLocalFile() {
    let userDefault = UserDefaults.standard
    if !userDefault.bool(forKey: localJSONGotIn) {
      if let path = Bundle.main.path(forResource: "companies", ofType: "json") {
        do {
          let data = try NSData(contentsOfFile: path ,options: .dataReadingMapped)
          let jsonResult = try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as? NSDictionary
          if let companies = jsonResult?["companies"] as? NSArray {
            realmQueue.async {
              let realm = try! Realm()
              try! realm.write {
                for company in companies {
                  if let aCompany = company as? NSDictionary, let name = aCompany["name"] as? String, let url = aCompany["blogURL"] as? String {
                    let createdCompany = EBCompany()
                    createdCompany.companyName = name
                    createdCompany.blogURL = url
                    createdCompany.UUID = createdCompany.companyName + createdCompany.blogURL
                    createdCompany.blogTitle = name
                    realm.add(createdCompany, update: true)
                  }
                }
              }
              self.notifySubscriber()
            }
          }
        } catch {
          // TODO(simonli:) handle local file error.
        }
      }
      userDefault.set(true, forKey: localJSONGotIn)
    }
  }

  /// Notify the subscriber that data has changed.
  func notifySubscriber() {
    GCDQueue.main.async {
      if let subscriber = self.subscriber {
        subscriber.hasNewDataSet()
      }
    }
  }
}

extension EBRealmCompanyManager: TableViewManagerDataSource {
  // TODO(simonli): for now everytime we want to update tableViewManager's data we
  // fetch all the data. Need to figure out a more efficient way if needed.
  // E.g. Has an id and only fetch that data related to this id then add it to the table view
  // manager.
  func fetchedData() -> TableViewData {
    var result: [Row] = []
    // TODO(simonli): move tableViewCell action logic out of this data model.
    if let companies = self.allCompanies() {
      for company in companies {
        let rowAction = {
          let svc = SFSafariViewController(url: NSURL(string: company.blogURL)! as URL)
          svc.title = company.companyName
          AppManager.sharedInstance.pushToNavTop(controller: svc)
        }
        let currentRow =
          Row(title: company.companyName,
              description: company.blogURL,
              image: nil,
              action: rowAction,
              cellType: ItemCell.self,
              cellIdentifier: "company",
              UUID: company.UUID)
        result.append(currentRow)
      }
    }
    return .SingleSection(result)
  }
}
