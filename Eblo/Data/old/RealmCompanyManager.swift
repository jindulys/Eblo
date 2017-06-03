//
//  EBRealmManager.swift
//  Eblo
//
//  Created by yansong li on 2016-10-15.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import RealmSwift
import SiYuanKit

let localJSONGotIn = "localJSONGotIn"

/// Protocol used for notify UI delegate UI events.
protocol RealmCompanyManagerUIDelegate: class {
  /// Tell the UI Delegate that row was tapped with necessary info.
  func tappedRow(companyUUID: String)
}

/// The realm manager which is responsible for read/write management of Company Object.
class RealmCompanyManager: InitiatedDataManager {

  /// The shared singleton.
  static let sharedInstance = RealmCompanyManager()

  /// Use a serial Queue as the write queue.
  private let realmQueue = GCDQueue.serial("RealmCompany", .initiated)

  /// An operation Queue used for company's update.
  private let companyUpdateOperationQueue = YSOperationQueue()

  /// The UI Delegate which is responsible for touch event.
  weak var uiDelegate: RealmCompanyManagerUIDelegate?

  /// This method updates the company's information(Blog).
  /// Current Design like this:
  ///
  /// Each app launch time, this method will be called, and this method should not block UI operation.
  /// I'll use operation to update each company's info serially and run in back ground.
  /// Each time a company's update finished, it will update UI.
  ///
  /// Future work. 1. Batch Update.
  ///              2. A notification when all the update finished.
  ///              3. Refresh update.(which might be called by View Controller)
  func updateCompanyArticles() {
    realmQueue.async {
      if let allCompanies = self.allCompanies() {
        for company in allCompanies {
          if let titlePath = company.xPathArticleTitle,
            let urlPath = company.xPathArticleURL {
            let updateOperation =
                CompanyArticleFetchOperation(companyName: company.companyName,
                                             companyBlogURL: company.blogURL,
                                             xPathArticleTitle: titlePath,
                                             xPathArticleURL: urlPath,
                                             needBlogBaseURL: company.articleURLNeedBlogURL)
            self.companyUpdateOperationQueue.addOperation(updateOperation)
          }
        }
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
  
  // Delete all companies in this data base.
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

  /// Update a company's blogs information with blogInfos, which is specified by UUID.
  ///
  /// - parameter UUID: UUID for a company
  ///
  /// - parameter blogInfos: CompanyBlog.BLOGTITLE stores blogTitles.
  ///                        CompanyBlog.BLOGURL stores blogURLs.
  func updateCompanyWith(UUID: String,
                         blogInfos: [CompanyBlog],
                         completion: @escaping (()->()) = {}) {
    realmQueue.async {
      do {
        let realm = try Realm()
        guard let updateCompany = realm.objects(Company.self).filter("UUID = '\(UUID)'").first else {
          return
        }
        let currentBlogsTitles = updateCompany.blogs.map { $0.blogTitle }
        let newBlogs: [CompanyBlog] = blogInfos.filter {
          !currentBlogsTitles.contains($0.blogTitle)
        }
        // No update.
        if newBlogs.count == 0 {
          return
        }
        try realm.write {
          let latestArticleTitle = newBlogs.first?.blogTitle
          newBlogs.reversed().forEach {
            $0.blogID = RealmBlogManager.nextBlogID()
            realm.add($0, update: true)
            updateCompany.blogs.insert($0, at: 0)
          }
          updateCompany.hasNewArticlesToRead = true
          updateCompany.latestArticleTitle = latestArticleTitle!
          realm.add(updateCompany, update: true)
        }
        completion()
        // We remove this for now, since we use KVO, the company tableView manager will update related cell(which get stale) correctly.
        //self.notifySubscriber()
      } catch {
        // TODO(simonli): fix error case
        print("Realm Write Error!")
      }
    }
  }

  /// Clear a company's has new articles flag.
  func clearNewArticlesFlagWith(UUID: String) {
    realmQueue.async {
      do {
        let realm = try Realm()
        guard let updateCompany = realm.objects(Company.self).filter("UUID = '\(UUID)'").first else {
          return
        }
        try realm.write {
          updateCompany.hasNewArticlesToRead = false
          realm.add(updateCompany, update: true)
        }
      } catch {
        // TODO(simonli): fix error case
        print("Realm Write Error!")
      }
    }
  }

  /// clear all companies' has new articles to read flag.
  func clearAllNewArticlesFlag() {
    realmQueue.async {
      do {
        let realm = try Realm()
        let allCompanies = self.allCompanies()
        if let companies = allCompanies {
          try realm.write {
            for company in companies {
              company.hasNewArticlesToRead = false
            }
          }
        }
      } catch {
        // TODO(simonli): fix error case
        print("Realm Write Error!")
      }
    }
  }

  // MARK: - Queries
  /// Return all companies in this data base.
  func allCompanies() -> Results<Company>? {
    let realm = try! Realm()
    return realm.objects(Company.self)
  }

  /// Return a company specified by UUID or nil.
  func companyWith(UUID: String) -> Company? {
    do {
      let realm = try Realm()
      guard let updateCompany = realm.objects(Company.self).filter("UUID = '\(UUID)'").first else {
        return nil
      }
      return updateCompany
    } catch {
      // TODO(simonli): fix error case
      print("Realm Write Error!")
      return nil
    }
  }

  /// Detect whether or not a company existing.
  func existingCompany(UUID: String) -> Bool {
    do {
      let realm = try Realm()
      guard let _ = realm.objects(Company.self).filter("UUID = '\(UUID)'").first else {
        return false
      }
      return true
    } catch {
      // TODO(simonli): fix error case
      return false
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
                    let createdCompany = Company()
                    createdCompany.companyName = name
                    createdCompany.blogURL = url
                    createdCompany.UUID = createdCompany.companyName + createdCompany.blogURL
                    createdCompany.blogTitle = name
                    createdCompany.xPathArticleTitle = aCompany["xPathArticleTitle"] as? String
                    createdCompany.xPathArticleURL = aCompany["xPathArticleURL"] as? String
                    if let needBaseURL = aCompany["needBaseBlogURL"] as? String,
                      needBaseURL == "1" {
                      createdCompany.articleURLNeedBlogURL = true
                    }
                    realm.add(createdCompany, update: true)
                  }
                }
              }
              self.notifySubscriber()
            }
          }
        } catch {
          // TODO(simonli:) handle local file error.
          print("Error happened")
        }
      }
      userDefault.set(true, forKey: localJSONGotIn)
    }
  }

  /// This helper method could use to add new entities from 'companies.json' repeatedly.
  func repeatedWriteWithLocalFile(completion:(() -> ())? = nil) {
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
                  if self.existingCompany(UUID: name + url) {
                    continue
                  }
                  let createdCompany = Company()
                  createdCompany.companyName = name
                  createdCompany.blogURL = url
                  createdCompany.UUID = createdCompany.companyName + createdCompany.blogURL
                  createdCompany.blogTitle = name
                  createdCompany.xPathArticleTitle = aCompany["xPathArticleTitle"] as? String
                  createdCompany.xPathArticleURL = aCompany["xPathArticleURL"] as? String
                  if let needBaseURL = aCompany["needBaseBlogURL"] as? String,
                    needBaseURL == "1" {
                    createdCompany.articleURLNeedBlogURL = true
                  }
                  realm.add(createdCompany, update: true)
                }
              }
            }
            if let completion = completion {
              completion()
            }
            //self.notifySubscriber()
          }
        }
      } catch {
        // TODO(simonli:) handle local file error.
        print("Error happened")
      }
    }
  }
}

extension RealmCompanyManager: TableViewManagerDataSource {
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
          self.clearNewArticlesFlagWith(UUID: company.UUID)
          if let uiDelegate = self.uiDelegate {
            uiDelegate.tappedRow(companyUUID: company.UUID)
          }
        }
        let currentRow =
          Row(title: company.companyName,
              description: company.latestArticleTitle,
              image: nil,
              action: rowAction,
              cellType: CompanyCell.self,
              cellIdentifier: "company",
              customData: company,
              UUID: company.UUID)
        result.append(currentRow)
      }
    }
    return .SingleSection(result)
  }
}
