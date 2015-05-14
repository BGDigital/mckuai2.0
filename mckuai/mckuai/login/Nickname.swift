//
//  Nickname.swift
//  mckuai
//
//  Created by 夕阳 on 15/2/2.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class Nickname:UIViewController,UIGestureRecognizerDelegate {
    var manager = AFHTTPRequestOperationManager()
    @IBOutlet weak var nick_editor: UITextField!

    var username:String?
    override func viewDidLoad() {
        initNavigation()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        var barSize = self.navigationController?.navigationBar.frame
        
        
        nick_editor.layer.borderColor = UIColor.whiteColor().CGColor
        if(username != nil){
            nick_editor.text = username
        }
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
    
    
    
    class func changeNickname(ctl:UINavigationController,uname:String!){
        var edit_nick = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("edit_nick") as! Nickname
        ctl.pushViewController(edit_nick, animated: true)
        edit_nick.username = uname
    }
    func save(){
        
        if let uname = nick_editor.text {
           if uname != ""{
            let dic = [
                "flag" : NSString(string: "name"),
                "userId": appUserIdSave,
                "nickName" : uname
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
           }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("userInfoSetNickName")
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("userInfoSetNickName")
    }
    
    
}