//
//  mineTableViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mineTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    var tableView: UITableView!
    var head: mineHeadViewController!
    let NAVBAR_CHANGE_POINT:CGFloat = 50
    let url = "http://118.144.83.145:8081/user.do?act=message"
    var manager = AFHTTPRequestOperationManager()
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                if let d = self.json["dataObject", "message"].array {
                    self.datasource = d
                }
                self.User = self.json["dataObject", "user"] as JSON
                self.pageInfo = self.json["dataObject", "pageInfo"] as JSON
            }
            head.refreshHead(User)
            self.tableView.reloadData()
        }
    }
    var User: JSON!
    var pageInfo: JSON!
    var datasource: Array<JSON>!
    
    class func mainRoot()->UIViewController{
        var main = UIStoryboard(name: "mine", bundle: nil).instantiateViewControllerWithIdentifier("mineTableViewController") as! UIViewController
        return main
    }
    
    func setupViews() {
        self.tableView = UITableView(frame: CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height+64), style: UITableViewStyle.Plain)
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
        self.head = UIStoryboard(name: "mine", bundle: nil).instantiateViewControllerWithIdentifier("mineHeadViewController") as! mineHeadViewController
        tableView.tableHeaderView = self.head.view
        self.view.addSubview(tableView)
        
        self.tableView.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        self.tableView.addLegendFooterWithRefreshingBlock({self.loadMoreData()})
        self.tableView.footer.hidden = true
    }
    
    func loadNewData() {
        //开始刷新
        var param = ["id": 6, "page": 1]
        manager.GET(url,
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
        setupViews()
        
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.greenColor())
        
        //
        loadNewData()
    }
    
    func refreshTableView() {
        println("刷新TableView")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var color = UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00)
        var offsetY = scrollView.contentOffset.y
        if offsetY > NAVBAR_CHANGE_POINT {
            var alpha = 1 - (NAVBAR_CHANGE_POINT + 64 - offsetY) / 64
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
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
        return 100
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
            return 0
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as? messageCell
        
        if cell == nil {
            let nib: NSArray = NSBundle.mainBundle().loadNibNamed("messageCell", owner: self, options: nil)
            cell = nib.lastObject as? messageCell
        }
        let d = self.datasource[indexPath.row] as JSON
        cell?.update(d)
        // Configure the cell...

        return cell!
    }

}
