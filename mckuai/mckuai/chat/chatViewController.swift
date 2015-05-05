//
//  chatViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/21.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class chatViewController: RCChatListViewController {

    class func mainRoot()->UIViewController{
        var main = UIStoryboard(name: "chat", bundle: nil).instantiateViewControllerWithIdentifier("chatViewController") as! RCChatListViewController
        //tabbar
        main.tabBarItem = UITabBarItem(title: "聊天", image: UIImage(named: "third_normal"), selectedImage: UIImage(named: "third_selected"))
        return UINavigationController(rootViewController: main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //customNavBackButton()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func customNavBackButton() {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        //设置标题颜色
        self.navigationItem.title = "聊天"
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        
//        var back = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "backToMain")
//        back.tintColor = UIColor.whiteColor()
//        self.navigationItem.leftBarButtonItem = back
    }
    
//    @IBAction func beginChat(sender: AnyObject) {
//        RCIM.connectWithToken(MCUtils.RC_token,
//            completion: {userId in
//                println("Login Successrull:\(userId)")
//                var v: RCChatListViewController = RCIM.sharedRCIM().createConversationList(nil)
//                v.hidesBottomBarWhenPushed = true
//                //self.navigationController?.pushViewController(v, animated: true)
//            },
//            error: {status in
//                println("Login Faild. \(status)")
//        })
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
