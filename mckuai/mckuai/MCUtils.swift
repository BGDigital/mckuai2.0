//
//  MCUtils.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/25.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation

class MCUtils {

//一些通用的系统常量
static var TB: UITabBarController!
//static var chatView: UIViewController!
//Tencent APP_Key
static let tencentAppKey = "101155101"
    
static let COLOR_NavBG = "#43D152"
static let COLOR_MAIN = "#4C4D4E"
static let COLOR_SUB = "#B3B4B5"
static let COLOR_GREEN = "#40C84D"

static let URL_LAUNCH = "http://f.hiphotos.baidu.com/image/pic/item/e1fe9925bc315c60191d32308fb1cb1348547760.jpg"

//功能函数
class func showCustomHUD(view: UIView, title: String, imgName: String) {
    var h = MBProgressHUD.showHUDAddedTo(view, animated: true)
    h.labelText = title
    h.mode = MBProgressHUDMode.CustomView
    h.customView = UIImageView(image: UIImage(named: imgName))
    h.showAnimated(true, whileExecutingBlock: { () -> Void in
        sleep(2)
        return
        }) { () -> Void in
            h.removeFromSuperview()
            h = nil
    }
}
}

/**
*  UIColor 扩展
*/
extension UIColor {
    
    //主题色
    class func applicationMainColor() -> UIColor {
        return UIColor(hexString: "#4C4D4E")!
    }
    
    //第二主题色
    class func applicationSecondColor() -> UIColor {
        return UIColor(hexString: "#B3B4B5")!
    }
    
    //警告颜色
    class func applicationWarningColor() -> UIColor {
        return UIColor(red: 0.1, green: 1, blue: 0, alpha: 1)
    }
    
    //链接颜色
    class func applicationLinkColor() -> UIColor {
        return UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha:1)
    }
}
/**
*  UIImage 扩展
*/
extension UIImage {
    //通过颜色创建图片
    class func applicationCreateImageWithColor(color: UIColor) -> UIImage {
        var rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        var context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        var theImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return theImage
    }
    
}



