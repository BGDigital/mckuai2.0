//
//  communityViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/21.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit
var currentForumName:String! = ""
var forumName:Array<JSON>!

var userLoginView:NewLogin!
class communityViewController: UIViewController {
    
    var scrollPages = [UIViewController]()
    var topScrollView:SCNavTabBarController!
    
    
    var rightButtonItem:UIBarButtonItem?
    var rightButton:UIButton?
    let item_wight:CGFloat = 21
    let item_height:CGFloat = 21
    
    
    class func mainRoot()->UIViewController{
        setForumListData()
        
        var main = UIStoryboard(name: "community", bundle: nil).instantiateViewControllerWithIdentifier("communityViewController") as! UIViewController
        main.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named: "second_normal"), selectedImage: UIImage(named: "second_selected"))
        return UINavigationController(rootViewController: main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setRightBarButtonItem()
        
//        //设置navigation
        setNavigation()
        if(forumName != nil){
            for(var i = 0;i<forumName.count;i++){
                var viewTemp: TalkList! = UIStoryboard(name:"TalkList",bundle:nil).instantiateViewControllerWithIdentifier("talkList") as! TalkList
                viewTemp.forumId = forumName[i]["id"].intValue
                viewTemp.forumName = forumName[i]["name"].stringValue
                if(i<3) {
                    viewTemp.isReloadView = true
                }
                var titleTemp = forumName[i]["name"].stringValue
                let index = advance(titleTemp.startIndex, (count(titleTemp)+1)/2)
                titleTemp.insert("\n", atIndex: index)
                viewTemp.title = titleTemp
                self.scrollPages += [viewTemp]
            }
        }

        topScrollView = SCNavTabBarController()
        topScrollView.subViewControllers = self.scrollPages as [AnyObject]
        topScrollView.showArrowButton = false
        topScrollView.addParentController(self)


        

    }
    
    func setRightBarButtonItem() {
        self.rightButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.rightButton!.frame=CGRectMake(0,0,item_wight,item_height)
        self.rightButton?.setImage(UIImage(named: "sendTalk"), forState: UIControlState.Normal)
        self.rightButton?.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        self.rightButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.rightButton!.userInteractionEnabled = true
        self.rightButton?.addTarget(self, action: "rightBarButtonItemClicked", forControlEvents: UIControlEvents.TouchUpInside)
        var barButtonItem = UIBarButtonItem(customView:self.rightButton!)
        
        var negativeSpacer = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target:self,action:nil)
        negativeSpacer.width = -8
        self.navigationItem.rightBarButtonItems = [negativeSpacer,barButtonItem];
    }
    
    func rightBarButtonItemClicked() {
        print("send talk")
        
        if(appUserIdSave == 0) {
            //UserLogin.showUserLoginView(presentNavigator: self.navigationController)
            
             NewLogin.showUserLoginView(self,returnIsShow: true)
        }else{
            SendTalk.showSendTalkPage(self.navigationController)
        }
      
    }
    
    func showCustomHUD(view: UIView, title: String, imgName: String) {
        var h = MBProgressHUD.showHUDAddedTo(view, animated: true)
        h.labelText = title
        h.mode = MBProgressHUDMode.CustomView
        h.customView = UIImageView(image: UIImage(named: imgName))
        h.showAnimated(true, whileExecutingBlock: { () -> Void in
            sleep(2)
            return
            }) { () -> Void in
                h.removeFromSuperview()
                h = nil
        }
    }
    
    class func setForumListData() {
        AFHTTPRequestOperationManager().GET(forum_url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json:JSON! = JSON(responseObject)
                if "ok" == json["state"].stringValue {
                    forumName = json["dataObject"].array
                    println("setForumListData is successful")
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillDisappear(animated: Bool) {
//        self.tabBarController?.tabBar.hidden = 
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        self.tabBarController?.tabBar.hidden = false
        if(currentForumName != ""){
            
            var index = 0
            
            for(var i = 0;i<forumName.count;i++){
                if(currentForumName == forumName[i]["id"].stringValue){
                    index = i
                    break
                }
            }
            
            println(index)
            println(currentForumName)
            topScrollView.setShowCurrentView(index)
            currentForumName = ""
        }
        
    }
    
    func setNavigation() {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00))
        
        

        
    }
    
    
    
    



}
