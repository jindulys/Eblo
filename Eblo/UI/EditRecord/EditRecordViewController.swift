//
//  EBEditRecordViewController.swift
//  Eblo
//
//  Created by yansong li on 2016-10-15.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit
import RealmSwift
import Ji

class EditRecordViewController: UIViewController {
  let companyNameTextField = UITextField()
  let urlTextField = UITextField()
  let titleXpathField = UITextField()
  let URLXpathField = UITextField()
  let promptLabel = UILabel()
  let resultTextView = UITextView()
  let testXpathButton = UIButton()
  let doneButton = UIButton()

  override func viewDidLoad() {
    self.view.backgroundColor = UIColor.white
    self.setUpSubViews()
    self.buildConstraint()
  }

  func setUpSubViews() {
    companyNameTextField.backgroundColor = UIColor.yellow
    companyNameTextField.delegate = self
    companyNameTextField.placeholder = "Company Name Input here"
    urlTextField.backgroundColor = UIColor.yellow
    urlTextField.delegate = self
    urlTextField.placeholder = "Company URL Input here"
    titleXpathField.backgroundColor = UIColor.yellow
    titleXpathField.delegate = self
    titleXpathField.placeholder = "Title Xpath Input Here"
    URLXpathField.backgroundColor = UIColor.yellow
    URLXpathField.delegate = self
    URLXpathField.placeholder = "URL Xpath Input here"
    promptLabel.backgroundColor = UIColor.green
    promptLabel.numberOfLines = 0
   // resultTextView.isUserInteractionEnabled = false
    resultTextView.layer.borderColor = UIColor.black.cgColor
    resultTextView.layer.borderWidth = 2.0
    resultTextView.text = ""
    self.doneButton.addTarget(self,
                              action: #selector(finishedEditting),
                              for: .touchUpInside)
    self.doneButton.setTitle("Done", for: .normal)
    self.doneButton.setTitleColor(UIColor.blue, for: .normal)
    self.doneButton.backgroundColor = UIColor.gray

    self.testXpathButton.addTarget(self,
                              action: #selector(startTesting),
                              for: .touchUpInside)
    self.testXpathButton.setTitle("Test Xpath", for: .normal)
    self.testXpathButton.setTitleColor(UIColor.blue, for: .normal)
    self.testXpathButton.backgroundColor = UIColor.gray

    self.view.addAutoLayoutSubView(companyNameTextField)
    self.view.addAutoLayoutSubView(urlTextField)
    self.view.addAutoLayoutSubView(doneButton)
    self.view.addAutoLayoutSubView(titleXpathField)
    self.view.addAutoLayoutSubView(URLXpathField)
    self.view.addAutoLayoutSubView(promptLabel)
    self.view.addAutoLayoutSubView(testXpathButton)
    self.view.addAutoLayoutSubView(resultTextView)
  }

  func buildConstraint() {
    self.companyNameTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
    self.companyNameTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 12.0).isActive = true
    self.companyNameTextField.heightAnchor.constraint(equalToConstant: 36.0).isActive = true

    self.urlTextField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
    self.urlTextField.topAnchor.constraint(equalTo: self.companyNameTextField.bottomAnchor, constant: 12.0).isActive = true
    self.urlTextField.heightAnchor.constraint(equalToConstant: 36.0).isActive = true

    self.titleXpathField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
    self.titleXpathField.topAnchor.constraint(equalTo: self.urlTextField.bottomAnchor, constant: 12.0).isActive = true
    self.titleXpathField.heightAnchor.constraint(equalToConstant: 36.0).isActive = true

    self.URLXpathField.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
    self.URLXpathField.topAnchor.constraint(equalTo: self.titleXpathField.bottomAnchor, constant: 12.0).isActive = true
    self.URLXpathField.heightAnchor.constraint(equalToConstant: 36.0).isActive = true

    self.testXpathButton.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
    self.testXpathButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
    self.testXpathButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
    self.testXpathButton.topAnchor.constraint(equalTo: self.URLXpathField.bottomAnchor, constant: 30.0).isActive = true

    self.resultTextView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0, constant: -32).isActive = true
    self.resultTextView.topAnchor.constraint(equalTo: self.testXpathButton.bottomAnchor, constant: 12.0).isActive = true
    self.resultTextView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    self.resultTextView.heightAnchor.constraint(equalToConstant: 160.0).isActive = true

    self.promptLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1.0).isActive = true
    self.promptLabel.topAnchor.constraint(equalTo: self.resultTextView.bottomAnchor, constant: 12.0).isActive = true
    self.promptLabel.heightAnchor.constraint(equalToConstant: 56.0).isActive = true

    self.doneButton.widthAnchor.constraint(equalToConstant: 180.0).isActive = true
    self.doneButton.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
    self.doneButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0.0).isActive = true
    self.doneButton.topAnchor.constraint(equalTo: self.promptLabel.bottomAnchor, constant: 30.0).isActive = true
  }

  func finishedEditting() {
    guard let company = companyNameTextField.text,
      let url = urlTextField.text,
      let titleXpath = titleXpathField.text,
      let urlXpath = URLXpathField.text else {
        promptLabel.text = "Check all your four fields"
        promptLabel.backgroundColor = UIColor.red
      return
    }
    promptLabel.text = "Will Inserted to database\n for this version URL only support full URL"
    promptLabel.backgroundColor = UIColor.green

    RealmCompanyManager.sharedInstance.writeWithBlock { realm in
      let createdCompany = Company()
      createdCompany.companyName = company
      createdCompany.blogURL = url
      createdCompany.UUID = company + url
      createdCompany.blogTitle = company
      createdCompany.xPathArticleTitle = titleXpath
      createdCompany.xPathArticleURL = urlXpath
      realm.add(createdCompany, update: true)
    }
  }

  func startTesting() {
    resultTextView.text = ""
    promptLabel.text = "Start Testing"
    promptLabel.backgroundColor = UIColor.green
    guard let url = urlTextField.text,
      let titleXpath = titleXpathField.text,
      let urlXpath = URLXpathField.text else {
        promptLabel.text = "Check all your fields"
        promptLabel.backgroundColor = UIColor.red
      return
    }
    promptLabel.text = "Check your result"
    promptLabel.backgroundColor = UIColor.green
    guard let validUrl = URL(string: url) else {
      promptLabel.text = "Invalid URL, please check company URL field"
      promptLabel.backgroundColor = UIColor.red
      return
    }
    let testDoc = Ji(htmlURL: validUrl)
    let testNode = testDoc?.xPath(titleXpath)
    var result = "Title: \n"
    var testOutput = ""
    if let validTestNode = testNode {
      for t in validTestNode {
        result.append("\(t.content)\n")
      }
    } else {
      testOutput.append("Seems your title xPath has some problem!\n")
    }
    result.append("URLs: \n")
    let urlNodes = testDoc?.xPath(urlXpath)
    if let validURLNode = urlNodes {
      for u in validURLNode {
        print("\(u.content)\n")
      }
    } else {
      testOutput.append("as well as url xPath")
    }
    if testOutput.characters.count > 0 {
      promptLabel.text = testOutput
      promptLabel.backgroundColor = UIColor.red
    }
    resultTextView.text = result
  }
}

extension EditRecordViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
