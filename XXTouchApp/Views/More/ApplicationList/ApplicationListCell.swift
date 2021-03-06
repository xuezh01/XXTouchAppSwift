//
//  ApplicationListCell.swift
//  XXTouchApp
//
//  Created by mcy on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ApplicationListCell: UITableViewCell {
  private let packageNameLabel = UILabel()
  private let iconImageView = UIImageView()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.accessoryType = .DisclosureIndicator
    packageNameLabel.textAlignment = .Center
    packageNameLabel.textColor = UIColor(rgb: 0x3d85c6)
    packageNameLabel.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 21))
    
    contentView.addSubview(iconImageView)
    contentView.addSubview(packageNameLabel)
  }
  
  private func makeConstriants() {
    iconImageView.snp_makeConstraints { (make) in
      make.leading.equalTo(contentView).offset(Sizer.valueForDevice(phone: 20, pad: 25))
      make.centerY.equalTo(contentView)
      make.width.height.equalTo(Sizer.valueForDevice(phone: 36, pad: 54))
    }
    
    packageNameLabel.snp_makeConstraints { (make) in
      make.centerY.equalTo(contentView)
      make.leading.equalTo(iconImageView.snp_trailing).offset(Sizer.valueForDevice(phone: 15, pad: 20))
    }
  }
  
  func bind(model: ApplicationListModel) {
    iconImageView.image = Base64.base64StringToUIImage(model.iconBase64)
    packageNameLabel.text = model.name
  }
}
