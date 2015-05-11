//
//  Profile.swift
//  mckuai
//
//  Created by 夕阳 on 15/2/3.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

var isLoginout:Bool = false

class Profile:UIViewController, UIAlertViewDelegate {
    var manager = AFHTTPRequestOperationManager()

    @IBOutlet weak var password_view: UIView!
    @IBOutlet weak var myview: UIView!
    @IBOutlet weak var useravatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    var user:JSON?{
        didSet{
            if let u = user{
                username.text = u["nike"].stringValue
                self.useravatar.sd_setImageWithURL(NSURL(string: u["headImg"].stringValue))
            }
        }
    }
    override func viewDidLoad() {
        self.useravatar.layer.cornerRadius = 20
        loadData(true)
    }
    override func viewDidAppear(animated: Bool) {
        loadData(false)
    }
    func loadData(showHUD: Bool){
        var uid = appUserIdSave
        uid = 3
        
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
                    self.showCustomHUD(self.view, title: "个人信息获取失败", imgName: "Guide")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.showCustomHUD(self.view, title: "个人信息获取失败", imgName: "Guide")
        })
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
    
    

    class func loadProfile(ctl:UINavigationController){
        var profile = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("profile") as! Profile
        ctl.pushViewController(profile, animated: true)
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
            self.navigationController?.popToRootViewControllerAnimated(true)
//            self.navigationController?.popViewControllerAnimated(true)
//            self.tabBarController?.selectedIndex = 0
        }
    }
    
    @IBAction func toNick(){
        Nickname.changeNickname(self.navigationController!,uname:user!["nike"].stringValue)
    }
    
    @IBAction func toPass(){
        if user!["userType"].stringValue == "qq"{
            UIAlertView(title: "提示", message: "QQ用户不能修改密码", delegate: nil, cancelButtonTitle: "确定").show()
            return
        }
        Profile_Password.changePass(self.navigationController!)
    }
    @IBAction func toAvatar(){
        Avatar.changeAvatar(self.navigationController!,url:user!["headImg"].stringValue)
    }
}