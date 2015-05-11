//
//  leftMenuTableViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/16.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class leftMenuViewController: UIViewController, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let cellHeight: CGFloat = 50
    let headerHeight: CGFloat = 80
    var tableView: UITableView!
    let titles = ["新手任务", "我的背包", "分享给好友", "评价APP", "软件设置", "退出登录"]
    let images = ["newuser", "backpacker", "share", "pingfen", "setting", "logout"]
    
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
            appUserLevel = 8
            //appUserPic = ""
            //appUserNickName = "一叶之秋"
//            appUserAddr = "成都市"

            appUserLevel = Defaults[D_USER_LEVEL].int!
            appUserPic = Defaults[D_USER_ARATAR].string!
            appUserNickName = Defaults[D_USER_NICKNAME].string!
            appUserAddr = Defaults[D_USER_ADDR].string!
        }

        self.tableView = UITableView(frame: CGRectMake(0, (self.view.frame.size.height-cellHeight*7-headerHeight) / 2, self.view.frame.size.width, cellHeight*7+headerHeight), style: UITableViewStyle.Plain)
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
        header.addSubview(Avatar)
        
        username = UILabel(frame: CGRectMake(70, 0, self.view.frame.size.width-60, 20))
        username.text = appUserNickName
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: "HelveticaNeue", size: 16)
        header.addSubview(username)
        
        level = UIButton(frame: CGRectMake(70, 30, 45, 15))
        level.setTitle("LV."+String(appUserLevel), forState: .Normal)
        level.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        level.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12)
        level.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        level.layer.cornerRadius = 7
        header.addSubview(level)
    
        btnLogin = UIButton(frame: CGRectMake(70, 10, 100, 30))
        btnLogin.setTitle("登录更精彩", forState: .Normal)
        btnLogin.titleLabel?.font = UIFont(name: btnLogin.titleLabel!.font.fontName, size: 14)
        btnLogin.backgroundColor = UIColor(hexString: "#30A243")
        btnLogin.layer.cornerRadius = 8
        btnLogin.addTarget(self, action: "userLogin", forControlEvents: UIControlEvents.TouchUpInside)
        header.addSubview(btnLogin)
        
        btnSearch = UIButton(frame: CGRectMake(15, 55, self.view.bounds.size.width-15-120, 25))
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
        
    @IBAction func userLogin() {
        NewLogin.showUserLoginView(MCUtils.mainNav, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
        //隐藏菜单
        self.sideMenuViewController.hideMenuViewController()
    }
    
    @IBAction func showSearch() {
        MCUtils.showSearchView(MCUtils.mainNav)
        //隐藏菜单
        self.sideMenuViewController.hideMenuViewController()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (indexPath.row) {
        case 0:
            //新手任务
//            self.sideMenuViewController.setContentViewController(MCUtils.TB, animated: true)
//            self.sideMenuViewController.hideMenuViewController()
            break
        case 1:
            //我的背包
            if appUserIdSave != 0 {
                MCUtils.openBackPacker(self.navigationController, userId: appUserIdSave)
            } else {
                SCLAlertView().showWarning("提示", subTitle: "登录后才能打开背包,先登录吧", closeButtonTitle: "确定", duration: 0)
            }
        case 2:
            //分享给好友
            break
        case 3:
            //评价APP
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/sandman/id388887746?mt=8&uo=4"]];
            UIApplication.sharedApplication().openURL(NSURL(string: URL_APPSTORE)!)
        case 4:
            //设置
            UserInfo.showUserInfoView(self.navigationController)
        default:
            if appUserIdSave != 0 {
                let alert = SCLAlertView()
    //            alert.addButton("确定注销", target:self, selector:Selector("firstButton"))
                alert.addButton("确定注销") {
                    //清除数据
                    Defaults.remove(D_USER_ID)
                    Defaults.remove(D_USER_ARATAR)
                    Defaults.remove(D_USER_LEVEL)
                    Defaults.remove(D_USER_NICKNAME)
                    Defaults.remove(D_USER_ADDR)
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
                SCLAlertView().showWarning("注销登录", subTitle: "无效操作,你还没有登录", closeButtonTitle: "确定", duration: 0)
            }
        }
        //隐藏菜单
        self.sideMenuViewController.hideMenuViewController()
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
            var line = UIView(frame: CGRectMake(0, cell!.bounds.size.height-1, cell!.bounds.size.width, 0.5))
            line.backgroundColor = UIColor.blackColor()
            line.alpha = 0.15
            cell?.addSubview(line)
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
    
}
