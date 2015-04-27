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

class rootViewController: RESideMenu, RESideMenuDelegate {
    
    var TB: UITabBarController!
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
        
        TB = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("contentViewController") as! UITabBarController
        TB.tabBar.tintColor = UIColor(red: 0.212, green: 0.804, blue: 0.380, alpha: 1.00)
        TB.viewControllers = [main, second,third, four]
        
        self.contentViewController = TB
        self.leftMenuViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("leftMenuViewController") as! UIViewController
        //self.rightMenuViewController = mainStoryboard.instantiateViewControllerWithIdentifier("leftMenuViewController") as! UIViewController
        self.backgroundImage = UIImage(named: "Image")
        self.delegate = self;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}

