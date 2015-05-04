//
//  mineTableViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mineTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MineProtocol {
    var tableView: UITableView!
    var isFirstLoad = true
    var mineType = "message"
    var mineMsgType = "reply"
    var head: mineHeadViewController!
    let NAVBAR_CHANGE_POINT:CGFloat = 50
    var manager = AFHTTPRequestOperationManager()
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                if let d = self.json["dataObject", "list", "data"].array {
                    self.datasource = d
                }
                self.User = self.json["dataObject", "user"] as JSON
                self.pageInfo = self.json["dataObject", "pageInfo"] as JSON
            }
            head.RefreshHead(User)
            self.tableView.reloadData()
        }
    }
    var User: JSON!
    var pageInfo: JSON!
    var datasource: Array<JSON>!
    
    class func initializationMine()->UIViewController{
        var mine = UIStoryboard(name: "mine", bundle: nil).instantiateViewControllerWithIdentifier("mineTableViewController") as! mineTableViewController
        return UINavigationController(rootViewController: mine)
    }
    
    func setupViews() {
        self.tableView = UITableView(frame: CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height+64), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        tableView.backgroundView = nil //这个可以改背影
        tableView.scrollsToTop = false
        
        //添加Header
        self.head = UIStoryboard(name: "mine", bundle: nil).instantiateViewControllerWithIdentifier("mineHeadViewController") as! mineHeadViewController
        tableView.tableHeaderView = self.head.view
        self.head.Delegate = self
        self.view.addSubview(tableView)
        
        self.tableView.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        self.tableView.addLegendFooterWithRefreshingBlock({self.loadMoreData()})
        self.tableView.footer.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        customNavBackButton()
        if isFirstLoad {
            self.tableView.header.beginRefreshing()
        }
    }
    
    func customNavBackButton() {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        //设置标题颜色 白色
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        
        var back = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "backToMain")
        back.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = back
    }
    
    func backToMain() {
        self.navigationController?.popViewControllerAnimated(true)
        //设置主界面
        self.sideMenuViewController.setContentViewController(MCUtils.TB, animated: true)
    }

    
    func refreshTableView() {
        println("刷新TableView")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var color = UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00)
        var offsetY = scrollView.contentOffset.y
        if offsetY > NAVBAR_CHANGE_POINT {
            var alpha = 1 - (NAVBAR_CHANGE_POINT + 64 - offsetY) / 64
            self.navigationItem.title = "个人中心"
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
            self.navigationItem.title = ""
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollViewDidScroll(self.tableView)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.mineType != "work" {
            return 100
        } else {
            return 118
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.datasource != nil {
            return self.datasource.count
        } else {
            MCUtils.showEmptyView(self.tableView)
            return 0
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.mineType != "work" {
            var cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as? messageCell
            
            if cell == nil {
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("messageCell", owner: self, options: nil)
                cell = nib.lastObject as? messageCell
            }
            let d = self.datasource[indexPath.row] as JSON
            cell?.update(d, iType: self.mineType, sMsgType: self.mineMsgType)
            // Configure the cell...
            
            return cell!

        } else {
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }
    
    func loadNewData() {
        //开始刷新
        var param = [
            "act": "center",
            "id": 1,
            "page": 1,
            "type":self.mineType,
            "messageType": self.mineMsgType]
        manager.GET(URL_MC,
            parameters: param,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.json = JSON(responseObject)
                self.tableView.header.endRefreshing()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.header.endRefreshing()
                //self.showCustomHUD(self.view, title: "数据加载失败", imgName: "Guide")
        })
    }
    
    func loadMoreData() {
        
    }

    //刷新数据
    //1:消息,2:动态,3:作品
    //0:@Me,1:系统, 2:为空,不用传
    func onRefreshDataSource(iType: Int, iMsgType: Int) {
        //大类型
        switch (iType) {
        case 1:
            self.mineType = "message"
        case 2:
            self.mineType = "dynamic"
            break
        default:
            self.mineType = "work"
            break
        }
        //小类型
        switch (iMsgType) {
        case 0:
            self.mineMsgType = "reply"
            break
        case 1:
            self.mineMsgType = "system"
            break
        default:
            self.mineMsgType = ""
            break
        }
        //开始加载数据
        self.tableView.header.beginRefreshing()
    }

}
