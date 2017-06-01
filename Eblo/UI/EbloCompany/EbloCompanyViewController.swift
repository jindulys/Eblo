//
//  EbloCompanyViewController.swift
//  Eblo
//
//  Created by yansong li on 2017-05-31.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import IGListKit
import UIKit

/// The view controller for engineering blogs list.
class EbloCompanyViewController: UIViewController {
  
  let collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    return collectionView
  }()
  
  var adapter: ListAdapter?
  
  var companyList: [EbloCompany]?
  
  var companySectionController: CompanySectionController?
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
    collectionView.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.view.addSubview(self.collectionView)
    
    let updater = ListAdapterUpdater()
    self.adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 0)
    adapter?.collectionView = self.collectionView
    adapter?.dataSource = self
    
    self.title = "Eng Blogs"
    let testFetch = EbloService()
    testFetch.fetchCompanyList { [weak self](finished, companyList) in
      if let fetched = companyList {
        self?.companyList = fetched
        DispatchQueue.main.async {
          self?.adapter?.performUpdates(animated: true)
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
}

extension EbloCompanyViewController: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    guard let companyList = self.companyList else {
      return []
    }
    return companyList
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    let companySectionController = CompanySectionController()
    self.companySectionController = companySectionController
    companySectionController.delegate = self
    return companySectionController
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
}

extension EbloCompanyViewController: CompanySectionControllerDelegate {
  func didTapCompanyWith(id: Int) {
    ScreenTransitionManager.transitionScreenWith(viewController: self,
                                                 entryPoint: self.blogEntry,
                                                 params: "id=\(id)")
  }
}

extension EbloCompanyViewController: TransitionViewController {
  var sourceScreenName: String {
    return String(describing:type(of: self))
  }
  
  public var blogEntry: String {
    return "ebloBlogList"
  }
}
