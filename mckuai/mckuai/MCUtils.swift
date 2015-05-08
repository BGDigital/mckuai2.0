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
let D_USER_ID = "appUserIdSave"
//用户昵称
let D_USER_NICKNAME = "NickName"
//用户等级
let D_USER_LEVEL = "UserLevel"
//用户头像
let D_USER_ARATAR = "UserAvatar"
//登录名-email
let D_USER_LOGINNAME = "LoginName"
//登录密码
let D_USER_LOGINPWD = "LoginPwd"
//是否记住登录信息(用户名,密码)
let D_USER_ISREMEMBERME = "isRememberMe"

//mckuai网络接口
//主接口地址-域名
let URL_MC = "http://221.237.152.39:8081/interface.do?"
//保存的用户ID
var appUserIdSave: Int = 0
var appUserLevel: Int = 0
var appUserNickName: String = ""
var appUserPic: String = ""
var appUserAddr: String = ""

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
    
static let TEXT_LOADING = "正在加载"

static let URL_LAUNCH = "http://f.hiphotos.baidu.com/image/pic/item/e1fe9925bc315c60191d32308fb1cb1348547760.jpg"
    
    /**
    检查网络状态
    */
    class func checkNetWorkState() {
        //网络状态
        AFNetworkReachabilityManager.sharedManager().startMonitoring()
        AFNetworkReachabilityManager.sharedManager().setReachabilityStatusChangeBlock({st in
            switch st {
            case .ReachableViaWiFi:
                println("网络状态:WIFI")
            case .ReachableViaWWAN:
                println("网络状态:3G")
            case .NotReachable:
                println("网络状态:不可用")
            default:
                println("网络状态:火星")
            }
        })
        AFNetworkReachabilityManager.sharedManager().stopMonitoring()

    }
    /**
    显示HUD提示框
    
    :param: view    要显示HUD的窗口
    :param: title   HUD的标题
    :param: imgName 自定义HUD显示的图片
    */
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
    
    /**
    判断时间要用的函数
    
    :param: str 传如的字符串
    
    :returns: 处理过的字符串
    */
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
    
    /**
    计算当前时间与传入时间的时间差,并返回时间差
    
    :param: beginStr 从服务器上获取到的时间
    
    :returns: 处理过的时间差字符串
    */
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
    UITableView 空数据时显示的类型
    
    :param: tv 要显示内容的TableView
    errorType: 1,空数据时; 2,加载失败
    */
    class func showEmptyView(tv: UITableView, errorType: Int) {
        var v = UIView(frame: tv.frame)
        var imgName: String!
        var text: String!
        if errorType == 1 {
            imgName = "load_empty"
            text = "还没有数据哦"
        } else {
            imgName = "load_error"
            text = "获取数据失败,请稍后刷新重试"
        }
        var img = UIImageView(image: UIImage(named: imgName))
        let btnX = (v.bounds.size.width - img.bounds.size.width) / 2
        let btnY = (v.bounds.size.height - img.bounds.size.height-30) / 2
        img.frame = CGRectMake(btnX, btnY, img.bounds.size.width, img.bounds.size.height)
        v.addSubview(img)
        
        var lb = UILabel(frame: CGRectMake(0, btnY+img.frame.size.height+10, v.bounds.size.width, 20))
        lb.text = text
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
        otherZone.hidesBottomBarWhenPushed = true
        if let n = nav {
            n.pushViewController(otherZone, animated: true)
        } else {
            self.mainNav?.pushViewController(otherZone, animated: true)
        }
    }
    
    //--我的背包
    class func openBackPacker(nav: UINavigationController?, userId: Int) {
        var backpacker:backpackerViewController = backpackerViewController(uId: userId)
        backpacker.hidesBottomBarWhenPushed = true
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

