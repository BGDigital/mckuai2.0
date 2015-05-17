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
        Async.main({
            println("多线程调用三方库.")
            //RongCloud登录
            if !appUserRCToken.isEmpty {
                //RongCloud
                self.initRongCloud()
                
                RCIM.connectWithToken(appUserRCToken,
                    completion: {userId in
//                        println("RongCloud Login Successrull:\(userId)")
                        //显示rongcloud未读消息
                        MCUtils.RCTabBarItem.badgeValue = RCIM.sharedRCIM().totalUnreadCount > 0 ? "\(RCIM.sharedRCIM().totalUnreadCount)" : nil
                    },
                    error: {status in
                        println("RongCloud Login Faild. \(status)")
                })
            }
            //获取好友列表
            MCUtils.GetFriendsList()
            //UMeng反馈
            UMFeedback.setAppkey(UMAppKey)
            UMFeedback.setLogEnabled(false)
            UMFeedback.sharedInstance().setFeedbackViewController(UMFeedback.feedbackViewController(), shouldPush: true)
                
            //UM推送
            UMessage.startWithAppkey(UMAppKey, launchOptions: launchOptions)
            self.initNotificationPush()
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
            })
        
//        application.setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        MCUtils.setNavBack()
        return true
    }
    
    //加载Rongcloud
    func initRongCloud() {
        RCIM.initWithAppKey(RC_AppKey, deviceToken: nil)
        
        //设置用户信息
        RCIM.setUserInfoFetcherWithDelegate(self, isCacheUserInfo: true)
        //设置好友信息
        RCIM.setFriendsFetcherWithDelegate(self)
    }

    
    func initNotificationPush() {
        //注册苹果推送
        if IS_IOS8() {
            //register remoteNotification types
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
//            let categroies: NSSet = NSSet(object: categorys)
//            
            var settings = UIUserNotificationSettings(forTypes: UIUserNotificationType.Badge | UIUserNotificationType.Sound | UIUserNotificationType.Alert , categories: nil)
            UMessage.registerRemoteNotificationAndUserNotificationSettings(settings)
        } else {
            UMessage.registerForRemoteNotificationTypes(.Badge | .Alert | .Sound)
        }
        //调试日志
        UMessage.setLogEnabled(false)
        //当前APP渠道
        UMessage.setChannel("App Store")
    }

    // 收到本地通知
    func application(application: UIApplication , didReceiveLocalNotification notification: UILocalNotification ) {
//        MCUtils.RCTabBarItem.badgeValue = "\(RCIM.sharedRCIM().totalUnreadCount)"
    }
    
    //收到远程通知
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        UMessage.didReceiveRemoteNotification(userInfo)
        UMFeedback.didReceiveRemoteNotification(userInfo)
    }
    
    //处理收到的远程推送消息
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if IS_IOS8() {
            if (identifier == "declineAction") {
//                println("declineAction")
            }
            else if (identifier == "answerAction") {
//                println("answerAction")
            }
        }
    }
    
    //获取苹果推送权限成功
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        RCIM.sharedRCIM().setDeviceToken(deviceToken)
//        UMeng
        UMessage.registerDeviceToken(deviceToken)
        //反馈推送
        UMessage.addAlias(UMFeedback.uuid(), type: UMFeedback.messageType()) { (responseObject, error) -> Void in
            if error != nil {
//                println("addAlias Error:\(error)")
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //var alert:UIAlertView = UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        //alert.show()
//        println(error.localizedDescription)
    }
    
    func loadLaunchView() {
        launchView = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: nil, options: nil)[0] as! UIView
        launchView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.window?.addSubview(launchView)
        
        var imageV = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        launchView.addSubview(imageV)
        // 加载网络图片
        imageV.sd_setImageWithURL(NSURL(string: MCUtils.URL_LAUNCH), placeholderImage: UIImage(named: "appLaunchImg"))
        
        self.window?.bringSubviewToFront(launchView)
        //显示3秒杀
        Async.main(after: 3, block: {self.removeLaunchView()})
    }
    
    func removeLaunchView() {
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.launchView.alpha = 0
        }) { _ in
            self.launchView.removeFromSuperview()
        }
    }
    
    //获取好友列表方法  --好友列表
    func getFriends() -> [AnyObject]! {
        //开始刷新
        return MCUtils.friendList as [AnyObject]
    }
    
    //获取用户信息方法 --会话聊天
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        var inList = false
        for u in MCUtils.friendList {
            var user = u as! RCUserInfo
            if user.userId == userId {
                inList = true
                return completion(user)
            }
        }
        
        if !inList {
            return completion(nil)
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        application.applicationIconBadgeNumber = RCIM.sharedRCIM().totalUnreadCount
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        //显示rongcloud未读消息
//        MCUtils.RCTabBarItem.badgeValue = RCIM.sharedRCIM().totalUnreadCount > 0 ? "\(RCIM.sharedRCIM().totalUnreadCount)" : nil
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

