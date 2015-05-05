//
//  friendsViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/28.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

let reuseIdentifier = "CollectionCell"

class friendsViewController: UICollectionViewController {

    var otherZone: otherViewController!
    var nav: UINavigationController?
    var isFirstLoad = true
    var manager = AFHTTPRequestOperationManager()
    var selectUserId: Int?
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
            self.collectionView!.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.collectionView?.allowsMultipleSelection = false
        self.collectionView?.backgroundColor = UIColor(hexString: "#EDF1F2")
        // Do any additional setup after loading the view.
        self.collectionView!.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        
        if isFirstLoad {
            self.collectionView!.header.beginRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNewData() {
        //开始刷新
        self.isFirstLoad = false
        var dict = ["act":"attentionUser", "id": 6, "page": 1]
        manager.GET(URL_MC,
            parameters: dict,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println(responseObject)
                self.json = JSON(responseObject)
                self.collectionView?.header.endRefreshing()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.collectionView!.header.endRefreshing()
                MCUtils.showCustomHUD(self.view, title: "数据加载失败", imgName: "Guide")
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if self.datasource != nil {
            return self.datasource.count
        } else {
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CollectionCell
        
        // Configure the cell
        cell.backgroundColor = UIColor(hexString: "#EDF1F2")
        let j = self.datasource[indexPath.row] as JSON
        cell.update(j)
        
        return cell
    }
    /*
    //这个地方是添加CollectionView的footer
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var v = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "FooterView", forIndexPath: indexPath) as! UICollectionReusableView
        return v
    }
    */
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CollectionCell
        cell.selected = true
        cell.contentView.layer.borderColor = UIColor.redColor().CGColor
        cell.contentView.layer.borderWidth = 2
        self.selectUserId = cell.userId
        showPopWindow()
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? CollectionCell {
            cell.selected = false
            cell.contentView.layer.borderColor = UIColor.clearColor().CGColor
            cell.contentView.layer.borderWidth = 2
        }
    }
    
    //显示弹出出的选项
    func showPopWindow() {
        var view = UIView(frame: CGRectMake(0, self.view.bounds.size.height-50, self.view.bounds.size.width, 50))
        view.backgroundColor = UIColor.blackColor()
        
        //button1
        var btn1 = UIButton(frame: CGRectMake(0, 0, self.view.bounds.size.width/2, 50))
        btn1.setImage(UIImage(named: "backpacker_bag"), forState: .Normal)
        btn1.setTitle("去TA的家", forState: .Normal)
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
    
    func setNavi(navi: UINavigationController?) {
        self.nav = navi
    }
    
    @IBAction func btn1Click() {
        otherZone = otherViewController()
        otherZone.UserId = self.selectUserId
        self.nav?.pushViewController(otherZone, animated: true)
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
