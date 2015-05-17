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
    var chatRoomId: String!
    var chatRoomName: String!
    
    @IBOutlet weak var roundProgressView: MFRoundProgressView!
    @IBOutlet weak var userHeadImg: UIImageView!
    @IBOutlet weak var userLastSay: UILabel!
    @IBOutlet weak var times: UIButton!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var imgView: UIView!
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
        
        roundProgressView.userInteractionEnabled = true
        var tapRoundHead = UITapGestureRecognizer(target: self, action: "openMineSB")
        roundProgressView.addGestureRecognizer(tapRoundHead)
        
        imgView.userInteractionEnabled = true
        var tapChatRoom = UITapGestureRecognizer(target: self, action: "joinChatRoom")
        imgView.addGestureRecognizer(tapChatRoom)
        
        bag.addTarget(self, action: "openBackPacker", forControlEvents: UIControlEvents.TouchUpInside)
        //登录按钮
        btnLogin = UIButton(frame: CGRectMake(75, 30, 100, 30))
        btnLogin.setTitle("登录更精彩", forState: .Normal)
        btnLogin.titleLabel?.font = UIFont(name: btnLogin.titleLabel!.font.fontName, size: 14)
        btnLogin.backgroundColor = UIColor(hexString: "#30A243")
        btnLogin.layer.cornerRadius = 8
        btnLogin.addTarget(self, action: "userLogin", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnLogin)
        btnLogin.hidden = true
        
        //背包图片,文字位置
        // Do any additional setup after loading the view.
    }
    
    @IBAction func joinChatRoom() {
        MobClick.event("mainView", attributes: ["Type":"ChatRoom"])
        // 启动聊天室，与启动单聊等类似
        var temp: RCChatViewController = customChatViewController()
        temp.hidesBottomBarWhenPushed = true
        temp.currentTarget = self.chatRoomId;
        temp.conversationType = .ConversationType_CHATROOM; // 传入聊天室类型
        temp.enableSettings = false;
        temp.currentTargetName = self.chatRoomName;
        
        self.nav?.pushViewController(temp, animated: true)
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
            
            //leftVC
            var leftCV = (MCUtils.leftView as! leftMenuViewController)
            leftCV.Avatar.sd_setImageWithURL(NSURL(string: user["headImg"].stringValue), placeholderImage: DefaultUserAvatar_big!, completed: {(img,_,_,_) in
                leftCV.Avatar.image = img
            })
            leftCV.username.text = user["nike"].stringValue
            leftCV.level.setTitle("LV."+String(user["level"].stringValue), forState: .Normal)
        } else {
            self.roundProgressView.imageUrl = "1" //任意值都可以
            self.nickname.hidden = true
            self.level.hidden = true
            self.locationCity.hidden = true
            self.bag.hidden = true
            self.btnLogin.hidden = false
        }
        //聊天室
        self.chatRoomId = chat["id"].stringValue
        self.chatRoomName = chat["name"].stringValue
        var time = (chat["endTime"].stringValue as NSString).substringToIndex(16)
        self.times.setTitle(time, forState: .Normal)
        self.chatTitle.text = self.chatRoomName
        self.chatTitle.sizeOfMultiLineLabel()
        self.userHeadImg.sd_setImageWithURL(NSURL(string: chat["headImg"].stringValue), placeholderImage: UIImage(named: "SmallAvatar"))
        self.userHeadImg.layer.masksToBounds = true
        self.userHeadImg.layer.cornerRadius = 10
        self.userLastSay.text = chat["lastSpeak"].stringValue
        self.imageV.sd_setImageWithURL(NSURL(string: chat["icon"].stringValue), placeholderImage: UIImage(named: "loading"))
        
    }
    
    @IBAction func userLogin() {
        MobClick.event("mainView", attributes: ["Type":"Login"])
        NewLogin.showUserLoginView(self.nav, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
    }
    
    @IBAction func openBackPacker() {
        MobClick.event("mainView", attributes: ["Type":"MyBag"])
        if appUserIdSave != 0 {
            MCUtils.openBackPacker(self.nav!, userId: appUserIdSave)
        } else {
            MCUtils.showCustomHUD("亲,你要登录麦块后才能打开背包,先去登录吧", aType: .Warning)
        }
    }
    
    func setNavi(navi: UINavigationController?) {
        self.nav = navi
    }
    
    @IBAction func openMineSB() {
        println("打开个人中心")
        MobClick.event("mainView", attributes: ["Type":"MineCenter"])
        //mineFrm = mineTableViewController.initializationMine() as! mineTableViewController
        if appUserIdSave != 0 {
            mineFrm = mineTableViewController()
            mineFrm.hidesBottomBarWhenPushed = true
            self.nav?.pushViewController(mineFrm, animated: true) //这个显示效果有问题
        } else {
            MobClick.event("mainView", attributes: ["Type":"Login"])
            NewLogin.showUserLoginView(self.nav, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
        }
    }
    
    @IBAction func openCityList(sender: UIButton) {
        println("打开城市列表")
        MobClick.event("mainView", attributes: ["Type":"CityList"])
        cityList = cityListViewController()
        cityList.hidesBottomBarWhenPushed = true
        cityList.Delegate = self
        self.nav?.pushViewController(cityList, animated: true)
    }
    
    func onSelectCity(selectedCity: String) {
        //保存到本地
        Defaults[D_USER_ADDR] = selectedCity
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
        
        self.roundProgressView.percent = CGFloat(appUserProcess)
        self.roundProgressView.imageUrl = appUserPic
        self.nickname.text = appUserNickName
        self.level.setTitle("LV.\(appUserLevel)", forState: .Normal)
        var city = appUserAddr != "" ? appUserAddr : "未定位"
        self.locationCity.setTitle(city, forState: .Normal)
        
        //leftViewController
        var leftCV = (MCUtils.leftView as! leftMenuViewController)
        leftCV.username.hidden = false
        leftCV.level.hidden = false
        leftCV.btnLogin.hidden = true

        leftCV.Avatar.sd_setImageWithURL(NSURL(string: appUserPic), placeholderImage: DefaultUserAvatar_big!, completed: {(img,_,_,_) in
            leftCV.Avatar.image = img
        })
        leftCV.username.text = appUserNickName
        leftCV.level.setTitle("LV."+String(appUserLevel), forState: .Normal)
        leftCV.btnLogin.hidden = true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.roundProgressView.percent = CGFloat(appUserProcess)
        self.roundProgressView.imageUrl = appUserPic
        self.nickname.text = appUserNickName
        self.level.setTitle("LV.\(appUserLevel)", forState: .Normal)
        self.locationCity.setTitle(appUserAddr, forState: .Normal)
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
