//
//  cityListViewController.swift
//  selectCity
//
//  Created by XingfuQiu on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit
import CoreLocation

protocol CityProtocol {
    func onSelectCity(selectedCity: String)
}

class cityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {
    //用于定位服务管理类，它能够给我们提供位置信息和高度信息，也可以监控设备进入或离开某个区域，还可以获得设备的运行方向
    let locationManager : CLLocationManager = CLLocationManager()
    //这两个变量是用于反查城市的
    var geocoder : CLGeocoder = CLGeocoder()
    var cities: NSDictionary!
    var keys: NSArray!
    var tableView: UITableView!
    var Delegate: CityProtocol?
    var currentCity: UIButton!
    
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
        customNavBackButton()
    }
    
    func customNavBackButton() {
        //设置标题颜色
        self.navigationItem.title = "定位"
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        
        var back = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "backToMain")
        back.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = back
    }
    
    func backToMain() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    func getCityData() {
        var path = NSBundle.mainBundle().pathForResource("citydict", ofType: "plist")
        self.cities = NSDictionary(contentsOfFile: path!)
        var temp: NSArray = self.cities.allKeys
        //排序
        keys = temp.sortedArrayUsingSelector(Selector("compare:"))
    }
    
    func setupTableView() {
        
        var head = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 40))
        head.backgroundColor = UIColor.whiteColor()
        var lb = UILabel(frame: CGRectMake(5, (head.bounds.size.height - 20) / 2, 100, 20))
        lb.text = "GPS定位城市"
        lb.font = UIFont(name: lb.font.fontName, size: 12)
        lb.textColor = UIColor(hexString: "#B3B4B5")
        head.addSubview(lb)
        
        currentCity = UIButton(frame: CGRectMake(head.bounds.size.width-160, (head.bounds.size.height - 20) / 2, 140, 20))
        currentCity.setTitle("点击定位", forState: .Normal)
        currentCity.setTitleColor(UIColor(hexString: "#32C561"), forState: .Normal)
        currentCity.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        currentCity.titleLabel?.font = UIFont(name: currentCity.titleLabel!.font.fontName, size: 12)
        currentCity.addTarget(self, action: "getLoactionCity", forControlEvents: UIControlEvents.TouchUpInside)
        head.addSubview(currentCity)
        
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
        initLocationManager()
    }
    
    func initLocationManager() {
        println("初始化LocationManager...")
        //这句一定要加上,只要需要的时候使用定位
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        //设备使用电池供电时最高的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        //开始定位
        locationManager.startUpdatingLocation()
    }
    //定位
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        //显示经纬度
        if let currentLocation : CLLocation = locations[0] as? CLLocation {
            var stringLongitude : NSString = NSString(format: "%0.8f", currentLocation.coordinate.longitude)
            var stringLatitude : NSString = NSString(format: "%0.8f", currentLocation.coordinate.latitude)
            println("\(stringLatitude),\(stringLongitude)")
        }
        //取到位置了,停止获取位置
        locationManager.stopUpdatingLocation()
        //开始反查地址
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                //println(“Reverse geocoder failed with error” + error.localizedDescription)
                println("Reverse geocode failed with error")
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the date recieved from geocoder")
            }
            
        })
    }
    //显示需要显示的信息
    func displayLocationInfo(placemark: CLPlacemark) {
        /*
        name:市民广场
        country:中国
        postalCode:(null)
        ISOcountryCode:CN
        ocean:(null)
        inlandWater:(null)
        locality:广东省
        subLocality:(null)
        administrativeArea:深圳市
        subAdministrativeArea:福田区
        thoroughfare:市民广场
        subThoroughfare:(null)
        */
        
        var tempString : String = ""
        //城市
        if(placemark.locality != nil){
            tempString = tempString +  placemark.locality + "\n"
            self.currentCity.setTitle(placemark.locality, forState: .Normal)
            //保存到本地
            Delegate?.onSelectCity(placemark.locality)
        }
        //邮编
        if(placemark.postalCode != nil){
            tempString = tempString +  placemark.postalCode + "\n"
        }
        //国家
        if(placemark.country != nil){
            tempString = tempString +  placemark.country + "\n"
        }
        println(tempString)
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println("locationManager,didFailWithError %@", error)
        var errorAlert : UIAlertView = UIAlertView(title: "Error", message: "Failed to get your location", delegate: nil, cancelButtonTitle: "OK")
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
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
