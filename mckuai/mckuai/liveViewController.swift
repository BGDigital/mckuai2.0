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
    let url = "http://118.144.83.145:8081/index.do?act=all"
    var manager = AFHTTPRequestOperationManager()
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                if let d = self.json["dataObject", "banner"].array {
                    self.datasource = d
                }
            }
        }
    }
    
    var datasource: Array<JSON>! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    class func initializationLive()->UIViewController{
        var root = UIStoryboard(name: "live", bundle: nil).instantiateViewControllerWithIdentifier("liveViewController") as! UIViewController
        root.tabBarItem = UITabBarItem(title: "直播", image: UIImage(named: "third_normal"), selectedImage: UIImage(named: "third_selected"))
        return UINavigationController(rootViewController: root)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initSegmentedControl()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        
        
        setNaviStyle()
        setupTableView()
        //self.tableView.header.beginRefreshing()
        loadNewData()
        // Do any additional setup after loading the view.
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
        segmentedControl.frame = CGRectMake(0, 64, self.view.bounds.size.width, 25)
        
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
        println("segment selected:\(sender.selectedSegmentIndex)")
    }
    
    func setNaviStyle() {
        //菜单按钮
        var menu = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "showLiveType")
        menu.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = menu
        //设置标题颜色
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
    }
    
    func showLiveType() {
        var alertController = UIAlertController(title: "直播类型", message: "选择你感兴趣的直播类型", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil)
        var deleteAction = UIAlertAction(title: "生存", style: UIAlertActionStyle.Default, handler: nil)
        var archiveAction = UIAlertAction(title: "极限", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func loadNewData() {
        //开始刷新
        manager.GET(url,
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println(responseObject)
                self.json = JSON(responseObject)
                self.tableView.header.endRefreshing()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.header.endRefreshing()
                MCUtils.showCustomHUD(self.view, title: "数据加载失败", imgName: "Guide")
        })
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 64+25, self.view.frame.size.width, self.view.frame.size.height-(64+25)), style: UITableViewStyle.Plain)
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
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       return 190
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.datasource != nil {
            return self.datasource.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //var cell = tableView.cellForRowAtIndexPath(indexPath) as? mainTableViewCell
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? mainTableViewCell
        if cell == nil {
            //如果没有cell就新创建出来
            println("Create mainTableViewCell, one......:\(indexPath.row)")
            let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainTableViewCell", owner: self, options: nil)
            cell = nib.lastObject as? mainTableViewCell
        }
        let d = self.datasource[indexPath.row] as JSON
        cell?.update(d)
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
