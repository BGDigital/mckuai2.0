//
//  AppDelegate.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/14.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RCIMFriendsFetcherDelegate, RCIMUserInfoFetcherDelegagte {

    var window: UIWindow?
    var launchView: UIView!
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window?.makeKeyAndVisible()
        //启动页面加载广告
        loadLaunchView()
        //RongCloud
        initRongCloud()
        //RongCloud登录
        RCIM.connectWithToken(MCUtils.RC_token,
            completion: {userId in
                println("Login Successrull:\(userId)")
            },
            error: {status in
                println("Login Faild. \(status)")
        })
        
        //UMeng反馈
        UMFeedback.setAppkey(UMAppKey)
        //UM推送
        UMessage.startWithAppkey(UMAppKey, launchOptions: launchOptions)
        initNotificationPush()
        //友盟分享
        UMSocialData.setAppKey(UMAppKey)
        UMSocialQQHandler.setQQWithAppId(qq_AppId, appKey: qq_AppKey, url: share_url)
        UMSocialWechatHandler.setWXAppId(wx_AppId, appSecret: wx_AppKey, url: share_url)
        
        // 友盟统计 nil为空时 默认appstore渠道 不同渠道 统计数据都算到第一个安装渠道
        MobClick.startWithAppkey(UMAppKey, reportPolicy: BATCH, channelId: nil)
        //版本号
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        let majorVersion: AnyObject? = infoDictionary!["CFBundleShortVersionString"]
        let appversion = majorVersion as! String
        MobClick.setAppVersion(appversion)
        
        MCUtils.setNavBack()
        return true
    }
    func initNotificationPush() {
        //注册苹果推送
        if IS_IOS8() {
//            //register remoteNotification types
//            var action1 = UIMutableUserNotificationAction()
//            action1.identifier = "action1_identifier"
//            action1.title = "Accept"
//            action1.activationMode = .Foreground //当点击时启动程序
//            
//            var action2 = UIMutableUserNotificationAction()
//            action2.identifier = "action2_identifier"
//            action2.title = "Reject"
//            action2.activationMode = .Background  //当点击的时候不启动程序,在后台处理
//            action2.authenticationRequired = true //需要解锁才能处理,如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
//            action2.destructive = true
//            
//            var categorys = UIMutableUserNotificationCategory()
//            categorys.identifier = "categorys1"  //这一组动作的唯一标识
//            categorys.setActions([action1, action2], forContext: .Default)
            
            var settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert , categories: nil)
            UMessage.registerRemoteNotificationAndUserNotificationSettings(settings)
        } else {
            UMessage.registerForRemoteNotificationTypes(.Badge | .Alert | .Sound)
        }
        //调试日志
        UMessage.setLogEnabled(true)
        //自动清空角标
        UMessage.setBadgeClear(true)
        //当前APP渠道
        UMessage.setChannel("App Store")
    }
    //加载Rongcloud
    func initRongCloud() {
        RCIM.initWithAppKey("k51hidwq1fb4b", deviceToken: nil)
        
        //设置用户信息
        RCIM.setUserInfoFetcherWithDelegate(self, isCacheUserInfo: false)
        //设置好友信息
        RCIM.setFriendsFetcherWithDelegate(self)
    }

    // 收到本地通知
    func application(application: UIApplication , didReceiveLocalNotification notification: UILocalNotification ) {
        var alertView = UIAlertView (title: " 系统本地通知 " , message: notification.alertBody , delegate: nil , cancelButtonTitle: " 返回 " )
        alertView.show ()
    }
    
    //处理收到的远程推送消息
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        println(userInfo)
        if IS_IOS8() {
            if (identifier == "declineAction") {}
            else if (identifier == "answerAction") {}
        }
    }
    
    //获取苹果推送权限成功
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("didRegisterForRemoteNotificationsWithDeviceToken:\(deviceToken)")
        RCIM.sharedRCIM().setDeviceToken(deviceToken)
        
//        UMeng
        UMessage.registerDeviceToken(deviceToken)
//        UMessage.addAlias(UMFeedback.uuid(), type: UMFeedback.messageType()) { (responseObject, error) -> Void in
//            if error != nil {
//                println("E:\(error)")
//            } else {
//                println("OK:\(responseObject)")
//            }
//        }
    }

    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("didReceiveRemoteNotification:\(userInfo)")
        UMessage.didReceiveRemoteNotification(userInfo)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //var alert:UIAlertView = UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        //alert.show()
        println(error.localizedDescription)
    }
    
    func loadLaunchView() {
        launchView = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: nil, options: nil)[0] as! UIView
        launchView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.window?.addSubview(launchView)
        
        var imageV = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        launchView.addSubview(imageV)
        // 加载网络图片
        imageV.sd_setImageWithURL(NSURL(string: MCUtils.URL_LAUNCH), placeholderImage: UIImage(named: "Default_LaunchImg"))
        
        self.window?.bringSubviewToFront(launchView)
        //显示3秒杀
        Async.main(after: 3, block: {self.removeLaunchView()})
        //NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "removeLaunchView", userInfo: nil, repeats: false)
    }
    
    func removeLaunchView() {
        launchView.removeFromSuperview()
    }
    
    //获取好友列表方法
    func getFriends() -> [AnyObject]! {
        var arr = NSMutableArray()
        var user1 = RCUserInfo()
        user1.userId = "859F416027050C8AE33367423A986ED1"
        user1.name = "麻哥"
        user1.portraitUri = ""
        arr.addObject(user1)
        
        var user2 = RCUserInfo(userId: "2", name: "陈强", portrait: "这个是啥")
        arr.addObject(user2)
        
        var user3 = RCUserInfo(userId: "6", name: "邱兴福", portrait: "这个是啥")
        arr.addObject(user3)
        
        
        
        return arr as [AnyObject]
    }
    
    //获取用户信息方法
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        if userId == "859F416027050C8AE33367423A986ED1" {
            var u = RCUserInfo()
            u.userId = "859F416027050C8AE33367423A986ED1"
            u.name = "麻哥"
            u.portraitUri = "https://wt-avatars.oss.aliyuncs.com/40/91e8fae8-3d2a-43e5-b056-298d77879361.jpg"
            
            return completion(u)
        }
        
        
        return completion(nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var result:Bool = UMSocialSnsService.handleOpenURL(url);
        if (result == false) {
            //调用其他SDK，例如新浪微博SDK等
            result =  TencentOAuth.HandleOpenURL(url)
            
        }
        return result
        
    }
    
    func application(application:UIApplication,handleOpenURL url:NSURL) -> Bool {
        var result:Bool = UMSocialSnsService.handleOpenURL(url);
        if (result == false) {
            //调用其他SDK，例如新浪微博SDK等
            result =  TencentOAuth.HandleOpenURL(url)
            
        }
        return result
    }


}

