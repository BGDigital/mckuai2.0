//
//  mainHeaderViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mainHeaderViewController: UIViewController, CityProtocol {
    
    var cityList: cityListViewController!
    var mineFrm: mineTableViewController!
    var backpacker: backpackerViewController!
    var nav: UINavigationController?
    
    @IBOutlet weak var roundProgressView: MFRoundProgressView!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var times: UIButton!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var bag: UIButton!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var level: UIButton!
    @IBOutlet weak var locationCity: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundProgressView.percent = 78
        roundProgressView.imageView = UIImageView(image: UIImage(named: "1024"))
        username.imageEdgeInsets = UIEdgeInsetsMake(10.0, 0.0, 0.0, 0.0)
        locationCity.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 3.0, 0.0, 0.0)
        
        //圆角背景
        level.backgroundColor = UIColor(hexString: "#30A243")!
        level.layer.cornerRadius = 10
        
        bag.setImage(UIImage(named: "backpacker_selected"), forState: .Selected)
        imageV.sd_setImageWithURL(nil, placeholderImage: UIImage(named: "placeholder"))
        
        //添加事件
        nickname.userInteractionEnabled = true
        var tapNickName = UITapGestureRecognizer(target: self, action: "openMineSB")
        nickname.addGestureRecognizer(tapNickName)
        var tapRoundHead = UITapGestureRecognizer(target: self, action: "openMineSB")
        roundProgressView.addGestureRecognizer(tapRoundHead)
        bag.addTarget(self, action: "openBackPacker", forControlEvents: UIControlEvents.TouchUpInside)
        
        if let city = Defaults["CurrentCity"].string {
            locationCity.setTitle(city, forState: .Normal)
        } else {
            locationCity.setTitle("未定位", forState: .Normal)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openBackPacker() {
        backpacker = backpackerViewController()
        backpacker.hidesBottomBarWhenPushed = true
        self.nav?.pushViewController(backpacker, animated: true)
    }
    
    func setNavi(navi: UINavigationController?) {
        self.nav = navi
    }
    
    @IBAction func openMineSB() {
        println("打开个人中心")
        //mineFrm = mineTableViewController.initializationMine() as! mineTableViewController
        
        mineFrm = mineTableViewController()
        mineFrm.hidesBottomBarWhenPushed = true
        self.nav?.pushViewController(mineFrm, animated: true) //这个显示效果有问题
    }
    
    @IBAction func openCityList(sender: UIButton) {
        println("打开城市列表")
        cityList = cityListViewController()
        cityList.hidesBottomBarWhenPushed = true
        cityList.Delegate = self
        self.nav?.pushViewController(cityList, animated: true)
    }
    
    func onSelectCity(selectedCity: String) {
        //保存到本地
        Defaults["CurrentCity"] = selectedCity
        locationCity.setTitle(selectedCity, forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
