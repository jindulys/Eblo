//
//  EbloCompanyViewController.swift
//  Eblo
//
//  Created by yansong li on 2017-05-31.
//  Copyright © 2017 YANSONG LI. All rights reserved.
//

import IGListKit
import UIKit
import SiYuanKit

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
  
  /// The data store of eblo company.
  let ebloCompanyDataStore = EbloCompanyRealmService()
  
  /// refresh control.
  var refreshControl: UIRefreshControl!
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    collectionView.frame = view.bounds
    collectionView.backgroundColor = .white
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "Eng Blogs"
    self.view.backgroundColor = UIColor.white
    self.navigationController?.navigationBar.isTranslucent = false
    self.view.addSubview(self.collectionView)
    let refresher = UIRefreshControl()
    refresher.tintColor = UIColor.gray
    refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
    self.refreshControl = refresher
    self.collectionView.addSubview(refresher)
    
    let updater = ListAdapterUpdater()
    self.adapter = ListAdapter(updater: updater, viewController: self, workingRangeSize: 0)
    adapter?.collectionView = self.collectionView
    adapter?.dataSource = self

    self.companyList = ebloCompanyDataStore.allCompany()
    self.adapter?.performUpdates(animated: true)
    
    self.ebloCompanyDataStore.fetchNewCompanies { [weak self] companies in
      // NOTE: Keep scroll position
      // https://github.com/Instagram/IGListKit/issues/644#issuecomment-294359113
      GCDQueue.main.async {
        let visibleCells = self?.collectionView.visibleCells
        var previousOriginY: CGFloat = 0.0
        var previousVisibleCompanyIdentifier: String = ""
        if let topMostVisibleCell = visibleCells?.first,
          let topMostIndex = self?.collectionView.indexPath(for: topMostVisibleCell),
          let frameAttributes = self?.collectionView.collectionViewLayout.layoutAttributesForItem(at: topMostIndex),
          let topVisibleCompany = self?.companyList?[topMostIndex.section] {
          previousOriginY = frameAttributes.frame.origin.y
          previousVisibleCompanyIdentifier = topVisibleCompany.identifier()
        }
        self?.companyList = companies
        self?.adapter?.performUpdates(animated: false) { _ in
          if let currentTopVisibleCompanyIndex = self?.companyList?.index(where: { company -> Bool in
            company.identifier() == previousVisibleCompanyIdentifier
            }),
            let newFrameAttributes = self?.collectionView.collectionViewLayout.layoutAttributesForItem(at: IndexPath(row:0 , section: currentTopVisibleCompanyIndex)) {
            let newOriginY = newFrameAttributes.frame.origin.y
            self?.collectionView.contentOffset.y += newOriginY - previousOriginY
          }
        }
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  func loadData() {
    self.ebloCompanyDataStore.fetchNewCompanies { [weak self] companies in
      GCDQueue.main.async {
        self?.companyList = companies
        self?.adapter?.performUpdates(animated: true, completion: { _ in
          self?.refreshControl.endRefreshing()
        })
      }
    }
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
