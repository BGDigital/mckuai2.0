//
//  communityViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/21.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit
var currentForumName:String! = ""
class communityViewController: UIViewController {
    var topScrollView:SCNavTabBarController!
    var scrollPages = [UIViewController]()
    var forumName = ["矿工茶馆","游戏技巧","活动福利","地图&皮肤","问答反馈","服务器&软件","服务器发布","版主专区","直播专区"]
    class func mainRoot()->UIViewController{
        var main = UIStoryboard(name: "community", bundle: nil).instantiateViewControllerWithIdentifier("communityViewController") as! UIViewController
        main.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named: "fourth_normal"), selectedImage: UIImage(named: "fourth_selected"))
        return UINavigationController(rootViewController: main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置navigation
        setNavigation()
        
        for(var i = 0;i<forumName.count;i++){
            var viewTemp: TalkList! = UIStoryboard(name:"TalkList",bundle:nil).instantiateViewControllerWithIdentifier("talkList") as! TalkList
            if(i<3) {
                viewTemp.isReloadView = true
            }
            viewTemp.title = forumName[i]
            scrollPages += [viewTemp]
        }
        topScrollView = SCNavTabBarController()
        topScrollView.subViewControllers = scrollPages as [AnyObject]
        topScrollView.showArrowButton = false
        topScrollView.addParentController(self)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        if(currentForumName != ""){
            topScrollView.setShowCurrentView(3)
            currentForumName = ""
        }
        
    }
    
    func setNavigation() {
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00))
    }
    
    
    
    
}
