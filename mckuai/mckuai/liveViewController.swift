//
//  SecondViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/16.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class liveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var tableView: UITableView!
    var segmentedControl: HMSegmentedControl!
    let cellIdentifier = "mainTableViewCell"
    var liveType = ""  //为空就取全部的数据
    var liveOrder = "new"
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
                println(self.json["dataObject", "page"].intValue)
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
    
    var datasource: Array<JSON>! = Array(){
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
    
    class func initializationLive()->UIViewController{
        var root = UIStoryboard(name: "live", bundle: nil).instantiateViewControllerWithIdentifier("liveViewController") as! UIViewController
        root.tabBarItem = UITabBarItem(title: "直播", image: UIImage(named: "second_normal"), selectedImage: UIImage(named: "second_selected"))
        return UINavigationController(rootViewController: root)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initSegmentedControl()
        
        setNaviStyle()
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

    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSegmentedControl() {
        segmentedControl = HMSegmentedControl(sectionTitles: ["正在直播", "热门推荐", "全部"])
        segmentedControl.frame = CGRectMake(0, 64, self.view.bounds.size.width, 35)
        
        segmentedControl.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleWidth
        segmentedControl.backgroundColor = UIColor.whiteColor()
        segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10)
        segmentedControl.textColor = UIColor(red: 0.694, green: 0.694, blue: 0.694, alpha: 1.00)
        segmentedControl.selectedTextColor = UIColor(red: 0.255, green: 0.788, blue: 0.298, alpha: 1.00)
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.selectionIndicatorColor = UIColor(red: 0.255, green: 0.788, blue: 0.298, alpha: 1.00)
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.addTarget(self, action: "segmentSelected:", forControlEvents: UIControlEvents.ValueChanged)  //这里不能用ValueChange,会报错!
        self.view.addSubview(segmentedControl)
    }
    
    @IBAction func segmentSelected(sender: HMSegmentedControl) {
//        println("segment selected:\(sender.selectedSegmentIndex)")
        switch (sender.selectedSegmentIndex) {
        case 0:
            self.liveOrder = "new"
            break
        case 1:
            self.liveOrder = "hot"
            break
        default:
            self.liveOrder = "all"
            break
        }
        loadDataWithoutMJRefresh()
        //self.tableView.header.beginRefreshing()
    }
    
    func setNaviStyle() {
        //菜单按钮
        //var menu = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "showLiveType")
        var menu = UIBarButtonItem(title: "全部", style: UIBarButtonItemStyle.Bordered, target: self, action: "showLiveType")
        menu.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = menu
        //设置标题颜色
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
    }
    
    func showLiveType() {
        var alertController = UIAlertController(title: "直播类型", message: "选择你感兴趣的直播类型", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        var deleteAction = UIAlertAction(title: "生存直播", style: UIAlertActionStyle.Default, handler: {a in
            self.liveType = a.title
            println(self.liveType)
            self.navigationItem.rightBarButtonItem?.title = "生存"
            self.loadDataWithoutMJRefresh()
            //self.tableView.header.beginRefreshing()
        })
        
        var archiveAction = UIAlertAction(title: "极限直播", style: UIAlertActionStyle.Default, handler: {a in
            self.liveType = a.title
            println(self.liveType)
            self.navigationItem.rightBarButtonItem?.title = "极限"
            self.loadDataWithoutMJRefresh()
            //self.tableView.header.beginRefreshing()
        })
        
        var allAction = UIAlertAction(title: "全部直播", style: UIAlertActionStyle.Default, handler: {a in
            self.liveType = ""
            println(self.liveType)
            self.navigationItem.rightBarButtonItem?.title = "全部"
            self.loadDataWithoutMJRefresh()
            //self.tableView.header.beginRefreshing()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        alertController.addAction(allAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func loadNewData() {
        var dict = ["act":"live",
                    "page":1,
                    "type":self.liveType,
                    "orderField":self.liveOrder]
        //println("加载:\(self.liveType),\(self.liveOrder)======")
        //开始刷新
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
        var dict = ["act":"live",
            "page":self.page.currentPage+1,
            "type":self.liveType,
            "orderField":self.liveOrder]
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
        self.tableView = UITableView(frame: CGRectMake(0, 64+35, self.view.frame.size.width, self.view.frame.size.height-(64+35+44)), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        //        var bg = UIImageView(image: UIImage(named: "Image"))
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
       return 190
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.datasource.isEmpty {
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
        //var cell = tableView.cellForRowAtIndexPath(indexPath) as? mainTableViewCell
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? mainTableViewCell
        if cell == nil {
            //如果没有cell就新创建出来
            let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainTableViewCell", owner: self, options: nil)
            cell = nib.lastObject as? mainTableViewCell
        }
        let d = self.datasource[indexPath.row] as JSON
        cell?.update(d, iType: 0)
        return cell!
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
