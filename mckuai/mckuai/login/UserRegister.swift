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
    
    var Delegate: LoginProtocol?
    
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
        
    @IBAction func registerUserInfo(sender: UIButton) {
        println("注册用户")
        
        MobClick.event("registerPage", attributes: ["type":"register","result":"all"])
        
        if(self.userName.text == nil || self.passWord.text == nil || self.nickName.text == nil || self.userName.text == "注册邮箱" || self.passWord.text == "密码" || self.nickName.text == "用户昵称" ){
            MCUtils.showCustomHUD("输入的信息不能为空", aType: .Warning)
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
                    MobClick.event("registerPage", attributes: ["type":"register","result":"success"])
                    //保存登录信息
//                    MCUtils.AnalysisUserInfo(json)
                    hud.hide(true)
                    MCUtils.showCustomHUD("注册成功,请登录", aType: .Success)
                    self.navigationController?.popViewControllerAnimated(true)
                    
                }else{
                    hud.hide(true)
                    MCUtils.showCustomHUD("注册失败,请使用QQ登录", aType: .Error)
                    MobClick.event("registerPage", attributes: ["type":"register","result":"error"])
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                hud.hide(true)
                MCUtils.showCustomHUD("注册失败,请使用QQ登录", aType: .Error)
                MobClick.event("registerPage", attributes: ["type":"register","result":"error"])
        })
        
 
    }
    
    class func showUserRegisterView(presentNavigator ctl:UINavigationController?,aDelegate: LoginProtocol?){
        var userRegisterView = UIStoryboard(name: "UserRegister", bundle: nil).instantiateViewControllerWithIdentifier("userRegister") as! UserRegister
        userRegisterView.Delegate = aDelegate
        if (ctl != nil) {
            ctl?.pushViewController(userRegisterView, animated: true)
        } else {
            ctl?.presentViewController(userRegisterView, animated: true, completion: nil)
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("userRegister")
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("userRegister")
        self.tabBarController?.tabBar.hidden = false
    }
    
}