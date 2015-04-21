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
    
    var data = NSMutableArray()
    var tableView: UITableView!
    
    class func mainRoot()->UIViewController{
        var main = UIStoryboard(name: "home", bundle: nil).instantiateViewControllerWithIdentifier("mainViewController") as! UIViewController
        main.tabBarItem = UITabBarItem(title: "首页", image: UIImage(named: "first_normal"), selectedImage: UIImage(named: "first_selected"))
        return UINavigationController(rootViewController: main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem.badgeValue = "3"
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.212, green: 0.804, blue: 0.380, alpha: 1.00)
            
        
        setupTableView()
//        self.data = NSMutableArray()
        loadNewData()
    }
    
    func setupTableView() {
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Plain)
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
        
        //使 Cell 重用 (不知道为什么,一重用就会出现错位)
//        var bundle: NSBundle = NSBundle.mainBundle()
//        var nib: UINib = UINib(nibName: "mainTableViewCell", bundle: bundle)
//        tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
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
    
    //加载数据,刷新
    func loadNewData() {
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
                
                self.tableView.header.endRefreshing()
                self.tableView.reloadData()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.header.endRefreshing()
                self.showCustomHUD(self.view, title: "数据加载失败", imgName: "Guide")
        })
        
    }
    
    //上拉加载更多数据
    func loadMoreData() {
        //1.添加假数据
        for a in 0...5{
            self.data.insertObject(a, atIndex: 0)
        }
        //2.模拟3秒后刷新表格UI
        Async.main(after: 3, block: {
            self.tableView.reloadData()
            //拿到数据,结束刷新
            self.tableView.footer.endRefreshing()
            self.tableView.footer.noticeNoMoreData()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 192
        } else {
            return 88
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.data.count > 10 {
            self.tableView.footer.hidden = false
        }
        return self.data.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            //var cell = tableView.cellForRowAtIndexPath(indexPath) as? mainTableViewCell
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? mainTableViewCell
            if cell == nil {
                //如果没有cell就新创建出来
                println("Create mainTableViewCell, one......:\(indexPath.row)")
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainTableViewCell", owner: self, options: nil)
                cell = nib.lastObject as? mainTableViewCell
            }
            cell!.title.text = self.data[indexPath.row] as? String
            cell?.imageV.image = UIImage(named: "placeholder")
            cell?.imageV.frame = CGRectMake(12, 12, 351, 140)
            //cell?.imageV.sd_setImageWithURL(NSURL(string: "http://c.hiphotos.baidu.com/image/pic/item/86d6277f9e2f07084281b301eb24b899a901f22f.jpg"), placeholderImage: UIImage(named: "placeholderImage"))
            //println("cell?.imageV.frame:\(cell?.imageV.frame)")
            return cell!
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("mainSubCell") as? mainSubCell
            
            if cell == nil {
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainSubCell", owner: self, options: nil)
                cell = nib.lastObject as? mainSubCell
            }
            
            cell?.title.text = self.data[indexPath.row] as? String
            return cell!
//            var cell = tableView.dequeueReusableCellWithIdentifier("SUBTITLECELL") as? UITableViewCell
//            
//            if cell == nil {
//                println("Create mainTableViewCell, two......:\(indexPath.row)")
//                cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "SUBTITLECELL")
//            }
//            
//            cell?.textLabel?.text = self.data[indexPath.row] as? String
//            cell?.detailTextLabel?.text = "这里显示详细信息"
//            cell?.imageView?.sd_setImageWithURL(NSURL(string: "http://c.hiphotos.baidu.com/image/pic/item/86d6277f9e2f07084281b301eb24b899a901f22f.jpg"), placeholderImage: UIImage(named: "Guide"))
//            return cell!
        }
    }

}
