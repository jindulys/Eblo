//
//  EbloCompanyRealmService.swift
//  Eblo
//
//  Created by yansong li on 2017-06-02.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import Foundation
import RealmSwift
import SiYuanKit

/// The class for realm interaction of company object.
class EbloCompanyRealmService {
  
  /// Return all companies.
  func allCompany() -> [EbloCompany] {
    let realm = try! Realm()
    let companies = realm.objects(EbloCompany.self)
      .sorted(byKeyPath: "positionIndex", ascending: true)
    return companies.toArray()
  }
  
  /// Fetch new companies and store the update result in database.
  func fetchNewCompanies(completion: @escaping ([EbloCompany]) -> Void) {
    let companyFetchService = EbloDataFetchService()
    // Fetch new companies.
    companyFetchService.fetchCompanyList { (success, companies) in
      guard success, let fetchedCompanies = companies else {
        return
      }
      let existingCompanies = self.allCompany()
      let existingCompaniesSet = Set(existingCompanies.map { $0.identifier() })
      let newCompanies = fetchedCompanies.filter { company -> Bool in
        !existingCompaniesSet.contains(company.identifier())
      }
      var positionIndex = 0
      // Update new companies' positonIndex since by default it is 0.
      newCompanies.forEach { company in
        company.positionIndex = positionIndex
        positionIndex += 1
      }
      // Update existing companies' positionIndex
      existingCompanies.forEach { company in
        company.positionIndex += positionIndex
      }
      // Merge new companies with updated existing companies.
      let updatedCompanies = newCompanies + existingCompanies
      // Update database's data.
      do {
        let realm = try! Realm()
        try realm.write {
          updatedCompanies.forEach { company in
            realm.add(company, update: true)
          }
        }
        GCDQueue.main.async {
          // NOTE: According to realm model's restriction, you can only use an object on
          // the thread which it was created, here since we have a thread switch, I create
          // a new set of fetched companies.
          completion(self.allCompany())
        }
      } catch {
        print("Realm Write Error")
      }
    }
  }
}
