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
    
    var reloadView:UIView!
    
    class func mainRoot()->UIViewController{
//        setForumListData()
        
        var main = UIStoryboard(name: "community", bundle: nil).instantiateViewControllerWithIdentifier("communityViewController") as! UIViewController
        main.tabBarItem = UITabBarItem(title: "社区", image: UIImage(named: "second_normal"), selectedImage: UIImage(named: "second_selected"))
        return UINavigationController(rootViewController: main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBarButtonItem()
//        //设置navigation
        setNavigation()
        
        self.setForumListData()



        

    }
    
    
    func setForumTool(){
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
        
        topScrollView = SCNavTabBarController(subViewControllers: self.scrollPages as [AnyObject], andParentViewController: self, showArrowButton: false)
        
        self.topScrollView.view.frame.origin.y = 64
        
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
        
        MobClick.event("community",attributes: ["type":"sendTalk"])

        if( appUserIdSave == 0) {
           NewLogin.showUserLoginView(self.navigationController, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
        }else{
            SendTalk.showSendTalkPage(self.navigationController)
        }
      
    }
    
     func setForumListData() {
        var progress = MBProgressHUD.showHUDAddedTo(view, animated: true)
        progress.labelText = "正在加载"
        AFHTTPRequestOperationManager().GET(forum_url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json:JSON! = JSON(responseObject)
                if "ok" == json["state"].stringValue {
                    forumName = json["dataObject"].array
//                    println("setForumListData is successful")
                    self.setForumTool()
                }else{
                    self.reloadDataView()
                }
                progress.hide(true)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
//                println("Error: " + error.localizedDescription)
                progress.hide(true)
                MCUtils.showCustomHUD(self.view, title: "数据加载失败", imgName: "HUD_ERROR")
                self.reloadDataView()

        })
    }
    
    func reloadDataView(){
        reloadView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        var img = UIImageView(image: Load_Empty!)
        img.frame = CGRectMake((self.reloadView.frame.size.width-img.bounds.size.width)/2, (self.reloadView.frame.size.height-img.bounds.size.height)/2, img.bounds.size.width, img.bounds.size.height)
        reloadView.addSubview(img)
        
        var lb = UILabel(frame: CGRectMake(0, img.frame.origin.y+img.frame.size.height+10, reloadView.bounds.size.width, 20))
        lb.text = "囧～没数据,点击刷新试试"
        lb.numberOfLines = 2;
        lb.textAlignment = .Center;
        lb.textColor = UIColor.lightGrayColor()
        reloadView.addSubview(lb)
        
        var imgCick = UITapGestureRecognizer(target: self, action: "reloadViewClick")
        self.reloadView.addGestureRecognizer(imgCick)
        self.view.addSubview(reloadView)
    }
    
    func reloadViewClick() {
        self.reloadView.hidden = true
        self.setForumListData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    

    
    func setNavigation() {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
//        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00))
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if(self.topScrollView != nil){
              self.topScrollView.view.frame.origin.y = 0
        }
      
            MobClick.beginLogPageView("friendsView")
            self.tabBarController?.tabBar.hidden = false
            if(currentForumName != "" && forumName != nil){
                
                var index = 0
                for(var i = 0;i<forumName.count;i++){
                    if(currentForumName == forumName[i]["id"].stringValue){
                        index = i
                        break
                    }
                }
                topScrollView.setShowCurrentView(index)
                currentForumName = ""
            }

    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("friendsView")
    }

    
    
    



}
