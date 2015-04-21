//
//  mainTabBarController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/17.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mainTabBarController: UITabBarController, ChangeTableDelegate {

    //自定义的Tabbar
    var mytabBar:TabBarController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化各个部分
        var home = mainViewController.mainRoot()
        var other = SecondViewController.mainRoot()
        var tabBarViewControllers = [home, other]
        self.setViewControllers(tabBarViewControllers, animated: false)
        self.tabBar.hidden = true;
        mytabBar = TabBarController.TabBarControllerInit()
        mytabBar.delegate = self
        mytabBar.view.frame = CGRect(x: 0, y: self.view.frame.size.height - 50 , width: self.view.frame.size.width, height: 50)
        self.view.addSubview(mytabBar.view)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeIndex(index: Int) {
        self.selectedIndex = index
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
