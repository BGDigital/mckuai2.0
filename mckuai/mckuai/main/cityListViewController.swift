//
//  cityListViewController.swift
//  selectCity
//
//  Created by XingfuQiu on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

protocol CityProtocol {
    func onSelectCity(selectedCity: String)
}

class cityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var cities: NSDictionary!
    var keys: NSArray!
    var tableView: UITableView!
    var Delegate: CityProtocol?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.navigationItem.hidesBackButton = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        getCityData()
        setupTableView()
    }

    func getCityData() {
        var path = NSBundle.mainBundle().pathForResource("citydict", ofType: "plist")
        self.cities = NSDictionary(contentsOfFile: path!)
        var temp: NSArray = self.cities.allKeys
        //排序
        keys = temp.sortedArrayUsingSelector(Selector("compare:"))
    }
    
    func setupTableView() {
        
        var head = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 80))
        head.backgroundColor = UIColor.redColor()
        
        var label = UILabel(frame: CGRectMake(5, (head.bounds.size.height - 20) / 2, 200, 20))
        label.text = "当前城市:成都"
        label.textColor = UIColor.whiteColor()
        head.addSubview(label)
        
        var btn = UIButton(frame: CGRectMake(head.bounds.size.width-80, (head.bounds.size.height - 20) / 2, 60, 20))
        btn.setTitle("定位", forState: .Normal)
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btn.addTarget(self, action: "getLoactionCity", forControlEvents: UIControlEvents.TouchUpInside)
        head.addSubview(btn)
        
        self.tableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        //        var bg = UIImageView(image: UIImage(named: "Image"))
        tableView.backgroundView = nil //这个可以改背影
        tableView.scrollsToTop = false
        
        //Search Bar
//        var searchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 40))
//        searchBar.searchBarStyle = UISearchBarStyle.Default
//        searchBar.placeholder = "查找城市"
//        searchBar.delegate = self
//        searchBar.showsCancelButton = false
//        searchBar.keyboardType = UIKeyboardType.Default
//        
//        tableView.tableHeaderView = searchBar
        tableView.tableHeaderView = head
        self.view.addSubview(tableView)
    }
    
    @IBAction func getLoactionCity() {
        UIAlertView(title: nil, message: "点了这个就定位", delegate: self, cancelButtonTitle: "确定").show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var key: AnyObject = keys.objectAtIndex(section)
        var citySection: AnyObject? = cities.objectForKey(key)
        
        return citySection!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var key: AnyObject = self.keys.objectAtIndex(indexPath.section)
        var cell = tableView.dequeueReusableCellWithIdentifier("CITYCELL") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "CITYCELL")
        }
        
        cell?.textLabel?.text = self.cities.objectForKey(key)?.objectAtIndex(indexPath.row) as? String
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var key = keys.objectAtIndex(section) as! String
        return key
    }

    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return keys as! [AnyObject]
     }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        var key: AnyObject = self.keys.objectAtIndex(indexPath.section)
        Delegate?.onSelectCity((self.cities.objectForKey(key)?.objectAtIndex(indexPath.row) as? String)!)
        //back
        self.dismissViewControllerAnimated(true, completion: nil)
        //self.navigationController?.popViewControllerAnimated(true)
    }
}
