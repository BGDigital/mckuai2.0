//
//  NewLogin.swift
//  mckuai
//
//  Created by 陈强 on 15/5/7.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//
protocol LoginProtocol {
    /**
    登录成功后的协议
    
    :returns: Void
    */
    func onLoginSuccessfull() -> Void
}


import Foundation
import UIKit

class NewLogin: UIViewController,UITextFieldDelegate,TencentSessionDelegate{
    var superNavigation:UINavigationController!
    var manager = AFHTTPRequestOperationManager()
    var tencentOAuth:TencentOAuth!
    var permissionsArray=["get_user_info","get_simple_userinfo"]
    var presentNavigator: UINavigationController?
    var Delegate: LoginProtocol?
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var register_img: UIButton!
    @IBOutlet weak var register_btn: UIButton!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var qqLogin_text: UIButton!
    @IBOutlet weak var qqIcon: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.qqIcon.frame.origin.y = 100
        self.hidesBottomBarWhenPushed = true
        self.hiddenView.hidden = true
        //设置navigation
//        initNavigation()
        tencentOAuth = TencentOAuth(appId: qq_AppId, andDelegate: self)
        userName.delegate = self
        passWord.delegate = self
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        
        self.qqLogin_text.titleLabel?.adjustsFontSizeToFitWidth = true
        self.qqLogin_text.titleLabel?.numberOfLines = 1
    }
    
    @IBAction func changeLogin(sender: UIButton) {
        self.hiddenView.hidden = false
        self.register_btn.hidden = true
        self.register_img.hidden = true
        //View
        self.hiddenView.alpha = 0
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.hiddenView.alpha = 1
        })
    }
    
    func backToPage() {
        Async.userInitiated {
            
            self.dismissKeyboard()
        }.main{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func dismissKeyboard(){
        userName.resignFirstResponder()
        passWord.resignFirstResponder()
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toRegister(sender: UIButton) {
        MobClick.event("qqLoginPage",attributes: ["type":"toRegister"])
        self.dismissKeyboard()
        
        UserRegister.showUserRegisterView(presentNavigator: self.presentNavigator,aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
    }
    
    func mckuaiLoginFunction() {
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "登录中"
        
        let params = [
            "userName":self.userName.text,
            "passWord":self.passWord.text,
            
        ]
        
        manager.GET(login_url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                println(responseObject)
                if "ok" == json["state"].stringValue {
                    MCUtils.AnalysisUserInfo(json["dataObject"])
                    
                    self.Delegate?.onLoginSuccessfull()
                    
                    if !appUserRCToken.isEmpty {
                        //RongCloud
                        RCIM.connectWithToken(appUserRCToken,
                            completion: {userId in
                                MCUtils.RCTabBarItem.badgeValue = RCIM.sharedRCIM().totalUnreadCount > 0 ? "\(RCIM.sharedRCIM().totalUnreadCount)" : nil
                                println("RongCloud Login Successrull:\(userId)")
                            },
                            error: {status in
                                println("RongCloud Login Faild. \(status)")
                        })
                    }
                    Async.main({MCUtils.GetFriendsList()})
                    hud.hide(true)
                    self.backToPage()
                } else {
                    hud.hide(true)
                    MCUtils.showCustomHUD("用户名或密码错误,请检查后再试", aType: .Error)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                hud.hide(true)
                MCUtils.showCustomHUD("登录失败,请重试", aType: .Error)
        })
    }
    
    @IBAction func noQqLoginAction(sender: UIButton) {
        
        MobClick.event("qqLoginPage",attributes: ["type":"noQQ"])
        
        if(!self.userName.text.isEmpty && !self.passWord.text.isEmpty) {
            self.dismissKeyboard()
            mckuaiLoginFunction()
        }else {
            MCUtils.showCustomHUD("登录信息不能为空", aType: .Error)
        }
    }
    @IBAction func qqLoginAction(sender: UIButton) {
        
        MobClick.event("qqLoginPage",attributes: ["type":"qq"])
        tencentOAuth.authorize(permissionsArray,inSafari:false)
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
            MobClick.event("qqLoginPage",attributes: ["type":"qqCancle"])
            println("用户取消登录")
        }else{
            MobClick.event("qqLoginPage",attributes: ["type":"qqLoginError"])
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
//                    println(responseObject)
                    hud.hide(true)
                    if (responseObject != nil)  {
                        var json = JSON(responseObject)
                        if "ok" == json["state"].stringValue {
                            MCUtils.AnalysisUserInfo(json["dataObject"])
                            self.Delegate?.onLoginSuccessfull()
                            
                            if !appUserRCToken.isEmpty {
                                //RongCloud
                                RCIM.connectWithToken(appUserRCToken,
                                    completion: {userId in
                                        MCUtils.RCTabBarItem.badgeValue = RCIM.sharedRCIM().totalUnreadCount > 0 ? "\(RCIM.sharedRCIM().totalUnreadCount)" : nil
                                        println("RongCloud Login Successrull:\(userId)")
                                    },
                                    error: {status in
                                        println("RongCloud Login Faild. \(status)")
                                })
                            }
                            Async.main({MCUtils.GetFriendsList()})
                            
                            self.backToPage()
                        }else{
                            MCUtils.showCustomHUD("登录失败,请稍候再试", aType: .Error)
                        }
                    } else {
                        MCUtils.showCustomHUD("登录失败,请稍候再试", aType: .Error)
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("Error: " + error.localizedDescription)
                    hud.hide(true)
                    MCUtils.showCustomHUD("登录失败,请稍候再试", aType: .Error)
            })
        }else{
            println(response.errorMsg)
        }
    }
    
    func keyboardDidShowLogin(notification:NSNotification) {
        var userInfo: NSDictionary = notification.userInfo! as NSDictionary
        var v : NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        var keyHeight = v.CGRectValue().size.height
        var duration = userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        var curve:NSNumber = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        var temp:UIViewAnimationCurve = UIViewAnimationCurve(rawValue: curve.integerValue)!
        UIView.animateWithDuration(duration.doubleValue, animations: {
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(temp)
            self.view.frame.origin = CGPoint(x: 0, y: -keyHeight)
        })

    }
    
    func keyboardDidHiddenLogin(notification:NSNotification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        self.view.frame.origin = CGPoint(x: 0, y: 0)
        
        UIView.commitAnimations()
    }
        
    class func showUserLoginView(ctl:UINavigationController?, aDelegate: LoginProtocol?){
        userLoginView = UIStoryboard(name: "NewLogin", bundle: nil).instantiateViewControllerWithIdentifier("newLogin") as! NewLogin
        userLoginView.presentNavigator = ctl
        userLoginView.Delegate = aDelegate
//        ctl?.presentViewController(userLoginView, animated: true, completion: nil)
        ctl?.pushViewController(userLoginView, animated: true)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        //View 渐隐
        var navAlpha = 1
        var color = UIColor(hexString: MCUtils.COLOR_NavBG)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.navigationController?.navigationBar.lt_setBackgroundColor(color?.colorWithAlphaComponent(0))
        })
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(userLoginView, selector: "keyboardDidShowLogin:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(userLoginView, selector: "keyboardDidHiddenLogin:", name: UIKeyboardWillHideNotification, object: nil)
        self.tabBarController?.tabBar.hidden = true
        MobClick.beginLogPageView("userLogin")
    }
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        self.tabBarController?.tabBar.hidden = false
        MobClick.endLogPageView("userLogin")
    }
    


    
}