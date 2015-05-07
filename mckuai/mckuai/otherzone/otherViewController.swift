//
//  otherViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/29.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class otherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OtherProtocol, UIGestureRecognizerDelegate {

    private var tableView: UITableView!
    private var otherhead: otherHeadViewController!
    private var UserId: Int?  //外面传进来的UserId
    private let NAVBAR_CHANGE_POINT:CGFloat = 50
    private var manager = AFHTTPRequestOperationManager()
    var page: PageInfo!
    var hud: MBProgressHUD?
    var isFirstLoad = true
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
            otherhead.RefreshHead(User)
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
    
    var mineType = "dynamic"
    
    init(uId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.UserId = uId
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        otherhead = UIStoryboard(name: "other", bundle: nil).instantiateViewControllerWithIdentifier("otherHeadViewController") as! otherHeadViewController
        otherhead.Delegate = self
        tableView.tableHeaderView = otherhead.view
        self.view.addSubview(tableView)
        
        self.tableView.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        self.tableView.addLegendFooterWithRefreshingBlock({self.loadMoreData()})
        self.tableView.footer.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        setupViews()
        showPopWindow()
        customNavBackButton()
        
        if isFirstLoad {
            loadDataWithoutMJRefresh()
        }
    }
    
    func loadDataWithoutMJRefresh() {
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud?.labelText = MCUtils.TEXT_LOADING
        loadNewData()
    }
    
    func customNavBackButton() {
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        //设置标题颜色 白色
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        
        var back = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "backToMain")
        back.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = back
        self.navigationController?.interactivePopGestureRecognizer.delegate = self    // 启用 swipe back
    }
    
    func backToMain() {
        self.navigationController?.popViewControllerAnimated(true)
        //设置主界面
        //self.sideMenuViewController.setContentViewController(MCUtils.TB, animated: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var color = UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00)
        var offsetY = scrollView.contentOffset.y
        if offsetY > NAVBAR_CHANGE_POINT {
            var alpha = 1 - (NAVBAR_CHANGE_POINT + 64 - offsetY) / 64
            self.navigationItem.title = self.User["nike"].stringValue
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
            self.navigationItem.title = ""
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.scrollViewDidScroll(self.tableView)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.lt_reset()
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let id = self.datasource[indexPath.row]["id"].stringValue
        TalkDetail.showTalkDetailPage(self.navigationController, id: id)
    }
    
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
            cell?.update(d, iType: self.mineType, sMsgType: "")
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
    
    func loadNewData() {
        //开始刷新
        var param = [
            "act": "center",
            "id": self.UserId!,
            "page": 1,
            "type":self.mineType]
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
            "id": self.UserId!,
            "page": self.page.currentPage+1,
            "type":self.mineType]
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
    func onRefreshDataSource(iType: Int) {
        //大类型
        switch (iType) {
        case 1:
            self.mineType = "dynamic"
        default:
            self.mineType = "work"
            break
        }
        //开始加载数据
        //self.tableView.header.beginRefreshing()
        loadDataWithoutMJRefresh()
    }
    
    //显示弹出出的选项
    func showPopWindow() {
        var view = UIView(frame: CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50))
        view.backgroundColor = UIColor.blackColor()
        
        //button1
        var btn1 = UIButton(frame: CGRectMake(0, 0, self.view.bounds.size.width/2, 50))
        btn1.setImage(UIImage(named: "backpacker_add"), forState: .Normal)
        btn1.setTitle("加入背包", forState: .Normal)
        btn1.addTarget(self, action: "btn1Click", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btn1)
        
        //button2
        var btn2 = UIButton(frame: CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, 50))
        btn2.setImage(UIImage(named: "backpacker_chat"), forState: .Normal)
        btn2.setTitle("和TA聊天", forState: .Normal)
        view.addSubview(btn2)
        
        //渐入效果
        view.alpha = 0
        self.view.addSubview(view)
        UIView.animateWithDuration(0.5, animations: {
            view.alpha = 1
        })
    }
    
    //加入背包
    @IBAction func btn1Click() {
        var param = [
            "act": "attention",
            "ownerId": 6,
            "otherId": self.UserId!]
        manager.POST(URL_MC,
            parameters: param,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println("加入背包:\(responseObject)")
                MCUtils.showCustomHUD(self.view, title: "添加成功", imgName: "HUD_OK")
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                MCUtils.showCustomHUD(self.view, title: "添加失败,请重试", imgName: "HUD_ERROR")
        })
    }

}