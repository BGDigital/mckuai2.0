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
        var image = UIImageView(frame: CGRectMake(0, 0, 50, 50))
        image.image = UIImage(named: "1024")
        header.addSubview(image)
        
        var username = UILabel(frame: CGRectMake(55, 0, self.view.frame.size.width-60, 25))
        username.text = "邱兴福"
        username.textColor = UIColor.whiteColor()
        username.font = UIFont(name: "HelveticaNeue", size: 21)
        header.addSubview(username)
        
        var level = UILabel(frame: CGRectMake(55, 30, self.view.frame.size.width-60, 15))
        level.text = "等级:12"
        level.textColor = UIColor.whiteColor()
        level.font = UIFont(name: "HelveticaNeue", size: 12)
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
        }
        
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
