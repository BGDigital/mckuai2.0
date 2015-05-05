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
    @IBOutlet weak var userHeadImg: UIImageView!
    @IBOutlet weak var userLastSay: UILabel!
    @IBOutlet weak var times: UIButton!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var bag: UIButton!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var level: UIButton!
    @IBOutlet weak var locationCity: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if let city = Defaults[D_CURRENTCITY].string {
            locationCity.setTitle(city, forState: .Normal)
        } else {
            locationCity.setTitle("未定位", forState: .Normal)
        }
        // Do any additional setup after loading the view.
    }
    
    func setData(user: JSON!, chat: JSON!) {
        
        //用户信息
        var p = user["process"].floatValue * 100
        self.roundProgressView.progressLineWidth = 1
        self.roundProgressView.progressColor = UIColor(hexString: "#32FD2F")!
        self.roundProgressView.progressBackgroundColor = UIColor.whiteColor()
        self.roundProgressView.percent = CGFloat(p)
        self.roundProgressView.imageUrl = user["headImg"].stringValue
        self.nickname.text = user["nike"].stringValue
        self.level.setTitle(user["level"].stringValue, forState: .Normal)
        
        //聊天室
        self.times.setTitle(chat["insertTime"].stringValue, forState: .Normal)
        self.chatTitle.text = chat["title"].stringValue
        self.chatTitle.sizeOfMultiLineLabel()
        self.userHeadImg.sd_setImageWithURL(NSURL(string: chat["HeadImg"].stringValue), placeholderImage: UIImage(named: "Guide"))
        self.userLastSay.text = chat["speak"].stringValue
        self.imageV.sd_setImageWithURL(NSURL(string: chat["icon"].stringValue), placeholderImage: UIImage(named: "Image"))
        
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
        Defaults[D_CURRENTCITY] = selectedCity
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
