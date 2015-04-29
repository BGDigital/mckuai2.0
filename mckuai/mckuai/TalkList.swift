//
//  TalkList.swift
//  mckuai
//
//  Created by 陈强 on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//


import UIKit

class TalkList: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var segmentedControl:HMSegmentedControl!
    var kindsArray = ["最新","精华","置顶"]
    var tableView : UITableView!
    var data = NSMutableArray()
    var currentPage:Int!
    var pageSize:Int = 5
    
    var viewIndex:Int!//view下标
    var isReloadView:Bool = false//初次是否加载
    
    var nibsRegistered = false;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 0.937, green: 0.941, blue: 0.949, alpha: 1.00)
        //初始化initSegmentControl
        initSegmentControl()
        initTableView()
        
        if(isReloadView == true) {
            self.tableView.legendHeader.beginRefreshing()
            loadNewData()
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func viewWillAppear(animated: Bool) {

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data.count > pageSize {
            self.tableView.footer.hidden = false
        }
        return self.data.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if(!nibsRegistered) {
            var nib: UINib = UINib(nibName: "mainSubCell", bundle: nil)
            tableView.registerNib(nib, forCellReuseIdentifier: "mainSubCell")
            nibsRegistered = true
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("mainSubCell") as? mainSubCell
        
//        var cell = tableView.dequeueReusableCellWithIdentifier("mainSubCell") as? mainSubCell
//        
//        
//        if cell == nil {
//            let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainSubCell", owner: self, options: nil)
//            cell = nib.lastObject as? mainSubCell
//        }
        
        cell!.title.text = self.data[indexPath.row] as? String
        cell?.imageV = UIImageView(image: UIImage(named: "1024"))
        return cell!
    }

    
    
    func initTableView() {
        var v = UIView(frame: CGRectMake(0, 45, self.view.bounds.size.width, self.view.bounds.size.height-192))
        self.tableView = UITableView(frame: CGRectMake(0, 0, v.frame.size.width, v.frame.size.height), style: UITableViewStyle.Plain)
        println(self.view.bounds.size)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.clearColor()
        tableView.separatorStyle = .None
        //        var bg = UIImageView(image: UIImage(named: "Image"))
        tableView.backgroundView = nil //这个可以改背影
        tableView.scrollsToTop = false //不返回顶部
        v.addSubview(tableView)
        self.view.addSubview(v)
        
        self.tableView.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        self.tableView.addLegendFooterWithRefreshingBlock({self.loadMoreData()})
        self.tableView.footer.hidden =  true
        

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
    
    func loadNewData(){
        //开始刷新
        let url = "https://www.v2ex.com/api/topics/hot.json"
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject).arrayValue
                if(json.count != 0) {
                    self.data.removeAllObjects()
                }
                for i in 0...json.count-1 {
                    self.data.addObject(json[i]["title"].stringValue)
                }
                
                self.tableView.header.endRefreshing()
                self.tableView.reloadData()
                self.isReloadView = true
                self.tableView.footer.resetNoMoreData()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.header.endRefreshing()
                self.showCustomHUD(self.view, title: "数据加载失败", imgName: "Guide")
        })
    }
    
    func loadMoreData(){
        
        //开始刷新
        let url = "https://www.v2ex.com/api/topics/hot.json"
        
        var manager = AFHTTPRequestOperationManager()
        manager.GET(url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject).arrayValue
                for i in 0...json.count-1 {
                    self.data.addObject(json[i]["title"].stringValue)
                }
                
                self.tableView.reloadData()
                //拿到数据,结束刷新
                self.tableView.footer.endRefreshing()
                if(json.count<self.pageSize){
                    self.tableView.footer.noticeNoMoreData()
                }
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                self.tableView.footer.endRefreshing()
        })
        
        
    }
    
    
    func initSegmentControl(){
        
        segmentedControl = HMSegmentedControl(sectionTitles: kindsArray)
        segmentedControl.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleWidth
        segmentedControl.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, 40)
        segmentedControl.backgroundColor = UIColor.whiteColor()
        segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10)
        segmentedControl.textColor = UIColor(red: 0.694, green: 0.694, blue: 0.694, alpha: 1.00)
        segmentedControl.selectedTextColor = UIColor(red: 0.255, green: 0.788, blue: 0.298, alpha: 1.00)
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.selectionIndicatorColor = UIColor(red: 0.255, green: 0.788, blue: 0.298, alpha: 1.00)
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.addTarget(self, action: "segmentSelected:", forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(segmentedControl)
    }
    
    func updateTableView () {
        print("updateTableView")
        if(isReloadView == false){
            self.tableView.legendHeader.beginRefreshing()
            loadNewData()
        }

    }
    
    func segmentSelected(sender: HMSegmentedControl) {
        println("segment selected:\(sender.selectedSegmentIndex)")
    }
    
}