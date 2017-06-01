//
//  CompanySectionController.swift
//  Eblo
//
//  Created by yansong li on 2017-05-31.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import IGListKit
import SafariServices
import UIKit

/// Section controller for company.
final class CompanySectionController: ListSectionController {
  
  var company: EbloCompany!
  
  override func sizeForItem(at index: Int) -> CGSize {
    guard let context = collectionContext, let company = company else {
      return .zero
    }
    let width = context.containerSize.width
    var calculatedSize = EbloCompanyCell.cellSize(width: width, company: company)
    calculatedSize.width = width
    return calculatedSize
  }
  
  override func cellForItem(at index: Int) -> UICollectionViewCell {
    let cell = collectionContext!.dequeueReusableCell(of: EbloCompanyCell.self, for: self, at: index)
    if let companyCell = cell as? EbloCompanyCell {
      companyCell.populate(company: company)
    }
    return cell
  }

  override func didUpdate(to object: Any) {
    company = object as? EbloCompany
  }
  
  override func didSelectItem(at index: Int) {
    print("Currently select \(company.companyName)")
//    var toOpenString = blog.urlString
//    if let decodeString = toOpenString.removingPercentEncoding,
//      let encoded = decodeString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed.union(CharacterSet(charactersIn:"?"))){
//      toOpenString = encoded
//    }
//    guard let validURL = URL(string: toOpenString) else {
//      print("Problematic URL")
//      return
//    }
//    let svc = SFSafariViewController(url: validURL)
//    svc.title = blog.companyName
//    AppManager.sharedInstance.presentToNavTop(controller: svc)
  }
}
