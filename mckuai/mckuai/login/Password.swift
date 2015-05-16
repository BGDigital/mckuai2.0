//
//  Password.swift
//  mckuai
//
//  Created by 夕阳 on 15/2/2.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class Profile_Password:UIViewController,UIGestureRecognizerDelegate {
    var manager = AFHTTPRequestOperationManager()
    @IBOutlet weak var old_pass: UITextField!
    @IBOutlet weak var new_pass: UITextField!
    @IBOutlet weak var ensure_pass: UITextField!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        var barSize = self.navigationController?.navigationBar.frame

        initNavigation()
        
    }
    
    func initNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00))
        var back = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "backToPage")
        back.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = back
        self.navigationController?.interactivePopGestureRecognizer.delegate = self    // 启用 swipe back
        
        var sendButton = UIBarButtonItem()
        sendButton.title = "保存"
        sendButton.target = self
        sendButton.action = Selector("save")
        self.navigationItem.rightBarButtonItem = sendButton
    }
    
    func backToPage() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func save(){
        let oldpass = old_pass.text
        let newpass = new_pass.text
        let ensure = ensure_pass.text
        
        if oldpass == "" || newpass == "" || ensure == ""{
            TSMessage.showNotificationWithTitle("密码不能为空", type: .Error)
            return
        }
        if newpass != ensure {
            TSMessage.showNotificationWithTitle("两次密码输入不一致", type: .Error)
            return
        }
        let dic = [
        "flag":NSString(string: "password"),
        "userId":appUserIdSave,
        "old_password":oldpass,
        "new_password":newpass
        ]
        
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "保存中"
        
        manager.POST(saveUser_url,
            parameters: dic,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                
                if "ok" == json["state"].stringValue {
                    hud.hide(true)
                    MCUtils.showCustomHUD(self.view, title: "保存信息成功", imgName: "HUD_OK")
                    isLoginout = true
                    self.navigationController?.popViewControllerAnimated(true)
                }else{
                    hud.hide(true)
                    MCUtils.showCustomHUD(self.view, title: "保存信息失败", imgName: "HUD_ERROR")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                hud.hide(true)
                MCUtils.showCustomHUD(self.view, title: "保存信息失败", imgName: "HUD_ERROR")
        })
        
//        APIClient.sharedInstance.modifiyUserInfo(self.view, ctl: self.navigationController, param: dic, success: {
//            (res:JSON?) in
//            }, failure: {
//                (NSError) in
//        })
    }
    
    class func changePass(ctl:UINavigationController){
        var edit_pass = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("pass_edit") as! Profile_Password
        
        ctl.pushViewController(edit_pass, animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("userInfoSetPassWord")
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("userInfoSetPassWord")
    }
    
    
}