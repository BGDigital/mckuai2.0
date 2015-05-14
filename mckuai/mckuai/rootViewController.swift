//
//  ViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/14.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

//系统版本
var osVersion:Double=8.0

class rootViewController: RESideMenu, RESideMenuDelegate, UITabBarControllerDelegate {

    var guideView: GuidePageController!
    
    override func awakeFromNib() {
        self.menuPreferredStatusBarStyle = UIStatusBarStyle.LightContent
        self.contentViewShadowColor = UIColor.blackColor()
        self.contentViewShadowOffset = CGSizeMake(0, 0);
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        //准备TabBar需要的ViewController
        var main = mainViewController.initializationMain()
        var second = liveViewController.initializationLive()
        var third = chatViewController.mainRoot()
        var four = communityViewController.mainRoot()
        
        MCUtils.RCTabBarItem = third.tabBarItem
        
        MCUtils.TB = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("contentViewController") as! UITabBarController
        MCUtils.TB.tabBar.tintColor = UIColor(red: 0.212, green: 0.804, blue: 0.380, alpha: 1.00)
        MCUtils.TB.viewControllers = [main, second, third, four]
        MCUtils.TB.hidesBottomBarWhenPushed = true
        MCUtils.TB.delegate = self
        
        self.contentViewController = MCUtils.TB
        self.leftMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("leftMenuViewController") as! UIViewController
        MCUtils.leftView = self.leftMenuViewController
        //这里不需要右边栏
        //self.rightMenuViewController = mainStoryboard.instantiateViewControllerWithIdentifier("leftMenuViewController") as! UIViewController
        //self.backgroundImage = UIImage(named: "Image")
        //模糊背景
        var bg = SABlurImageView()
        bg.image = UIImage(named: "sidemenu_bg")
        bg.addBlurEffect(8, times: 1)
        self.backgroundImage = bg.image!
        self.delegate = self;
    }
    
    //这里是为了获取当前TabBar里面的NavigationController
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if viewController.isKindOfClass(UINavigationController) {
            MCUtils.mainNav = viewController as? UINavigationController
            if tabBarController.selectedIndex == 2{
                MCUtils.RCTabBarItem.badgeValue = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Defaults.remove(ISFIRSTRUN)
        if !Defaults.hasKey(ISFIRSTRUN) {
            //没有"ISFIRSTRUN"这个key就是第一次启动,显示引导页
            loadWelcome()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadWelcome() {
        //引导页图片
        var mGuideImages:Array<NSString>=["guidepage1","guidepage2","guidepage3","guidepage4"]
        //结束按钮
        let btnWidth:CGFloat = 250.0
        let btnHeight:CGFloat = 50
        let btnX:CGFloat = (UIScreen.mainScreen().bounds.width - btnWidth)/2
        let btnY:CGFloat = UIScreen.mainScreen().bounds.height - btnHeight - 100
        var btnSubmit = UIButton(frame:CGRect(origin: CGPointMake(btnX, btnY), size:CGSizeMake(btnWidth,btnHeight)))
        btnSubmit.setTitle("立即体验", forState: UIControlState.Normal)
        btnSubmit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        btnSubmit.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Highlighted)
        btnSubmit.backgroundColor = UIColor(hexString: "#57C848")
        btnSubmit.layer.borderColor = UIColor.whiteColor().CGColor
        btnSubmit.layer.borderWidth = 1
        
        btnSubmit.addTarget(self, action: "onClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        guideView = GuidePageController(datas:mGuideImages,button:btnSubmit)
        self.view.addSubview(guideView.view)
    }
    
    func onClick(){
        UIView.animateWithDuration(0.5,
            animations : {
                self.guideView.view.alpha = 0
            },
            completion : {_ in
                Defaults[ISFIRSTRUN] = false
                if(self.guideView.firstPop){
                    self.guideView.view.removeFromSuperview()
                }else{
                    //这个暂时不用,只在第一次启动的时候显示引导页
                    self.guideView.dismissViewControllerAnimated(false, completion: nil)
                }
            }
        )
    }

    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        //println("willShowMenuViewController")
    }
    
    func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        //println("didShowMenuViewController")
    }
    
    func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        //println("willHideMenuViewController")
    }
    
    func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        //println("didHideMenuViewController")
    }
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("rootView")
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("rootView")
    }
}

