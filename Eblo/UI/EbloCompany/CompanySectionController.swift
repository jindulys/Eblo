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

/// Company section controller delegate.
protocol CompanySectionControllerDelegate: class {
  func didTapCompanyWith(id: Int) -> Void
}

/// Section controller for company.
final class CompanySectionController: ListSectionController {
  
  var company: EbloCompany!
  
  weak var delegate: CompanySectionControllerDelegate?
  
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
    if let validDelegate = delegate {
      validDelegate.didTapCompanyWith(id: company.companyID)
    }
  }
}
