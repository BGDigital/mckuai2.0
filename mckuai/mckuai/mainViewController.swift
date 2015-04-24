//
//  mainViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/16.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit


class mainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellIdentifier = "mainTableViewCell"
    let url = "http://118.144.83.145:8081/index.do?act=all"
    var manager = AFHTTPRequestOperationManager()
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                if let d = self.json["dataObject", "talk"].array {
                    self.datasource = d
                }
                if let live = self.json["dataObject", "banner"].array {
                    self.liveData = live
                }
            }
        }
    }
    
    var datasource: Array<JSON>! {
        didSet {
            self.tableView.reloadData()
        }
    }
    var liveData: Array<JSON>! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var tableView: UITableView!
    var head: mainHeaderViewController!
    
    class func mainRoot()->UIViewController{
        var main = UIStoryboard(name: "home", bundle: nil).instantiateViewControllerWithIdentifier("mainViewController") as! UIViewController
        main.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "first_normal"), selectedImage: UIImage(named: "first_selected"))
        return UINavigationController(rootViewController: main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        self.tabBarItem.badgeValue = "3"
        
        //设置标题颜色
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
            
        
        setupTableView()
//        self.data = NSMutableArray()
        loadNewData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00))
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        //        var bg = UIImageView(image: UIImage(named: "Image"))
        tableView.backgroundView = nil //这个可以改背影
        tableView.scrollsToTop = false
        
        //添加Header
        head = UIStoryboard(name: "home", bundle: nil).instantiateViewControllerWithIdentifier("mainHeaderViewController") as! mainHeaderViewController
        head.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 245)
        head.setNavi(self.navigationController)
        tableView.tableHeaderView = head.view
        
        self.view.addSubview(tableView)
        
        self.tableView.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        self.tableView.addLegendFooterWithRefreshingBlock({self.loadMoreData()})
        self.tableView.footer.hidden = true
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
    
    //加载数据,刷新
    func loadNewData() {
        //开始刷新
        manager.GET(url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println(responseObject)
                self.json = JSON(responseObject)
//                if "ok" == self.json["state"].stringValue {
//                    if let d = self.json["dataObject", "talk"].array {
//                        self.datasource = d
//                    }
//                    if let live = self.json["dataObject", "banner"].array {
//                        self.liveData = live
//                    }
//                }
                self.tableView.header.endRefreshing()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.header.endRefreshing()
                self.showCustomHUD(self.view, title: "数据加载失败", imgName: "Guide")
        })
        
    }
    
    //上拉加载更多数据
    func loadMoreData() {
        //1.添加假数据
        manager.GET(url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.json = JSON(responseObject)
                if "ok" == self.json["state"].stringValue {
                    if let d = self.json["dataObject"].array {
                        if self.datasource == nil {
                            self.datasource = d
                        } else {
                            self.datasource = self.datasource + d
                        }
                    }
                }
                self.tableView.footer.endRefreshing()
                //self.tableView.footer.noticeNoMoreData()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.footer.endRefreshing()
                self.showCustomHUD(self.view, title: "数据加载失败", imgName: "Guide")
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 192
        } else {
            return 118
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.datasource != nil && self.liveData != nil {
            if self.datasource.count > 10 {
                self.tableView.footer.hidden = false
            }
            switch (section) {
            case 0:
                return self.liveData.count
            default:
                return self.datasource.count
            }
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            //var cell = tableView.cellForRowAtIndexPath(indexPath) as? mainTableViewCell
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? mainTableViewCell
            if cell == nil {
                //如果没有cell就新创建出来
                println("Create mainTableViewCell, one......:\(indexPath.row)")
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainTableViewCell", owner: self, options: nil)
                cell = nib.lastObject as? mainTableViewCell
            }
            let d = self.liveData[indexPath.row] as JSON
            cell?.update(d)
            return cell!
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("mainSubCell") as? mainSubCell
            
            if cell == nil {
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainSubCell", owner: self, options: nil)
                cell = nib.lastObject as? mainSubCell
            }
            let d = self.datasource[indexPath.row] as JSON
            cell?.update(d)
            return cell!

        }
    }

}
