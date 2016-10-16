//
//  EBEditRecordViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-10-15.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit
import RealmSwift

class EBEditRecordViewController: UIViewController {

  var companyNameTextField = UITextField()

  var urlTextField = UITextField()

  var doneButton = UIButton()

  override func viewDidLoad() {
    self.view.backgroundColor = UIColor.white
    self.setUpSubViews()
    self.buildConstraint()
  }

  func setUpSubViews() {
    companyNameTextField.backgroundColor = UIColor.yellow
    companyNameTextField.delegate = self
    urlTextField.backgroundColor = UIColor.yellow
    urlTextField.delegate = self
    self.doneButton.addTarget(self,
                              action: #selector(finishedEditting),
                              for: .touchUpInside)
    self.doneButton.setTitle("Done", for: .normal)
    self.doneButton.setTitleColor(UIColor.blue, for: .normal)

    self.view.addAutoLayoutSubView(companyNameTextField)
    self.view.addAutoLayoutSubView(urlTextField)
    self.view.addAutoLayoutSubView(doneButton)
  }

  func buildConstraint() {
    self.companyNameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
    self.companyNameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 30.0).isActive = true
    self.companyNameTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    self.urlTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
    self.urlTextField.topAnchor.constraint(equalTo: self.companyNameTextField.bottomAnchor, constant: 30.0).isActive = true
    self.urlTextField.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
    self.doneButton.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
    self.doneButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    self.doneButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
    self.doneButton.topAnchor.constraint(equalTo: self.urlTextField.bottomAnchor, constant: 30.0).isActive = true
  }

  func finishedEditting() {
    guard let company = companyNameTextField.text, let url = urlTextField.text else {
      return
    }
    EBRealmManager.sharedInstance.writeWithBlock { realm in
      let createdCompany = EBCompany()
      createdCompany.companyName = company
      createdCompany.blogURL = url
      createdCompany.UUID = company + url
      createdCompany.blogTitle = company
      realm.add(createdCompany, update: true)
    }
  }
}

extension EBEditRecordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
