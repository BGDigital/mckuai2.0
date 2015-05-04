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
    var manager = AFHTTPRequestOperationManager()
    var isFirstLoad = true   //是否初次加载
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                if let d = self.json["dataObject", "talk"].array {
                    self.datasource = d
                }
                if let live = self.json["dataObject", "live"].array {
                    self.liveData = live
                }
                var userinfo = self.json["dataObject", "user"]
                var chat = self.json["dataObject", "chat"]
                head.setData(userinfo, chat: chat)
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
    
    class func initializationMain()->UIViewController{
        var root = UIStoryboard(name: "home", bundle: nil).instantiateViewControllerWithIdentifier("mainViewController") as! UIViewController
        root.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "first_normal"), selectedImage: UIImage(named: "first_selected"))
        return UINavigationController(rootViewController: root)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //manager.responseSerializer.acceptableContentTypes = NSSet(object: "application/json") as Set<NSObject>
        
        //设置标题颜色
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        
        setupTableView()
//        self.data = NSMutableArray()
        if isFirstLoad {
            self.tableView.header.beginRefreshing()
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
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
    }
    
    //加载数据,刷新
    func loadNewData() {
        //开始刷新
        println("ddd")
        manager.GET(URL_INDEX,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println(responseObject)
                self.json = JSON(responseObject)
                self.isFirstLoad = false
                self.tableView.header.endRefreshing()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                MCUtils.showEmptyView(self.tableView)
                self.tableView.header.endRefreshing()
                MCUtils.showCustomHUD(self.view, title: "数据加载失败", imgName: "Guide")
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.datasource != nil && self.liveData != nil {
            return 2
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 190
        } else {
            return 118
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.datasource != nil && self.liveData != nil {
            switch (section) {
            case 0:
                return self.liveData.count
            default:
                return self.datasource.count
            }
        } else {
            //没有数据
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
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat  {
        return 28
    }

    
    //自定义Section样式
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var v = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 28))
        var bg = UIImageView(image: UIImage(named: "section_bg"))
        bg.frame = v.frame
        v.addSubview(bg)
        var img: UIImage!
        if section == 0 {
            img = UIImage(named: "live_section")
        } else {
            img = UIImage(named: "hot_section")
        }
        var live = UIImageView(image: img)
        live.frame = CGRectMake((self.view.bounds.size.width - img.size.width) / 2 , 0, img.size.width, img.size.height)
        v.addSubview(live)
        return v
    }
}
