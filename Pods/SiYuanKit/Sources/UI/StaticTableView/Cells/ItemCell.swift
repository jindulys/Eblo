//
//  ItemCell.swift
//  SiYuanKit
//
//  Created by yansong li on 2016-07-31.
//
//

import Foundation

#if os(iOS)

/// This cell is used to display a normal item, a title and a body.
public class ItemCell: UITableViewCell {
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
    self.contentView.addAutoLayoutSubView(titleLabel)
    
    bodyLabel.numberOfLines = 0
    self.contentView.addAutoLayoutSubView(bodyLabel)
  }
  
  private func buildConstraints() {
    titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
    titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: self.bodyLabel.topAnchor).isActive = true
    bodyLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
    bodyLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
    bodyLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
  }
}

extension ItemCell: StaticCellType {
  public func configure(row: Row) {
    self.titleLabel.text = row.title
    self.bodyLabel.text = row.description
  }
}

#endif
