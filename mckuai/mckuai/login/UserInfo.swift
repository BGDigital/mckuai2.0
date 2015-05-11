//
//  UserInfo.swift
//  mckuai
//
//  Created by 陈强 on 15/5/8.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class UserInfo: UIViewController, UIAlertViewDelegate {
    var manager = AFHTTPRequestOperationManager()
    
    @IBOutlet weak var headImg_view: UIView!


    @IBOutlet weak var userName_view: UIView!
    
    @IBOutlet weak var passWord_view: UIView!
    
    @IBOutlet weak var addr_view: UIView!
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var addr: UILabel!
    var image:UIImageView!
    var user:JSON?{
        didSet{
            if let u = user{
                userName.text = u["nike"].stringValue

                addr.text = u["addr"].stringValue
                
                image = UIImageView(frame: CGRectMake(self.view.frame.size.width-80-25, 44+22+8, 80, 80))
                image.sd_setImageWithURL(NSURL(string: u["headImg"].stringValue))
                image.layer.masksToBounds=true;
                image.layer.cornerRadius = image.frame.size.width/2
                self.view.addSubview(image)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headImg.hidden = true
        
        loadData(true)
        var toHeadImg = UITapGestureRecognizer(target: self, action: "toHeadImgFunction")
        self.headImg_view.addGestureRecognizer(toHeadImg)
        
        var toUserName = UITapGestureRecognizer(target: self, action: "toUserNameFunction")
        self.userName_view.addGestureRecognizer(toUserName)
        
        var toPassWord = UITapGestureRecognizer(target: self, action: "toPassWordFunction")
        self.passWord_view.addGestureRecognizer(toPassWord)
        
        var toAddr = UITapGestureRecognizer(target: self, action: "toAddrFunction")
        self.addr_view.addGestureRecognizer(toAddr)
    }
    
    func toHeadImgFunction() {
        Avatar.changeAvatar(self.navigationController!,url:user!["headImg"].stringValue)
    }
    
    func toUserNameFunction() {
        Nickname.changeNickname(self.navigationController!,uname:user!["nike"].stringValue)
    }
    
    func toPassWordFunction() {
        if user!["userType"].stringValue == "qq"{
            UIAlertView(title: "提示", message: "QQ用户不能修改密码", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        Profile_Password.changePass(self.navigationController!)
    }
    
    func toAddrFunction() {
        
    }
    override func viewWillAppear(animated: Bool) {
//        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.lt_reset()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        loadData(false)
    }
    
    func loadData(showHUD: Bool){
        var uid = appUserIdSave
//        uid = 3
        
        if uid == 0  {
            self.navigationController?.popViewControllerAnimated(false)
        }
        
        let params = [
            "userId":String(uid)
        ]
        
        manager.POST(getUser_url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                
                if "ok" == json["state"].stringValue {
                    self.user = json["dataObject"]
                }else{
                    MCUtils.showCustomHUD(self.view, title: "个人信息获取失败", imgName: "Guide")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                MCUtils.showCustomHUD(self.view, title: "个人信息获取失败", imgName: "Guide")
        })
    }
    
    @IBAction func exit(){
        UIAlertView(title: "提示", message: "你确定要注销吗？", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "确定").show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            var userDefault = NSUserDefaults.standardUserDefaults()
            userDefault.removeObjectForKey("appUserIdSave")
            appUserIdSave = 0
            isLoginout = true
            println("用户已退出！")
//            self.navigationController?.popToRootViewControllerAnimated(true)
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    class func showUserInfoView(ctl:UINavigationController?){
        var userInfo = UIStoryboard(name: "UserInfo", bundle: nil).instantiateViewControllerWithIdentifier("userInfo") as! UserInfo
        if (ctl != nil) {
            ctl?.pushViewController(userInfo, animated: true)
        } else {
            MCUtils.mainNav?.pushViewController(userInfo, animated: true)
        }
        
    }
    
}