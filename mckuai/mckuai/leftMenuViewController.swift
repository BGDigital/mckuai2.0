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
    let titles = ["推荐", "新手任务", "我的背包", "分享给好友", "软件设置", "评价APP", "退出登录"]
    let images = ["Guide", "Guide", "Guide", "Guide", "Guide", "Guide", "Guide"]

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
        //let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        switch (indexPath.row) {
        case 0:
            self.sideMenuViewController.setContentViewController(mainViewController.mainRoot(), animated: true)
            self.sideMenuViewController.hideMenuViewController()
            break
        case 1:
            self.sideMenuViewController.setContentViewController(liveViewController.mainRoot(), animated: true)
            self.sideMenuViewController.hideMenuViewController()
            break
        case 2:
            self.sideMenuViewController.setContentViewController(mineTableViewController
                .mainRoot(), animated: true)
            self.sideMenuViewController.hideMenuViewController()
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
            cell?.backgroundColor = UIColor.clearColor()
            cell?.textLabel?.font = UIFont(name: "HelveticaNeue", size: 21)
            cell?.textLabel?.textColor = UIColor.whiteColor()
            cell?.textLabel?.highlightedTextColor = UIColor.lightGrayColor()
            cell?.selectedBackgroundView = UIView()
            cell?.textLabel?.text = titles[indexPath.row]
            cell?.imageView?.image = UIImage(named: images[indexPath.row])
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
        return 7
    }
}
