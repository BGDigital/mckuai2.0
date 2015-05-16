//
//  leftMenuTableViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/16.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class leftMenuViewController: UIViewController, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource, UMSocialUIDelegate,ExitProtocol{
    
    let cellHeight: CGFloat = 50
    let headerHeight: CGFloat = 85
    var tableView: UITableView!
    let titles = ["我的背包", "分享给好友", "评价APP", "软件设置", "退出登录"]
    let images = ["backpacker", "share", "pingfen", "setting", "logout"]
    
    var Avatar: UIImageView!
    var username: UILabel!
    var level: UIButton!
    var btnLogin: UIButton!
    var btnSearch: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取用户信息
        if Defaults.hasKey(D_USER_ID) {
            appUserIdSave = Defaults[D_USER_ID].int!
            appUserPic = Defaults[D_USER_ARATAR].string!
            appUserLevel = Defaults[D_USER_LEVEL].int!
            appUserProcess = Float(Defaults[D_USER_PROCESS].double!)
            appUserNickName = Defaults[D_USER_NICKNAME].string!
            appUserAddr = Defaults[D_USER_ADDR].string!
            appUserRCID = Defaults[D_USER_RC_ID].string!
            appUserRCToken = Defaults[D_USER_RC_TOKEN].string!
        }

        self.tableView = UITableView(frame: CGRectMake(0, (self.view.frame.size.height-cellHeight * 6 - headerHeight) / 2, self.view.frame.size.width, cellHeight*7+headerHeight), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.backgroundView = nil
        tableView.separatorStyle = .None
        tableView.scrollsToTop = false
        
        //这里加了个Header(用户信息)
        var header = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, headerHeight))
        Avatar = UIImageView(frame: CGRectMake(15, 5, 40, 40))
        println(appUserPic)
        Avatar.sd_setImageWithURL(NSURL(string: appUserPic), placeholderImage: UIImage(named: "Avatar"))
        Avatar.layer.borderWidth = 1
        Avatar.layer.borderColor = UIColor.whiteColor().CGColor
        Avatar.layer.masksToBounds = true
        Avatar.layer.cornerRadius = 20
        Avatar.userInteractionEnabled = true
        var tapAvatar = UITapGestureRecognizer(target: self, action: "openUserCenter")
        Avatar.addGestureRecognizer(tapAvatar)
        header.addSubview(Avatar)
        
        username = UILabel(frame: CGRectMake(70, 0, self.view.frame.size.width-60, 20))
        username.text = appUserNickName
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: "HelveticaNeue", size: 16)
        username.userInteractionEnabled = true
        var tapNickName = UITapGestureRecognizer(target: self, action: "openUserCenter")
        username.addGestureRecognizer(tapNickName)
        header.addSubview(username)
        
        level = UIButton(frame: CGRectMake(70, 30, 45, 15))
        level.setTitle("LV."+String(appUserLevel), forState: .Normal)
        level.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        level.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12)
        level.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        level.layer.cornerRadius = 7
        level.addTarget(self, action: "openUserCenter", forControlEvents: .TouchUpInside)
        header.addSubview(level)
    
        btnLogin = UIButton(frame: CGRectMake(70, 10, 100, 30))
        btnLogin.setTitle("登录更精彩", forState: .Normal)
        btnLogin.titleLabel?.font = UIFont(name: btnLogin.titleLabel!.font.fontName, size: 14)
        btnLogin.backgroundColor = UIColor(hexString: "#30A243")
        btnLogin.layer.cornerRadius = 8
        btnLogin.addTarget(self, action: "userLogin", forControlEvents: UIControlEvents.TouchUpInside)
        header.addSubview(btnLogin)
        
        btnSearch = UIButton(frame: CGRectMake(15, 55, self.view.bounds.size.width-15-120, 30))
        btnSearch.backgroundColor = UIColor.blackColor()
        btnSearch.layer.borderColor = UIColor.whiteColor().CGColor
        btnSearch.layer.borderWidth = 1
        btnSearch.alpha = 0.2
        btnSearch.setTitle("搜索", forState: .Normal)
        btnSearch.titleLabel?.font = UIFont(name: btnSearch.titleLabel!.font.fontName, size: 14)
        btnSearch.titleLabel!.textAlignment = NSTextAlignment.Left
        btnSearch.addTarget(self, action: "showSearch", forControlEvents: .TouchUpInside)
        header.addSubview(btnSearch)
        
        header.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = header
        
        if appUserIdSave != 0 {
            username.hidden = false
            level.hidden = false
            btnLogin.hidden = true
        } else {
            username.hidden = true
            level.hidden = true
            btnLogin.hidden = false
        }
        
        self.view.addSubview(self.tableView)
    }
    
    @IBAction func openUserCenter() {
        if appUserIdSave != 0 {
            MobClick.event("leftMenuView", attributes: ["Type":"MineCenter"])
            var mineFrm = mineTableViewController()
            mineFrm.hidesBottomBarWhenPushed = true
            MCUtils.mainNav?.pushViewController(mineFrm, animated: true) //这个显示效果有问题
        } else {
            MobClick.event("leftMenuView", attributes: ["Type":"Login"])
            NewLogin.showUserLoginView(MCUtils.mainNav, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
        }
        //隐藏菜单
        self.sideMenuViewController.hideMenuViewController()
    }
        
    @IBAction func userLogin() {
        MobClick.event("leftMenuView", attributes: ["Type":"Login"])
        NewLogin.showUserLoginView(MCUtils.mainNav, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
        //隐藏菜单
        self.sideMenuViewController.hideMenuViewController()
    }
    
    @IBAction func showSearch() {
        MobClick.event("leftMenuView", attributes: ["Type":"Search"])
        MCUtils.showSearchView(MCUtils.mainNav)
        //隐藏菜单
        self.sideMenuViewController.hideMenuViewController()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if(response.responseCode.value == UMSResponseCodeSuccess.value) {
            MCUtils.showCustomHUD(self.view, title: "分享成功", imgName: "HUD_OK")
            MobClick.event("Share", attributes: ["Address":"leftView", "Type": "Success"])
        }
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.row+1) {
        case 0:
            //新手任务  这个取消了
            MobClick.event("leftMenuView", attributes: ["Type":"NewUser"])
//            self.sideMenuViewController.setContentViewController(MCUtils.TB, animated: true)
//            self.sideMenuViewController.hideMenuViewController()
            break
        case 1:
            MobClick.event("leftMenuView", attributes: ["Type":"MyBag"])
            //我的背包
            if appUserIdSave != 0 {
                MCUtils.openBackPacker(self.navigationController, userId: appUserIdSave)
            } else {
                TSMessage.showNotificationWithTitle("提示", subtitle: "亲,你要登录麦块后才能打开背包,先去登录吧", type: .Warning)
            }
        case 2:
            MobClick.event("leftMenuView", attributes: ["Type":"Share"])
            //分享给好友
            var url = "http://www.mckuai.com/down.html"
            println(url)
            MobClick.event("Share", attributes: ["Address":"侧边栏", "Type": "start"])
            ShareUtil.shareInitWithTextAndPicture(MCUtils.TB, text: "麦块我的世界盒子", image: DefaultShareImg!, shareUrl: url, callDelegate: self)
        case 3:
            //评价APP
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/sandman/id388887746?mt=8&uo=4"]];
            let alert = SCLAlertView()
            alert.addButton("给个好评", action: {
                UIApplication.sharedApplication().openURL(NSURL(string: URL_APPSTORE)!)
                MobClick.event("leftMenuView", attributes: ["Type":"toAppStore"])
            })
            alert.addButton("我要吐槽", action: {
                MobClick.event("leftMenuView", attributes: ["Type":"toFeedBack"])
                var feedbackView = UMFeedback.feedbackViewController()
                feedbackView.hidesBottomBarWhenPushed = true
                MCUtils.mainNav?.pushViewController(feedbackView, animated: true)
            })
            alert.showInfo("评价麦块", subTitle: "麦块的发展离不开大家的支持,希望大家多多给麦块好评", closeButtonTitle: "取消", duration: 0)
            
        case 4:
            //设置
            MobClick.event("leftMenuView", attributes: ["Type":"Setting"])
            if appUserIdSave != 0 {
                UserInfo.showUserInfoView(self.navigationController,aDelegate: (MCUtils.leftView as! leftMenuViewController))
            } else {
                TSMessage.showNotificationWithTitle("提示", subtitle: "亲,你要登录麦块后才能修改信息,先去登录吧", type: .Warning)
            }
        default:
            MobClick.event("leftMenuView", attributes: ["Type":"Logout"])
            if appUserIdSave != 0 {
                let alert = SCLAlertView()
                alert.addButton("确定注销") {
                    //清除数据
                    Defaults.remove(D_USER_ID)
                    Defaults.remove(D_USER_ARATAR)
                    Defaults.remove(D_USER_LEVEL)
                    Defaults.remove(D_USER_NICKNAME)
                    Defaults.remove(D_USER_ADDR)
                    Defaults.remove(D_USER_PROCESS)
                    appUserIdSave = 0
                    appUserLevel = 0
                    appUserPic = ""
                    appUserAddr = ""
                    appUserNickName = ""
                    //刷新界面
                    self.Avatar.image = DefaultUserAvatar_big
                    self.username.hidden = true
                    self.level.hidden = true
                    self.btnLogin.hidden = false
                    //刷新主界面
                    var mainCV = (MCUtils.mainHeadView as! mainHeaderViewController)
                    mainCV.roundProgressView.imageUrl = "1"
                    mainCV.nickname.hidden = true
                    mainCV.level.hidden = true
                    mainCV.locationCity.hidden = true
                    mainCV.bag.hidden = true
                    mainCV.btnLogin.hidden = false
                }
                alert.showWarning("注销登录", subTitle: "注销后不能打开个人中心,回复,收藏贴子,确定要注销吗?", closeButtonTitle: "我点错了", duration: 0)
            } else {
                TSMessage.showNotificationWithTitle("提示", subtitle: "你还没有登录,要登录后才可以注销哦", type: .Warning)
           }
        }
        //隐藏菜单
        self.sideMenuViewController.hideMenuViewController()
    }
    
    func userExitProtocol() {
        print("userExitProtocol")
        //清除数据
        Defaults.remove(D_USER_ID)
        Defaults.remove(D_USER_ARATAR)
        Defaults.remove(D_USER_LEVEL)
        Defaults.remove(D_USER_NICKNAME)
        Defaults.remove(D_USER_ADDR)
        Defaults.remove(D_USER_PROCESS)
        appUserIdSave = 0
        appUserLevel = 0
        appUserPic = ""
        appUserAddr = ""
        appUserNickName = ""
        
        //刷新界面
        self.Avatar.image = DefaultUserAvatar_big
        self.username.hidden = true
        self.level.hidden = true
        self.btnLogin.hidden = false
        //刷新主界面
        var mainCV = (MCUtils.mainHeadView as! mainHeaderViewController)
        mainCV.roundProgressView.imageUrl = "1"
        mainCV.nickname.hidden = true
        mainCV.level.hidden = true
        mainCV.locationCity.hidden = true
        mainCV.bag.hidden = true
        mainCV.btnLogin.hidden = false
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell?.textLabel?.highlightedTextColor = UIColor.lightGrayColor()
            cell?.selectedBackgroundView = UIView()
            cell?.textLabel?.text = titles[indexPath.row]
            cell?.imageView?.image = UIImage(named: images[indexPath.row])
            //线
//            var line = UIView(frame: CGRectMake(0, cell!.bounds.size.height-1, cell!.bounds.size.width, 0.5))
//            line.backgroundColor = UIColor.blackColor()
//            line.alpha = 0.15
//            cell?.addSubview(line)
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("leftMenuView")
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("leftMenuView")
    }
    
}
