//
//  customChatViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/5/8.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class customChatViewController: RCChatViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    override func rightBarButtonItemPressed(sender: AnyObject!) {
//        //跳转好友列表界面，可是是融云提供的UI组件，也可以是自己实现的UI
//        var temp: RCSelectPersonViewController = RCSelectPersonViewController()
//        //控制多选
//        temp.isMultiSelect = true
//        temp.portaitStyle = RCUserAvatarStyle.Cycle
//        var nav = UINavigationController(rootViewController: temp)
//        //导航和的配色保持一直
//        nav.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
//        temp.delegate = self
//        self.presentViewController(nav, animated: true, completion: nil)
//        //self.tabBarController?.tabBar.hidden = true
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.lt_reset()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("customChatView")
        self.navigationController?.navigationBar.lt_reset()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("customChatView")
    }
    
    

}
