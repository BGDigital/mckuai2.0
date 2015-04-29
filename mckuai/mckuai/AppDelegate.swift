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
    
    private func IS_IOS7() ->Bool
    { return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 7.0 }
    private func IS_IOS8() -> Bool
    { return (UIDevice.currentDevice().systemVersion as NSString).doubleValue >= 8.0 }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window?.makeKeyAndVisible()
        //启动页面加载广告
        loadLaunchView()
        //RongCloud
        initRongCloud()
        return true
    }
    
    //加载Rongcloud
    func initRongCloud() {
        RCIM.initWithAppKey("k51hidwq1fb4b", deviceToken: nil)
        
        //设置用户信息
        RCIM.setUserInfoFetcherWithDelegate(self, isCacheUserInfo: false)
        //设置好友信息
        RCIM.setFriendsFetcherWithDelegate(self)
        //设置群组信息
        //RCIM.setGroupInfoFetcherWithDelegate(self)
        
        //注册苹果推送
        if IS_IOS8() {
            var settings = UIUserNotificationSettings(forTypes: .Badge | .Sound | .Alert, categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        } else {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(.Badge | .Alert | .Sound)
        }
    }
    
    func loadLaunchView() {
        self.window?.makeKeyAndVisible()
        launchView = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: nil, options: nil)[0] as! UIView
        launchView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.window?.addSubview(launchView)
        
        var imageV = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-100))
        
        // 加载网络图片
        imageV.sd_setImageWithURL(NSURL(string: MCUtils.URL_LAUNCH), placeholderImage: nil)
        
        launchView.addSubview(imageV)
        self.window?.bringSubviewToFront(launchView)
        //显示3秒杀
        Async.main(after: 1, block: {self.removeLaunchView()})
        //NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "removeLaunchView", userInfo: nil, repeats: false)
    }
    
    func removeLaunchView() {
        launchView.removeFromSuperview()
    }
    
    //注册推送通知
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if IS_IOS8() {application.registerForRemoteNotifications()}
    }
    //
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        if IS_IOS8() {
            if (identifier == "declineAction") {}
            else if (identifier == "answerAction") {}
        }
    }
    
    //获取苹果推送权限成功
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        println("didRegisterForRemoteNotificationsWithDeviceToken:\(deviceToken)")
        RCIM.sharedRCIM().setDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        //var alert:UIAlertView = UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        //alert.show()
        println(error.localizedDescription)
    }
    
    //获取好友列表方法
    func getFriends() -> [AnyObject]! {
        var arr = NSMutableArray()
        var user1 = RCUserInfo()
        user1.userId = "kyly"
        user1.name = "麻哥"
        user1.portraitUri = ""
        arr.addObject(user1)
        
        return arr as [AnyObject]
    }
    
    //获取用户信息方法
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!) {
        if userId == "kyly" {
            var u = RCUserInfo()
            u.userId = "kyly"
            u.name = "麻哥"
            u.portraitUri = ""
            
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


}

