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

  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    titleLabel = UILabel()
    bodyLabel = UILabel()
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
  }

  private func buildConstraints() {
    titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: self.bodyLabel.topAnchor, constant: -12 ).isActive = true
    bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12).isActive = true
    bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -12).isActive = true
  }
}

extension CompanyCell: StaticCellType {
  public func configure(row: Row) {
    self.titleLabel.text = row.title
    self.bodyLabel.text = row.description
  }
}
