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
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                if let d = self.json["dataObject", "data"].array {
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

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>

        setupTableView()
        if isFirstLoad {
            self.tableView.header.beginRefreshing()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNewData() {
        //开始刷新
        self.isFirstLoad = false
        var dict = ["act":"collectTalk", "id": 6, "page": 1]
        manager.GET(URL_MC,
            parameters: dict,
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
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 118
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.datasource != nil {
            self.tableView.backgroundView = nil
            return self.datasource.count
        } else {
            MCUtils.showEmptyView(self.tableView)
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
