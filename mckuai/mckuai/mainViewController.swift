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
    var hud: MBProgressHUD?
    var loginVC: UserLogin!
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
    var datasource: Array<JSON>! = Array(){
        didSet {
            self.tableView.reloadData()
        }
    }
    var liveData: Array<JSON>! = Array(){
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
//        println(UIScreen.mainScreen().applicationFrame)
        //设置标题颜色
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Guide"), style: UIBarButtonItemStyle.Bordered, target: self, action: "rightBarButtonItemClicked")
        setupTableView()
        MCUtils.mainNav = self.navigationController
        
        if isFirstLoad {
            loadDataWithoutMJRefresh()
        }
    }
    
    func loadDataWithoutMJRefresh() {
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud?.labelText = MCUtils.TEXT_LOADING
        loadNewData()
    }
    
    /**
    搜索界面
    */
    func rightBarButtonItemClicked() {
        MCUtils.showSearchView(self.navigationController)
    }
    

    
    func setupTableView() {
        if IS_IOS8() {
            self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)
        } else {
            self.tableView = UITableView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-(64+44)), style: UITableViewStyle.Plain)
        }
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
        MCUtils.mainHeadView = head
        head.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 235)
        head.setNavi(self.navigationController)
        tableView.tableHeaderView = head.view
        //初始化的时候隐藏head
        self.tableView.tableHeaderView?.hidden = true
        
        self.view.addSubview(tableView)
        
        self.tableView.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
    }
    
    //加载数据,刷新

    func loadNewData() {
        //开始刷新
        var dict = ["act":"indexRec", "id": appUserIdSave]
        manager.GET(URL_MC,
            parameters: dict,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println(responseObject)
                self.json = JSON(responseObject)
                self.isFirstLoad = false
                self.tableView.header.endRefreshing()
                self.hud?.hide(true)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.header.endRefreshing()
                self.hud?.hide(true)
                MCUtils.checkNetWorkState()
                MCUtils.showEmptyView(self.tableView, aImg: Load_Error!, aText: "哇哦~,加载数据出问题了")
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if !self.datasource.isEmpty && !self.datasource.isEmpty {
            self.tableView.tableHeaderView?.hidden = false
            return 2
        } else {
            self.tableView.tableHeaderView?.hidden = true
            MCUtils.showEmptyView(self.tableView, aImg: Load_Empty!, aText: "没有贴子,快下拉刷新试试?")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 190
        } else {
            return 190
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.datasource.isEmpty && !self.datasource.isEmpty {
            self.tableView.tableHeaderView?.hidden = false
            self.tableView.backgroundView = nil
            switch (section) {
            case 0:
                return self.liveData.count
            default:
                return self.datasource.count
            }
        } else {
            self.tableView.tableHeaderView?.hidden = true
            MCUtils.showEmptyView(self.tableView, aImg: Load_Empty!, aText: "没有贴子,快下拉刷新试试?")
            return 0
        }
    }
        
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let id = self.datasource[indexPath.row]["id"].stringValue
        TalkDetail.showTalkDetailPage(self.navigationController, id: id)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? mainTableViewCell
        if cell == nil {
            //如果没有cell就新创建出来
            let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainTableViewCell", owner: self, options: nil)
            cell = nib.lastObject as? mainTableViewCell
        }
        var d: JSON!
        switch (indexPath.section) {
        case 0:
            d = self.liveData[indexPath.row] as JSON
        default:
            d = self.datasource[indexPath.row] as JSON
        }
        cell?.update(d, iType: indexPath.section)
        return cell!
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
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("mainView")
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("mainView")
    }
}
