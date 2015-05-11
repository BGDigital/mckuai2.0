//
//  SearchViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/5/11.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var searchBar: UISearchBar!
    var tableView: UITableView!
    var segmentedControl: HMSegmentedControl!
    var nav: UINavigationController?
    var manager = AFHTTPRequestOperationManager()
    var hud: MBProgressHUD?
    var searchType: String = "talk"
    var searchKey: String = ""
    
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                if let d = self.json["dataObject", "data"].array {
                    self.datasource = d
                }
            } else {
                self.datasource.removeAll(keepCapacity: false)
            }
        }
    }
    
    var datasource: Array<JSON> = Array() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nav = self.navigationController
        setupTableView()
        initSegmentedControl()
        initSearchBar()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func onSearch() {
        //开始刷新
        var dict = ["act":"search", "type": searchType, "key": searchKey]
        manager.GET(URL_MC,
            parameters: dict,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.json = JSON(responseObject)
                self.hud?.hide(true)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.hud?.hide(true)
        })
    }
    
    func initSearchBar() {
        searchBar = UISearchBar(frame: CGRectMake(5, 5, self.view.frame.width-10, 35))
        searchBar.delegate = self
        searchBar.placeholder = "搜索贴子或麦友"
        searchBar.showsCancelButton = true
        nav?.navigationBar.addSubview(searchBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.searchBar.hidden = false
        nav?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
//
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
//
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        println("取消搜索,返回")
        self.nav?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchKey = searchText
        
        onSearch()
    }
    
    /**
    初始化TableView
    */
    func setupTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 35, self.view.bounds.size.width, self.view.bounds.size.height-35), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        tableView.backgroundView = nil //这个可以改背影
        tableView.scrollsToTop = false
        
        self.view.addSubview(tableView)
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
            if !searchKey.isEmpty {
                MCUtils.showEmptyView(self.tableView, aImg: Load_Empty!, aText: "没有找到你想要的信息,换个条件试试?")
            } else {
                MCUtils.showEmptyView(self.tableView, aImg: Load_Empty!, aText: "小麦可以帮你找到你想看的贴子和麦友哦")
            }
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.searchBar.hidden = true
        if "talk" == searchType {
            let id = self.datasource[indexPath.row]["id"].stringValue
            TalkDetail.showTalkDetailPage(self.nav, id: id)
        } else {
            let id = self.datasource[indexPath.row]["id"].intValue
            MCUtils.openOtherZone(self.nav, userId: id)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if "talk" == searchType {
            var cell = tableView.dequeueReusableCellWithIdentifier("mainSubCell") as? mainSubCell
            
            if cell == nil {
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainSubCell", owner: self, options: nil)
                cell = nib.lastObject as? mainSubCell
            }
            let d = self.datasource[indexPath.row] as JSON
            cell?.update(d)
            return cell!
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("SearchUserCell") as? SearchUserCell
            
            if cell == nil {
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("SearchUserCell", owner: self, options: nil)
                cell = nib.lastObject as? SearchUserCell
            }
            let d = self.datasource[indexPath.row] as JSON
            cell?.update(d)
            return cell!
        }
    }
    
    /**
    初始化搜索结果分类
    
    :returns: Void
    */
    func initSegmentedControl() {
        segmentedControl = HMSegmentedControl(sectionTitles: ["贴子", "麦友"])
        segmentedControl.frame = CGRectMake(0, 64, self.view.frame.size.width, 35)
        
        
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
        switch (sender.selectedSegmentIndex) {
        case 0:
            searchType = "talk"
        default:
            searchType = "people"
        }
        
        if !searchKey.isEmpty {
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud?.labelText = MCUtils.TEXT_SEARCH
            onSearch()
        }
    }

}
