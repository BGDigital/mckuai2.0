//
//  favoriteViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/28.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class favoriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    let cellIdentifier = "mainSubCell"
    var isFirstLoad = true
    var manager = AFHTTPRequestOperationManager()
    var page: PageInfo!
    var hud: MBProgressHUD?
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                page = PageInfo(
                    currentPage: self.json["dataObject", "page"].intValue,
                    pageCount: self.json["dataObject", "pageCount"].intValue,
                    pageSize: self.json["dataObject", "pageSize"].intValue,
                    allCount: self.json["dataObject", "allCount"].intValue)
                if let d = self.json["dataObject", "data"].array {
                    if page.currentPage == 1 {
                        println("刷新数据")
                        self.datasource = d
                    } else {
                        println("加载更多")
                        self.datasource = self.datasource + d
                    }
                }
            }
        }
    }
    
    var datasource: Array<JSON>! = Array() {
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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        self.hidesBottomBarWhenPushed = true
        setupTableView()
        
        if isFirstLoad {
            loadDataWithoutMJRefresh()
        }
        // Do any additional setup after loading the view.
    }
    
    func loadDataWithoutMJRefresh() {
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud?.labelText = MCUtils.TEXT_LOADING
        loadNewData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNewData() {
        //开始刷新
        var dict = ["act":"collectTalk", "id": appUserIdSave, "page": 1]
        manager.GET(URL_MC,
            parameters: dict,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println(responseObject)
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
        println("开始加载\(self.page.currentPage+1)页")
        var dict = ["act":"collectTalk", "id": appUserIdSave, "page": page.currentPage+1]
        //println("加载:\(self.liveType),\(self.liveOrder)======")
        isFirstLoad = false
        //开始刷新
        manager.GET(URL_MC,
            parameters: dict,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println(responseObject)
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
    
    func setupTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 99, self.view.bounds.size.width, self.view.bounds.size.height-99), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        tableView.backgroundView = nil //这个可以改背影
        tableView.scrollsToTop = false
        
        self.view.addSubview(tableView)
        
        self.tableView.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        self.tableView.addLegendFooterWithRefreshingBlock({self.loadMoreData()})
        self.tableView.footer.hidden = true
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!self.datasource.isEmpty) {
            self.tableView.backgroundView = nil
            return self.datasource.count
        } else {
            MCUtils.showEmptyView(self.tableView)
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let id = self.datasource[indexPath.row]["id"].stringValue
        TalkDetail.showTalkDetailPage(self.navigationController, id: id)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
