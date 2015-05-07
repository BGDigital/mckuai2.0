//
//  UserLogin.swift
//  mckuai
//
//  Created by 陈强 on 15/2/2.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class UserLogin: UIViewController,UITextFieldDelegate,TencentSessionDelegate{
    
    var manager = AFHTTPRequestOperationManager()
    
    var rightButton:UIButton?
//    let ITEM_WIDTH:CGFloat = 45
//    let ITEM_HEIGHT:CGFloat = 45
    
    var tencentOAuth:TencentOAuth!
    var permissionsArray=["get_user_info","get_simple_userinfo"]
    
    var json: JSON!
    
    @IBOutlet weak var view_userName: UIView!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var mckuaiLogin: UIButton!
    @IBOutlet weak var qqLogin: UIButton!
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        super.viewDidLoad()
        qqLogin.setBackgroundImage(UIImage(named: "user_login_normal"), forState: UIControlState.Normal)
        qqLogin.setBackgroundImage(UIImage(named: "user_login_press"), forState: UIControlState.Highlighted)//按下去时,selected被选中时
        
        tencentOAuth = TencentOAuth(appId: tencentAppKey, andDelegate: self)
        
        
        userName.delegate = self
        passWord.delegate = self
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        
//        setViewLineStyle()
    }
    
    func setViewLineStyle() {
        self.view_userName.layer.masksToBounds = true;
        self.view_userName.layer.borderWidth = 1;
        self.view_userName.layer.borderColor = UIColor.lightGrayColor().CGColor;
    }


    @IBAction func registerUserFunc(sender: UIButton) {
        println("注册");
        UserRegister.showUserRegisterView(presentNavigator: self.navigationController)
    }
    
    func dismissKeyboard(){
        userName.resignFirstResponder()
        passWord.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "注册邮箱" && textField.tag == 10){
            textField.text = ""
        }
        if (textField.text == "密码" && textField.tag == 20){
            textField.text = ""
            textField.secureTextEntry = true
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField.text == "" && textField.tag == 10) {
            textField.text = "注册邮箱"
        }
        if (textField.text == "" && textField.tag == 20) {
            textField.secureTextEntry = false
            textField.text = "密码"
        }
        textField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    
    @IBAction func loginFunction(sender: UIButton) {
        if(sender.tag == 10) {
            println("普通登录")
            if(self.userName.text != nil && self.passWord.text != nil && self.userName.text != "注册邮箱" && self.passWord.text != "密码") {
                mckuaiLoginFunction()
            }else {
                var alertView = UIAlertView(title: "用户名或密码不能为空", message: "", delegate: self, cancelButtonTitle: "确定")
                alertView.show()
            }
            
        }else if(sender.tag == 20) {
            println("qq登录")
            
            tencentOAuth.authorize(permissionsArray,inSafari:false)
        }
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
    
    func mckuaiLoginFunction() {
        let params = [
            "userName":self.userName.text,
            "passWord":self.passWord.text,

        ]
        
        manager.POST(login_url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                println(responseObject)
                if "ok" == json["state"].stringValue {
                     var userId = json["dataObject"].intValue
                     //保存登录信息
                    Defaults["D_USERID"] = userId
                    //Defaults["D_NICKNAME"] =
                     appUserIdSave = userId
                    
                    //xingfuqiu
                    /*
                    let D_USERID = "appUserIdSave"
                    //用户昵称
                    let D_NIKENAME = "NikeName"
                    //用户等级
                    let D_LEVEL = "UserLevel"
                    //用户头像
                    let D_ARATAR = "UserAvatar"
                    //登录名-email
                    let D_LOGINNAME = "LoginName"
                    //登录密码
                    let D_LOGINPWD = "LoginPwd"
                    //是否记住登录信息(用户名,密码)
                    let D_ISREMEMBERME = "isRememberMe"
                    */
                    
                     self.navigationController?.popViewControllerAnimated(true)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.showCustomHUD(self.view, title: "登录失败", imgName: "HUD_ERROR")
        })

        
        
//        APIClient.sharedInstance.mckuaiLoginByPost(self.view, userName: self.userName.text, passWord: self.passWord.text,success: { (json) -> Void in
//            if json["state"].stringValue == "ok" {
//                var userId = json["dataObject"].intValue
//                //保存登录信息
//                var userDefault = NSUserDefaults.standardUserDefaults()
//                userDefault.setInteger(userId, forKey: "appUserIdSave")
//                userDefault.synchronize()
//                appUserIdSave = userId
//                isLoginout = true
//                //                    self.navigationController?.popViewControllerAnimated(true)
//                self.navigationController?.popToRootViewControllerAnimated(true)
//                
//            }else{
//                var msg = json["msg"].stringValue
//                var alertView = UIAlertView(title: msg, message: "", delegate: self, cancelButtonTitle: "确定")
//                alertView.show()
//            }
//            
//            }, failure: { (error) -> Void in })

    }

    func tencentDidLogin(){
        if (tencentOAuth.accessToken != nil)
        {
            tencentOAuth.getUserInfo()
        }else
        {
            println("登录不成功 没有获取accesstoken");
        }
    }
    
    func tencentDidNotLogin(cancelled:Bool){
        if (cancelled){
            println("用户取消登录")
        }else{
            println("登录失败")
        }
    }
    
    func tencentDidNotNetWork(){
        println("无网络连接，请设置网络")
    }
    
    func getUserInfoResponse(response:APIResponse){
        if(response.retCode == 0){
            var userInfo = response.jsonResponse;
            var accessToken = tencentOAuth.accessToken as String!
            var openId = tencentOAuth.openId as String!
            var nickName:String = userInfo["nickname"] as! String!
            var gender:String = userInfo["gender"] as! String!
            var headImg:String = userInfo["figureurl_qq_2"] as! String!
            println(nickName)
            
            let params = [
                "accessToken": accessToken,
                "openId": openId,
                "nickName": nickName,
                "gender": gender,
                "headImg": headImg,
            ]
            
            var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "登录中"
            
            manager.POST(qqlogin_url,
                parameters: params,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    var json = JSON(responseObject)
                    
                    if "ok" == json["state"].stringValue {
                        var userId = json["dataObject"].intValue
                        //保存登录信息
                        Defaults[D_USER_ID] = userId
                        appUserIdSave = userId
                        if let nav = self.navigationController {
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            MCUtils.mainNav?.popViewControllerAnimated(true)
                        }
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("Error: " + error.localizedDescription)
                    hud.hide(true)
                    self.showCustomHUD(self.view, title: "登录失败", imgName: "HUD_ERROR")
            })
            
            
            
//            APIClient.sharedInstance.qqLoginByPost(self.view, accessToken: accessToken, openId: openId, nickName: nickName, gender: gender, headImg: headImg,success: { (json) -> Void in
//                println(json)
//                if json["state"].stringValue == "ok" {
//                    println("从服务器登录成功")
//                    var userId = json["dataObject"].intValue
//                    //保存登录信息
//                    var userDefault = NSUserDefaults.standardUserDefaults()
//                    userDefault.setInteger(userId, forKey: "appUserIdSave")
//                    userDefault.synchronize()
//                    
//                    appUserIdSave = userId
//                    isLoginout = true
//                    self.navigationController?.popToRootViewControllerAnimated(true)
//
//                    
//                }else{
//                    var alertView = UIAlertView(title: "登录失败!请稍候再试", message: "", delegate: self, cancelButtonTitle: "确定")
//                    alertView.show()
//                }
//                
//                }, failure: { (error) -> Void in })
        }else{
            println(response.errorMsg)
        }
        
        
    }
    

    
    class func showUserLoginView(presentNavigator ctl:UINavigationController?){
        var userLoginView = UIStoryboard(name: "UserLogin", bundle: nil).instantiateViewControllerWithIdentifier("userLogin") as! UserLogin
        if (ctl != nil) {
            ctl?.pushViewController(userLoginView, animated: true)
        } else {
            MCUtils.mainNav?.pushViewController(userLoginView, animated: true)
        }
        
        
    }
}