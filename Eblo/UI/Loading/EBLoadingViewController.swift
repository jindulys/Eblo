//
//  LoadingViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-08-14.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit
import SiYuanKit

/// View Controller showing an activity indicator at the center.
class EBLoadingViewController: UIViewController {
  
  /// The activity indicator view.
  let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.red()
    self.setupSubViews()
    self.buildConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.activityIndicator.startAnimating()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.activityIndicator.stopAnimating()
  }
  
  func setupSubViews() {
    self.view.addAutoLayoutSubView(self.activityIndicator)
  }
  
  func buildConstraints() {
    activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
  }
}
