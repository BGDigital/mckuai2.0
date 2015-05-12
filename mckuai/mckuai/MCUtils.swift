//
//  MCUtils.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/25.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation

func IS_IOS7() ->Bool
    { return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 7.0 }
func IS_IOS8() -> Bool
    { return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0 }

let tencentAppKey = "101155101"

//本地配置文件
//引导页
let ISFIRSTRUN = "isFirstRun"
//用户信息
//用户ID
let D_USER_ID = "appUserIdSave"
//用户昵称
let D_USER_NICKNAME = "NickName"
//用户等级
let D_USER_LEVEL = "UserLevel"
//用户头像
let D_USER_ARATAR = "UserAvatar"
//用户定位
let D_USER_ADDR = "UserAddress"
//RongCloud_ID
let D_USER_RC_ID = "UserRongCloud_ID"
//RondCloud_Token
let D_USER_RC_TOKEN = "UserRongCloud_Token"

//登录名-email
let D_USER_LOGINNAME = "LoginName"
//登录密码
let D_USER_LOGINPWD = "LoginPwd"
//是否记住登录信息(用户名,密码)
let D_USER_ISREMEMBERME = "isRememberMe"
//用户进度
let D_USER_PROCESS = "UserProcess"



//mckuai网络接口
//主接口地址-域名
let URL_MC = "http://221.237.152.39:8081/interface.do?"
//app store页面
let URL_APPSTORE = "itms-apps://itunes.apple.com/cn/app/mai-kuaifor-wo-de-shi-jie/id955748107?mt=8"
//保存的用户ID
var appUserIdSave: Int = 0
var appUserLevel: Int = 0
var appUserNickName: String = ""
var appUserPic: String = ""
var appUserAddr: String = ""
var appUserRCID: String = ""
var appUserRCToken: String = ""
var appUserProcess :Float = 0.0


//默认用户头像
var DefaultUserAvatar_big = UIImage(named: "Avatar")
var DefaultUserAvatar_small = UIImage(named: "SmallAvatar")
var Load_Empty = UIImage(named: "load_empty")
var Load_Error = UIImage(named: "load_error")
var Loading = UIImage(named: "loading")


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
    //侧滑菜单栏
    static var leftView: UIViewController!
    //主界面的HeadView
    static var mainHeadView: UIViewController!
    //这里存储一个首页的NavigationController,侧边菜单用
    static var mainNav: UINavigationController?
    //RondCloud
    static let RC_token = "ZIGaV25p4j0yEaTJoHFrHxuBCTxypfvhAwu2X8sXMLwKxdzFrTlE+6UsVCte1Y3bvCaTfXlThBl26u7eHxoTrA=="
        
    static let COLOR_NavBG = "#43D152"
    static let COLOR_MAIN = "#4C4D4E"
    static let COLOR_SUB = "#B3B4B5"
    static let COLOR_GREEN = "#40C84D"
        
    static let TEXT_LOADING = "正在加载"
    static let TEXT_SEARCH = "搜索中..."

    static let URL_LAUNCH = "http://cdn.mckuai.com/app_start.png"
    
    
    
    class func AnalysisUserInfo(j: JSON) {
        var userId = j["id"].intValue
        var userAddr = j["addr"].stringValue
        var Avatar = j["headImg"].stringValue
        var nickName = j["nickName"].stringValue
        var userLevel = j["level"].intValue
        var RC_token = j["token", "token"].stringValue
        var RC_ID = j["userName"].stringValue
        var process = j["process"].floatValue
        
        //保存登录信息
        Defaults[D_USER_ID] = userId
        Defaults[D_USER_LEVEL] = userLevel
        Defaults[D_USER_NICKNAME] = nickName
        Defaults[D_USER_ARATAR] = Avatar
        Defaults[D_USER_ADDR] = userAddr
        Defaults[D_USER_RC_ID] = RC_ID
        Defaults[D_USER_RC_TOKEN] = RC_token
        Defaults[D_USER_PROCESS] = process
        
        appUserIdSave = userId
        appUserNickName = nickName
        appUserPic = Avatar
        appUserAddr = userAddr
        appUserLevel = userLevel
        appUserRCID = RC_ID
        appUserRCToken = RC_token
        appUserProcess = process
    }

    class func setNavBack() {
        //
        var navigationBar = UINavigationBar.appearance()
        //返回按钮的箭头颜色
        navigationBar.tintColor = UIColor.whiteColor()
        //设置标题颜色 白色
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        //设置返回按钮的样式
        var img = UIImage(named: "nav_back")
        img?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        navigationBar.backIndicatorImage = img
        navigationBar.backIndicatorTransitionMaskImage = img
        var backItem = UIBarButtonItem.appearance()
        var offset = UIOffset(horizontal: -500, vertical: -500)
        backItem.setBackButtonTitlePositionAdjustment(offset, forBarMetrics: .Default)
    }
    
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
    class func showEmptyView(tv: UITableView, aImg: UIImage, aText: String) {
        var v = UIView(frame: tv.frame)
        var img = UIImageView(image: aImg)
        let btnX = (v.bounds.size.width - img.bounds.size.width) / 2
        var btnY: CGFloat!
        if let headHeight = tv.tableHeaderView?.bounds.size.height {
            if tv.tableHeaderView?.hidden == false {
                btnY = (v.bounds.size.height + headHeight - img.bounds.size.height+30) / 2
            } else {
                btnY = (v.bounds.size.height - img.bounds.size.height+30) / 2
            }
        } else {
            btnY = (v.bounds.size.height - img.bounds.size.height+30) / 2
        }
        img.frame = CGRectMake(btnX, btnY, img.bounds.size.width, img.bounds.size.height)
        v.addSubview(img)
        
        var lb = UILabel(frame: CGRectMake(0, btnY+img.frame.size.height+10, v.bounds.size.width, 20))
        lb.text = aText
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
    
    /**
    显示搜索页
    
    :param: ctl 主界面的NavigationController
    */
    class func showSearchView(ctl:UINavigationController?){
        var searchView = UIStoryboard(name: "search", bundle: nil).instantiateViewControllerWithIdentifier("SearchViewController") as! SearchViewController
        var nav = UINavigationController(rootViewController: searchView)
        MCUtils.leftView.presentViewController(nav, animated: true, completion: nil)
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

