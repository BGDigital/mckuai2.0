//
//  AppDelegate.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/14.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchView: UIView!
    let launchUrl = "http://f.hiphotos.baidu.com/image/pic/item/e1fe9925bc315c60191d32308fb1cb1348547760.jpg"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //启动页面加载广告
        loadLaunchView()
        
        return true
    }
    
    func loadLaunchView() {
        self.window?.makeKeyAndVisible()
        launchView = NSBundle.mainBundle().loadNibNamed("LaunchScreen", owner: nil, options: nil)[0] as! UIView
        launchView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        self.window?.addSubview(launchView)
        
        var imageV = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height-100))
        
        // 加载网络图片
        imageV.sd_setImageWithURL(NSURL(string: launchUrl), placeholderImage: nil)
        
        launchView.addSubview(imageV)
        self.window?.bringSubviewToFront(launchView)
        //显示3秒杀
        Async.main(after: 3, block: {self.removeLaunchView()})
        //NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "removeLaunchView", userInfo: nil, repeats: false)
    }
    
    func removeLaunchView() {
        launchView.removeFromSuperview()
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

