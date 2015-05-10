//
//  mainHeaderViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mainHeaderViewController: UIViewController, CityProtocol, LoginProtocol {
    
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
    var btnLogin: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationCity.titleEdgeInsets = UIEdgeInsetsMake(-1.0, 3.0, 0.0, 0.0)
        
        //圆角背景
        level.backgroundColor = UIColor(hexString: "#30A243")
        level.layer.cornerRadius = 7
        
        bag.setImage(UIImage(named: "backpacker_selected"), forState: .Selected)
        imageV.sd_setImageWithURL(nil, placeholderImage: UIImage(named: "loading"))
        
        //用户头像
        self.roundProgressView.progressLineWidth = 1
        self.roundProgressView.progressColor = UIColor(hexString: "#32FD2F")!
        self.roundProgressView.progressBackgroundColor = UIColor.whiteColor()
        
        //添加事件
        nickname.userInteractionEnabled = true
        var tapNickName = UITapGestureRecognizer(target: self, action: "openMineSB")
        nickname.addGestureRecognizer(tapNickName)
        var tapRoundHead = UITapGestureRecognizer(target: self, action: "openMineSB")
        roundProgressView.addGestureRecognizer(tapRoundHead)
        bag.addTarget(self, action: "openBackPacker", forControlEvents: UIControlEvents.TouchUpInside)
        
        //登录按钮
        btnLogin = UIButton(frame: CGRectMake(75, 22, 100, 30))
        btnLogin.setTitle("登录更精彩", forState: .Normal)
        btnLogin.titleLabel?.font = UIFont(name: btnLogin.titleLabel!.font.fontName, size: 14)
        btnLogin.backgroundColor = UIColor(hexString: "#30A243")
        btnLogin.layer.cornerRadius = 8
        btnLogin.addTarget(self, action: "userLogin", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnLogin)
        btnLogin.hidden = true
        // Do any additional setup after loading the view.
    }
    
    func setData(user: JSON!, chat: JSON!) {
        
        //用户信息
        if user.type != .Null {
            self.nickname.hidden = false
            self.level.hidden = false
            self.locationCity.hidden = false
            self.bag.hidden = false
            self.btnLogin.hidden = true
            
            var p = user["process"].floatValue * 100
            self.roundProgressView.percent = CGFloat(p)
            self.roundProgressView.imageUrl = user["headImg"].stringValue
            self.nickname.text = user["nike"].stringValue
            self.level.setTitle("LV."+user["level"].stringValue, forState: .Normal)
            if !user["addr"].stringValue.isEmpty {
                locationCity.setTitle(user["addr"].stringValue, forState: .Normal)
            } else {
                locationCity.setTitle("未定位", forState: .Normal)
            }
        } else {
            self.roundProgressView.imageUrl = "1" //任意值都可以
            self.nickname.hidden = true
            self.level.hidden = true
            self.locationCity.hidden = true
            self.bag.hidden = true
            self.btnLogin.hidden = false
        }
        //聊天室
        self.times.setTitle(chat["insertTime"].stringValue, forState: .Normal)
        self.chatTitle.text = chat["title"].stringValue
        self.chatTitle.sizeOfMultiLineLabel()
        self.userHeadImg.sd_setImageWithURL(NSURL(string: chat["headImg"].stringValue), placeholderImage: UIImage(named: "Avatar"))
        self.userHeadImg.layer.masksToBounds = true
        self.userHeadImg.layer.cornerRadius = 10
        self.userLastSay.text = chat["speak"].stringValue
        self.imageV.sd_setImageWithURL(NSURL(string: chat["icon"].stringValue), placeholderImage: UIImage(named: "loading"))
        
    }
    
    @IBAction func userLogin() {
        UserLogin.showUserLoginView(presentNavigator: self.nav, aDelegate: self)
    }
    
    @IBAction func openBackPacker() {
        if appUserIdSave != 0 {
            MCUtils.openBackPacker(self.nav!, userId: appUserIdSave)
        } else {
            SCLAlertView().showWarning("提示", subTitle: "登录后才能打开背包,先登录吧", closeButtonTitle: "确定", duration: 0)
        }
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
    
    func onLoginSuccessfull() {
        println("登录成功,刷新界面,主界面")
        self.nickname.hidden = false
        self.level.hidden = false
        self.locationCity.hidden = false
        self.bag.hidden = false
        self.btnLogin.hidden = true
        
        self.roundProgressView.percent = 0
        self.roundProgressView.imageUrl = appUserPic
        self.nickname.text = appUserNickName
        self.level.setTitle("LV.0", forState: .Normal)
        
        //leftViewController
        var leftCV = (MCUtils.leftView as! leftMenuViewController)
        leftCV.username.hidden = false
        leftCV.level.hidden = false
        leftCV.btnLogin.hidden = true

        leftCV.Avatar.sd_setImageWithURL(NSURL(string: appUserPic), placeholderImage: UIImage(named: "Avatar"))
        leftCV.username.text = appUserNickName
        leftCV.level.setTitle("LV."+String(appUserLevel), forState: .Normal)
        leftCV.btnLogin.hidden = true
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
