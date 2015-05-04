//
//  MCUtils.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/25.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation

//本地配置文件
//城市信息
//是否已上传城市信息
let ISUPADDR = "isUpCity"
//当前城市
let CURRENTCITY = "CurrentCity"

//用户信息
//用户ID
let USERID = "UserId"
//用户昵称
let NIKENAME = "NikeName"
//登录名-email
let LOGINNAME = "LoginName"
//登录密码
let LOGINPWD = "LoginPwd"
//是否记住登录信息(用户名,密码)
let ISREMEMBERME = "isRememberMe"

//mckuai网络接口
//主接口地址-域名
let URL_MC = "http://221.237.152.39:8081/interface.do?"
//首页接口
let URL_INDEX = "http://221.237.152.39:8081/interface.do?act=indexRec&id=6"
//背包-贴子收藏
let URL_BAG_COLLECTTALK = "http://221.237.152.39:8081/interface.do?act=collectTalk&id=1&page=1"
//背景-麦友
let URL_BAG_ATTEUSER = "http://221.237.152.39:8081/interface.do?act=attentionUser&id=1&page=1"

class MCUtils {

//一些通用的系统常量
static var TB: UITabBarController!
//static var chatView: UIViewController!
//Tencent APP_Key
static let tencentAppKey = "101155101"
//RondCloud
static let RC_token = "dxcm0lr7Egt+GZp6DerjqOeLBPbf3gS4wMl0dLcWBkT2IBDBKobyAFDYl2T1/6H0d1ljiW3e/f4="
    
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
    
    //截取小数点后的数
    class func getStr(str: Double) -> String {
        let d = "\(str)"
        var result = ""
        for character in d {
            if (character == ".") {
                break
            } else {
                result = result+"\(character)"
            }
        }
        if result.toInt() == 0 {
            return "1"
        } else {
            return result
        }
    }
    
    //计算时间差
    class func compDate(beginStr: String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = NSLocale(localeIdentifier: NSGregorianCalendar)
        let date = formatter.dateFromString(beginStr)
        if date == nil {
            return "时间格式出错"
        }
        var second:NSTimeInterval
        second = -date!.timeIntervalSinceNow
        if second < 60 {
            return "刚刚"
        } else if (second/60) < 60 {
            var tmp = second/60
            var s = getStr(tmp)
            return "\(s)分钟前"
        } else if (second/60/60) < 24 {
            var tmp = second/60/60
            var s = getStr(tmp)
            return "\(s)小时前"
        } else if (second/60/60/24) < 30 {
            var tmp = second/60/60/24
            var s = getStr(tmp)
            return "\(s)天前"
        } else if (second/60/60/24/30) < 12 {
            var tmp = second/60/60/24/30
            var s = getStr(tmp)
            return "\(s)月前"
        } else {
            var tmp = second/60/60/24/30/12
            var s = getStr(tmp)
            return "\(s)年前"
        }
    }
    
    /**
    获取用户头像,并缩小
    
    :param: url 用户头像URL
    
    :returns: 返回缩小后的用户头像Image
    */
    class func getHeadImg(url: String, rect: CGRect) -> UIImage {
        var iv = UIImageView(frame: rect)
        iv.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "Guide"))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        iv.image?.drawInRect(rect)
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func showEmptyView(tv: UITableView) {
        var v = UIView(frame: tv.frame)
        
        var lb_msg = UILabel(frame: CGRectMake(0, tv.bounds.size.height-40, tv.bounds.size.width, 20))
        lb_msg.text = "没有数据可用"
        lb_msg.textAlignment = NSTextAlignment.Center
        lb_msg.sizeToFit()
        v.addSubview(lb_msg)
        
        tv.backgroundView = v
        tv.separatorStyle = UITableViewCellSeparatorStyle.None
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


