//
//  UserRegister.swift
//  mckuai
//
//  Created by 陈强 on 15/2/2.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class UserRegister: UIViewController,UITextFieldDelegate {
    var manager = AFHTTPRequestOperationManager()
    
    @IBOutlet weak var nickName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var userName: UITextField!
    
    var json: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        passWord.delegate = self
        nickName.delegate = self
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard(){
        userName.resignFirstResponder()
        passWord.resignFirstResponder()
        nickName.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField.text == "注册邮箱" && textField.tag == 10){
            textField.text = ""
        }
        if (textField.text == "密码" && textField.tag == 20){
            textField.text = ""
            textField.secureTextEntry = true
        }
        if (textField.text == "用户昵称" && textField.tag == 30){
            textField.text = ""
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
        if (textField.text == "" && textField.tag == 30) {
            textField.text = "用户昵称"
        }
        textField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func registerUserInfo(sender: UIButton) {
        println("注册用户")
        
        if(self.userName.text == nil || self.passWord.text == nil || self.nickName.text == nil || self.userName.text == "注册邮箱" || self.passWord.text == "密码" || self.nickName.text == "用户昵称" ){
            var alertView = UIAlertView(title: "输入的信息不能为空", message: "", delegate: self, cancelButtonTitle: "确定")
            alertView.show()
            return
        }
        
        let params = [
            "userName": self.userName.text,
            "passWord": self.passWord.text,
            "nickName": self.nickName.text,
        ]
        
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "注册中"
        
        manager.POST(register_url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                
                if "ok" == json["state"].stringValue {
                    var userId = json["dataObject"].intValue
                    //保存登录信息
                    var userDefault = NSUserDefaults.standardUserDefaults()
                    userDefault.setInteger(userId, forKey: "appUserIdSave")
                    userDefault.synchronize()
                    appUserIdSave = userId
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }else{
                    hud.hide(true)
                    self.showCustomHUD(self.view, title: "注册失败,请使用QQ登录", imgName: "Guide")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                hud.hide(true)
                self.showCustomHUD(self.view, title: "注册失败,请使用QQ登录", imgName: "Guide")
        })
        
        
//        APIClient.sharedInstance.mckuaiRegisterByPost(self.view, userName: self.userName.text, passWord: self.passWord.text,nickName:self.nickName.text,success: { (json) -> Void in
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
////                self.navigationController?.popToRootViewControllerAnimated(true)
//                var msg = json["msg"].stringValue
//                var alertView = UIAlertView(title: msg, message: "", delegate: self, cancelButtonTitle: "确定")
//                alertView.show()
//            }
//            
//            }, failure: { (error) -> Void in })
    }
    
    class func showUserRegisterView(presentNavigator ctl:UINavigationController?){
        var userRegisterView = UIStoryboard(name: "UserRegister", bundle: nil).instantiateViewControllerWithIdentifier("userRegister") as! UserRegister
        if (ctl != nil) {
            ctl?.pushViewController(userRegisterView, animated: true)
        } else {
            ctl?.presentViewController(userRegisterView, animated: true, completion: nil)
        }
        
        
    }
    
}