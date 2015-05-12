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
    var hud: MBProgressHUD?
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                if let d = self.json["dataObject", "data"].array {
                    self.datasource = d
                }
            }
        }
    }
    
    var datasource: Array<JSON>! = Array() {
        didSet {
            self.collectionView!.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        self.collectionView?.allowsMultipleSelection = false
        self.collectionView?.backgroundColor = UIColor(hexString: "#EDF1F2")
        // Do any additional setup after loading the view.
        self.collectionView!.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        
        if isFirstLoad {
            loadDataWithoutMJRefresh()
        }
    }
    
    func loadDataWithoutMJRefresh() {
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud?.labelText = MCUtils.TEXT_LOADING
        loadNewData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadNewData() {
        //开始刷新
        
        var dict = ["act":"attentionUser", "id": appUserIdSave, "page": 1]
        manager.GET(URL_MC,
            parameters: dict,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                //println(responseObject)
                self.isFirstLoad = false
                self.json = JSON(responseObject)
                self.collectionView?.header.endRefreshing()
                self.hud?.hide(true)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.collectionView!.header.endRefreshing()
                self.hud?.hide(true)
                MCUtils.showCustomHUD(self.view, title: "数据加载失败", imgName: "HUD_ERROR")
        })
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        if !self.datasource.isEmpty {
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
        self.selectUserId = cell.userId
        
        MCUtils.openOtherZone(self.nav, userId: selectUserId!)
    }
    
    func setNavi(navi: UINavigationController?) {
        self.nav = navi
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
