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
    let headerHeight: CGFloat = 50
    var tableView: UITableView!
    let titles = ["新手任务", "我的背包", "分享给好友", "评价APP", "软件设置", "退出登录"]
    let images = ["newuser", "backpacker", "share", "pingfen", "setting", "logout"]

    override func viewDidLoad() {
        super.viewDidLoad()

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
        var Avatar = UIImageView(frame: CGRectMake(15, 5, 40, 40))
        Avatar.image = UIImage(named: "1024")
        Avatar.backgroundColor = UIColor.clearColor()  //这句可有可无
        Avatar.layer.masksToBounds = true
        Avatar.layer.cornerRadius = 20
        header.addSubview(Avatar)
        
        var username = UILabel(frame: CGRectMake(70, 0, self.view.frame.size.width-60, 20))
        username.text = "一叶之秋"
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: "HelveticaNeue", size: 16)
        header.addSubview(username)
        
        var level = UIButton(frame: CGRectMake(70, 30, 45, 15))
        level.setTitle("LV.8", forState: .Normal)
        level.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        level.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12)
        level.backgroundColor = UIColor(hexString: "#000000", alpha: 0.3)
        level.layer.cornerRadius = 7
        header.addSubview(level)
        
        header.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = header
        
        self.view.addSubview(self.tableView)
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
            MCUtils.openBackPacker(self.navigationController, userId: 6)
            break
        case 2:
            //分享给好友
            break
        case 3:
            //评价APP
            break
        case 4:
            //设置
            break
        default:
            //退出
            break
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
