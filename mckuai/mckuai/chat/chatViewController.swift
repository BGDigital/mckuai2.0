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
        customNavBackButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func customNavBackButton() {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        //设置标题颜色
        self.navigationItem.title = "聊天"
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        
        var back = UIBarButtonItem(image: UIImage(named: "sidemenu"), style: UIBarButtonItemStyle.Bordered, target: self, action: "leftBarButtonItemPressed:")
        back.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = back
    }
    
    override func leftBarButtonItemPressed(sender: AnyObject!) {
        //
    }
    
    override func rightBarButtonItemPressed(sender: AnyObject!) {
        //跳转好友列表界面，可是是融云提供的UI组件，也可以是自己实现的UI
        var temp: RCSelectPersonViewController = RCSelectPersonViewController()
        //控制多选
        temp.isMultiSelect = true
        temp.portaitStyle = RCUserAvatarStyle.Cycle
        var nav = UINavigationController(rootViewController: temp)
        //导航和的配色保持一直
        nav.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        temp.delegate = self
        self.presentViewController(nav, animated: true, completion: nil)
        //self.tabBarController?.tabBar.hidden = true
    }
    
    override func startPrivateChat(userInfo: RCUserInfo!) {
        if let c: customChatViewController = self.getChatController(userInfo.userId, conversationType: .ConversationType_PRIVATE) as? customChatViewController {
            self.addChatController(c)
            c.currentTarget = userInfo.userId
            c.currentTargetName = userInfo.name
            c.conversationType = .ConversationType_PRIVATE
            self.navigationController?.pushViewController(c, animated: true)
        } else {
            var chat = RCChatViewController()
            chat.portraitStyle = .Cycle
            chat.hidesBottomBarWhenPushed = true
            chat.currentTarget = userInfo.userId
            chat.currentTargetName = userInfo.name
            chat.conversationType = .ConversationType_PRIVATE
            self.navigationController?.pushViewController(chat, animated: true)
        }
    }
    
    override func onSelectedTableRow(conversation: RCConversation!) {
        //该方法目的延长会话聊天UI的生命周期
        if let c: customChatViewController = self.getChatController(conversation.targetId, conversationType: conversation.conversationType) as? customChatViewController {
            self.addChatController(c)
            c.currentTarget = conversation.targetId
            c.conversationType = conversation.conversationType
            c.currentTargetName = conversation.conversationTitle
            self.navigationController?.pushViewController(c, animated: true)
        } else {
        var chat = customChatViewController()
            chat.portraitStyle = .Cycle
            chat.hidesBottomBarWhenPushed = true
            chat.currentTarget = conversation.targetId
            chat.conversationType = conversation.conversationType
            chat.currentTargetName = conversation.conversationTitle
            self.navigationController?.pushViewController(chat, animated: true)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("chatView")
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("chatView")
    }
    
    
}
