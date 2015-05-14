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
    var page: PageInfo!
    var hud: MBProgressHUD?
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                page = PageInfo(
                    currentPage: self.json["dataObject", "list", "page"].intValue,
                    pageCount: self.json["dataObject", "list", "pageCount"].intValue,
                    pageSize: self.json["dataObject", "list", "pageSize"].intValue,
                    allCount: self.json["dataObject", "list", "allCount"].intValue)
                if let d = self.json["dataObject", "list", "data"].array {
                    if page.currentPage == 1 {
                        println("刷新数据")
                        self.datasource = d
                    } else {
                        println("加载更多")
                        self.datasource = self.datasource + d
                    }
                }
                self.User = self.json["dataObject", "user"] as JSON
            }
            head.RefreshHead(User, parent: self)
            self.tableView.reloadData()
        }
    }
    var User: JSON!
    var datasource: Array<JSON> = Array() {
        didSet {
            if self.datasource.count < page.allCount {
                self.tableView.footer.hidden = self.datasource.count < page.pageSize
                println("没有达到最大值 \(self.tableView.footer.hidden)")
            } else {
                println("最大值了,noMoreData")
                self.tableView.footer.hidden = true
            }
            self.tableView.reloadData()
        }
    }
    
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
        
        if isFirstLoad {
            loadDataWithoutMJRefresh()
        }
    }
    
    func loadDataWithoutMJRefresh() {
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud?.labelText = MCUtils.TEXT_LOADING
        loadNewData()
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
    



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.mineType != "work" {
            return 100
        } else {
            return 80
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
        if !self.datasource.isEmpty {
            self.tableView.backgroundView = nil
            return self.datasource.count
        } else {
            MCUtils.showEmptyView(self.tableView, aImg: Load_Empty!, aText: "你还没有发布作品,快去社区发贴吧")
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.mineMsgType != "system" {
            let id = self.datasource[indexPath.row]["id"].stringValue
            TalkDetail.showTalkDetailPage(self.navigationController, id: id)
        }
    }
    
    func loadNewData() {
        //开始刷新
        var param = [
            "act": "center",
            "id": appUserIdSave,
            "page": 1,
            "type":self.mineType,
            "messageType": self.mineMsgType]
        manager.GET(URL_MC,
            parameters: param,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.isFirstLoad = false
                self.json = JSON(responseObject)
                self.tableView.header.endRefreshing()
                self.hud?.hide(true)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.header.endRefreshing()
                self.hud?.hide(true)
                MCUtils.showCustomHUD(self.view, title: "数据加载失败", imgName: "HUD_ERROR")
        })
    }
    
    func loadMoreData() {
        var param = [
            "act": "center",
            "id": appUserIdSave,
            "page": page.currentPage+1,
            "type":self.mineType,
            "messageType": self.mineMsgType]
        manager.GET(URL_MC,
            parameters: param,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.json = JSON(responseObject)
                self.tableView.footer.endRefreshing()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.footer.endRefreshing()
                MCUtils.showCustomHUD(self.view, title: "数据加载失败", imgName: "HUD_ERROR")
        })
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
        loadDataWithoutMJRefresh()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("mineTableView")
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        self.scrollViewDidScroll(self.tableView)
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("mineTableView")
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
    }
    

}
