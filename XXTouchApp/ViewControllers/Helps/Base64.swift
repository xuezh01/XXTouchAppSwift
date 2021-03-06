//
//  Base64.swift
//  XXTouchApp
//
//  Created by 教主 on 16/6/21.
//  Copyright © 2016年 mcy. All rights reserved.
//

import UIKit

class Base64 {
  class func base64StringToString(string: String) -> String? {
    let data = string.dataUsingEncoding(NSUTF8StringEncoding)
    guard let endata = data else { return nil }
    let base64Encoded = endata.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
    // 为了解决一行最多74个强制换行的问题，这边需要替换掉
    let base64 = base64Encoded.stringByReplacingOccurrencesOfString("\r", withString: "")
    return base64.stringByReplacingOccurrencesOfString("\n", withString: "")
  }
  
  ///传入base64的字符串，可以是没有经过修改的转换成的以data开头的，也可以是base64的内容字符串，然后转换成UIImage
  class func base64StringToUIImage(base64String: String) -> UIImage? {
    var str = base64String
    
    // 1、判断用户传过来的base64的字符串是否是以data开口的，如果是以data开头的，那么就获取字符串中的base代码，然后在转换，如果不是以data开头的，那么就直接转换
    if str.hasPrefix("data:image") {
      guard let newBase64String = str.componentsSeparatedByString(",").last else {
        return nil
      }
      str = newBase64String
    }
    // 2、将处理好的base64String代码转换成NSData
    guard let imgNSData = NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions()) else {
      return nil
    }
    // 3、将NSData的图片，转换成UIImage
    guard let codeImage = UIImage(data: imgNSData) else {
      return nil
    }
    return codeImage
  }
  
  ///传入图片image回传对应的base64字符串,默认不带有data标识,
  class func imageToBase64String(image: UIImage, headerSign: Bool = false) -> String?{
    
    ///根据图片得到对应的二进制编码
    guard let imageData = UIImagePNGRepresentation(image) else {
      return nil
    }
    ///根据二进制编码得到对应的base64字符串
    var base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue:0))
    ///判断是否带有头部base64标识信息
    if headerSign {
      ///根据格式拼接数据头 添加header信息，扩展名信息
      base64String = "data:image/png;base64," + base64String
    }
    return base64String
  }
  
  ///传入图片image名称回传对应的base64字符串,默认不带有data标识,
  class func imageToBase64String(imageName: String, headerSign: Bool = false) -> String?{
    ///根据名称获取图片
    guard let image : UIImage = UIImage(named:imageName) else {
      return nil
    }
    return imageToBase64String(image,headerSign:headerSign)
  }
}
