//
//  CompanyCell.swift
//  Eblo
//
//  Created by yansong li on 2016-10-23.
//  Copyright © 2016 YANSONG LI. All rights reserved.
//

import UIKit
import SiYuanKit

/// This cell is used to display a normal item, a title and a body.
public class CompanyCell: UITableViewCell {
  /// Title label.
  let titleLabel: UILabel

  /// Body label.
  let bodyLabel: UILabel

  /// The new badge view.
  let newBadgeView: UILabel

  /// The new badge size.
  let badgeSize: CGFloat = 20

  /// The company data with this cell.
  var company: EBCompany? = nil

  /// The company context for this cell.
  private var companyContext = 0

  /// The company article context.
  private var companyArticleContext = 0

  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    titleLabel = UILabel()
    bodyLabel = UILabel()
    newBadgeView = UILabel()
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    buildConstraints()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    titleLabel.numberOfLines = 1
    titleLabel.font = UIFont.systemFont(ofSize: 16, weight: 20)
    self.contentView.addAutoLayoutSubView(titleLabel)
    
    bodyLabel.numberOfLines = 0
    self.contentView.addAutoLayoutSubView(bodyLabel)

    newBadgeView.text = "新"
    newBadgeView.textColor = UIColor.black
    newBadgeView.alpha = 0.0
    self.contentView.addAutoLayoutSubView(newBadgeView)
  }

  private func buildConstraints() {
    titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: self.bodyLabel.topAnchor, constant: -12 ).isActive = true
    bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12).isActive = true
    bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12).isActive = true
    newBadgeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
    newBadgeView.widthAnchor.constraint(equalToConstant: 36).isActive = true
    newBadgeView.heightAnchor.constraint(equalToConstant: self.badgeSize).isActive = true
    newBadgeView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -12).isActive = true
  }

  // MARK: -
  func configureCompany(_ company : EBCompany) {
    if let oldCompany = self.company {
      if oldCompany.UUID != company.UUID {
        oldCompany.removeObserver(self, forKeyPath: "hasNewArticlesToRead")
        self.addObserverWithCompany(company)
      }
    } else {
      // New one, we could directly add observer.
      self.addObserverWithCompany(company)
    }
  }
  
  func addObserverWithCompany(_ company: EBCompany) {
    self.company = company
    company.addObserver(self, forKeyPath: "hasNewArticlesToRead", options: .new, context: &self.companyContext)
    company.addObserver(self, forKeyPath: "latestArticleTitle", options: .new, context: &self.companyArticleContext)
  }

  public override func observeValue(forKeyPath keyPath: String?,
                                    of object: Any?,
                                    change: [NSKeyValueChangeKey : Any]?,
                                    context: UnsafeMutableRawPointer?) {
    if context == &self.companyContext {
      if let newValue = change?[NSKeyValueChangeKey.newKey] as? Bool {
        animateNewBadge(on: newValue)
      }
    }
    if context == &self.companyArticleContext {
      if let newValue = change?[NSKeyValueChangeKey.newKey] as? String {
        animateNewArticle(newValue)
      }
    }
  }

  func animateNewBadge(on: Bool) {
    // NOTE: I find that animation directly inside a cell has no effect.
    self.newBadgeView.alpha = on ? 1.0 : 0.0
  }

  func animateNewArticle(_ article: String) {
    // TODO(simonli): after test, I found that tableview cell will not update view hierarchy layout
    // might need a way to delegate up to table view manager to trigger a specific update for this cell.
    self.bodyLabel.text = article
  }
}

extension CompanyCell: StaticCellType {
  public func configure(row: Row) {
    if let company = row.customData as? EBCompany {
      // NOTE: use company as the actually data source, since company is a realm object and it is
      // keep sync with the actually database update.
      self.titleLabel.text = company.companyName
      self.bodyLabel.text = company.latestArticleTitle
      self.configureCompany(company)
      self.newBadgeView.alpha = company.hasNewArticlesToRead ? 1.0 : 0.0
    }
  }
}
