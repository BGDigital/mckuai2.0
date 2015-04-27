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


