//
//  RenameView.swift
//  OneFuncApp
//
//  Created by mcy on 16/6/16.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class RenameView: UIView {
  let newNameTextField = BaseTextField()
  let submitButton = UIButton(type: .Custom)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    makeConstriants()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    self.backgroundColor = ThemeManager.Theme.lightGrayBackgroundColor
    
    newNameTextField.placeholder = "请输入文件名"
    newNameTextField.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 19))
    newNameTextField.showsBorderWhileEditing = true
    
    submitButton.setTitle("提交", forState: .Normal)
    submitButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    submitButton.backgroundColor = ThemeManager.Theme.tintColor
    submitButton.layer.cornerRadius = 5
    submitButton.enabled = false
    submitButton.backgroundColor = ThemeManager.Theme.lightTextColor
    submitButton.titleLabel?.font = UIFont.systemFontOfSize(Sizer.valueForDevice(phone: 17, pad: 19))
    
    self.addSubview(newNameTextField)
    self.addSubview(submitButton)
  }
  
  private func makeConstriants() {
    newNameTextField.snp_makeConstraints { (make) in
      make.top.leading.equalTo(self).inset(10)
      make.trailing.equalTo(submitButton.snp_leading).offset(-10)
      make.height.equalTo(Sizer.valueForDevice(phone: 40, pad: 45))
    }
    
    submitButton.snp_makeConstraints { (make) in
      make.top.equalTo(newNameTextField)
      make.trailing.equalTo(self).offset(-10)
      make.width.equalTo(Sizer.valueForDevice(phone: 70, pad: 75))
      make.height.equalTo(Sizer.valueForDevice(phone: 40, pad: 45))
    }
  }
  
}
