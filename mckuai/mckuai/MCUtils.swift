//
//  MCUtils.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/25.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation

let tencentAppKey = "101155101"

//本地配置文件
//引导页
let ISFIRSTRUN = "isFirstRun"
//城市信息
//是否已上传城市信息
let D_ISUPADDR = "isUpCity"
//当前城市
let D_CURRENTCITY = "CurrentCity"

//用户信息
//用户ID
let D_USERID = "UserId"
//用户昵称
let D_NIKENAME = "NikeName"
//登录名-email
let D_LOGINNAME = "LoginName"
//登录密码
let D_LOGINPWD = "LoginPwd"
//是否记住登录信息(用户名,密码)
let D_ISREMEMBERME = "isRememberMe"

//mckuai网络接口
//主接口地址-域名
let URL_MC = "http://221.237.152.39:8081/interface.do?"

//PageInfo 用于下拉刷新
class PageInfo {
    var currentPage: Int = 0
    var pageCount: Int = 0
    var pageSize: Int = 0
    var allCount: Int = 0
    
    init(currentPage: Int, pageCount: Int, pageSize: Int, allCount: Int) {
        self.currentPage = currentPage
        self.pageCount = pageCount
        self.pageSize = pageSize
        self.allCount = allCount
    }
}


class MCUtils {

//一些通用的系统常量
static var TB: UITabBarController!
//这里存储一个首页的NavigationController,侧边菜单用
static var mainNav: UINavigationController?
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
        
//        let btnR = CGSize(width: 200, height: 30)
//        let btnX = (v.bounds.size.width - btnR.width) / 2
//        let btnY = v.bounds.size.height - 50
//        var lb_msg = UIButton(frame: CGRectMake(btnX, btnY, btnR.width, btnR.height))
//        lb_msg.setTitle("没有数据可用", forState: .Normal)
//        lb_msg.backgroundColor = UIColor.redColor()
//        //lb_msg.textAlignment = NSTextAlignment.Center
//        lb_msg.sizeToFit()
//        v.addSubview(lb_msg)
        
        var lb = UILabel(frame: v.bounds)
        lb.text = "获取数据失败\n请稍后刷新重试"
        lb.numberOfLines = 2;
        lb.textAlignment = .Center;
        lb.textColor = UIColor.lightGrayColor()
        v.addSubview(lb)
        
        tv.backgroundView = v
        tv.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    //供其它界面调用  --他人的空间
    class func openOtherZone(nav: UINavigationController?, userId: Int) {
        var otherZone: otherViewController = otherViewController(uId: userId)
        if let n = nav {
            n.pushViewController(otherZone, animated: true)
        } else {
            self.mainNav?.pushViewController(otherZone, animated: true)
        }
    }
    
    //--我的背包
    class func openBackPacker(nav: UINavigationController?, userId: Int) {
        var backpacker:backpackerViewController = backpackerViewController(uId: userId)
        if let n = nav {
            n.pushViewController(backpacker, animated: true)
        } else {
            self.mainNav?.pushViewController(backpacker, animated: true)
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

