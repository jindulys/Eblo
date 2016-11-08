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

  /// The new badge indicator
  let newBadgeIndicator: ColorCornerView

  /// The new badge size.
  let badgeSize: CGFloat = 20

  /// The company data with this cell.
  var company: Company? = nil

  /// The company context for this cell.
  private var companyContext = 0

  /// The company article context.
  private var companyArticleContext = 0

  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    titleLabel = UILabel()
    bodyLabel = UILabel()
    newBadgeIndicator = ColorCornerView(color: UIColor.red, position: .topRight, triangleSize: 24)
    newBadgeIndicator.contentMode = .redraw
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
    self.contentView.addAutoLayoutSubView(newBadgeIndicator)
  }

  private func buildConstraints() {
    titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: self.bodyLabel.topAnchor, constant: -12 ).isActive = true
    bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12).isActive = true
    bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12).isActive = true
    newBadgeIndicator.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
    newBadgeIndicator.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
    newBadgeIndicator.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
    newBadgeIndicator.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
  }
}

extension CompanyCell: StaticCellType {
  public func configure(row: Row) {
    if let company = row.customData as? Company {
      // NOTE: use company as the actually data source, since company is a realm object and it is
      // keep sync with the actually database update.
      self.titleLabel.text = company.companyName
      self.bodyLabel.text = company.latestArticleTitle
      self.newBadgeIndicator.alpha = company.hasNewArticlesToRead ? 1.0 : 0.0
    }
  }
}
