//
//  ScriptDetailViewController.swift
//  OneFuncApp
//
//  Created by mcy on 16/5/31.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class ScriptDetailViewController: UIViewController {
  private let fileName: String
  private let fileText: String
  private let textView = XXTextView(frame: CGRectZero)
  private var oldText = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    makeConstriants()
    bind()
  }
  
  init(fileName: String, fileText: String) {
    self.fileName = fileName
    self.fileText = fileText
    self.oldText = fileText
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    view.backgroundColor = UIColor.whiteColor()
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationItem.title = self.fileName
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .Plain, target: self, action: #selector(saveScript))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: #selector(back))
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    
    //    textView.tokens = tokens() as [AnyObject]
    
    view.addSubview(textView)
  }
  
  //  private func tokens() -> NSArray {
  //    let array = [
  //      CYRToken.init(name: "one", expression: "for", attributes: [NSForegroundColorAttributeName: UIColor(rgb:0x9900ff)])
  //      
  //      
  //    ]
  //    return array
  //  }
  
  private func makeConstriants() {
    textView.snp_makeConstraints { (make) in
      make.edges.equalTo(view)
    }
  }
  
  private func bind() {
    textView.text = self.fileText
  }
  
  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  private func fetchWriteScript() {
    if !KVNProgress.isVisible() {
      KVNProgress.showWithStatus("正在保存")
    }
    Service.writeScriptFile(filename: self.fileName, data: self.textView.text) { [weak self] (data, _, error) in
      guard let `self` = self else { return }
      if let data = data where JSON(data: data) != nil {
        let json = JSON(data: data)
        switch json["code"].intValue {
        case 0:
          KVNProgress.showSuccessWithStatus(Constants.Text.saveSuccessful, completion: {
            self.navigationController?.popViewControllerAnimated(true)
          })
        default:
          JCAlertView.showOneButtonWithTitle(Constants.Text.prompt, message: json["message"].stringValue, buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.ok, click: nil)
          KVNProgress.dismiss()
          return
        }
      }
      if error != nil {
        KVNProgress.updateStatus(Constants.Error.failure)
        MixC.sharedManager.restart { (_) in
          self.fetchWriteScript()
        }
      }
    }
  }
  
  @objc private func saveScript() {
    fetchWriteScript()
  }
  
  @objc private func back() {
    guard self.oldText != self.textView.text else {
      self.navigationController?.popViewControllerAnimated(true)
      return
    }
    JCAlertView.showTwoButtonsWithTitle(Constants.Text.prompt, message: "是否丢弃当前更改？", buttonType: JCAlertViewButtonType.Default, buttonTitle: Constants.Text.yes, click: {
      self.navigationController?.popViewControllerAnimated(true)
      }, buttonType: JCAlertViewButtonType.Cancel, buttonTitle: Constants.Text.no, click: nil)
  }
  
  @objc private func keyboardWillShow(notification: NSNotification) {
    // 获取键盘信息
    let userinfo: NSDictionary = notification.userInfo!
    let nsValue = userinfo.objectForKey(UIKeyboardFrameEndUserInfoKey)
    let keyboardRec = nsValue?.CGRectValue()
    let height = keyboardRec!.size.height
    UIView.animateWithDuration(0.5, animations: {
      self.textView.contentInset.top = height+Constants.Size.axtNavigationBarHeight
      self.textView.scrollIndicatorInsets.top = self.textView.contentInset.top
      self.view.frame.origin.y = -height
      }, completion: nil)
  }
}

extension ScriptDetailViewController: UIGestureRecognizerDelegate {
}
