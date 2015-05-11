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

class NewLogin: UIViewController,UITextFieldDelegate,TencentSessionDelegate {
    var superNavigation:UINavigationController!
    var manager = AFHTTPRequestOperationManager()
    var tencentOAuth:TencentOAuth!
    var permissionsArray=["get_user_info","get_simple_userinfo"]
    var presentNavigator: UINavigationController?
    var Delegate: LoginProtocol?
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置navigation
        initNavigation()
        tencentOAuth = TencentOAuth(appId: tencentAppKey, andDelegate: self)
        userName.delegate = self
        passWord.delegate = self
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
    }
    
    
    func initNavigation() {
        
        var closeLogin = UIButton(frame: CGRectMake(10, 30, 21, 21))
        closeLogin.setImage(UIImage(named: "nav_back"), forState: UIControlState.Normal)
        closeLogin.addTarget(self, action: "backToPage", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(closeLogin)

    }
    
    func backToPage() {
        Async.userInitiated {
            NSNotificationCenter.defaultCenter().removeObserver(self)
            self.dismissKeyboard()
        }.main{
            self.presentNavigator?.dismissViewControllerAnimated(true, completion: nil)
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
    @IBAction func toRegister(sender: UIButton) {
        self.backToPage()
        
        UserRegister.showUserRegisterView(presentNavigator: self.presentNavigator)
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
                    appUserIdSave = userId
                    
                    self.Delegate?.onLoginSuccessfull()
                    self.backToPage()
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.showCustomHUD(self.view, title: "登录失败", imgName: "HUD_ERROR")
        })
    }
    
    @IBAction func noQqLoginAction(sender: UIButton) {
        if(!self.userName.text.isEmpty && !self.passWord.text.isEmpty) {
            println(self.userName.text)
            mckuaiLoginFunction()
        }else {
            MCUtils.showCustomHUD(self.view, title: "登录信息不能为空", imgName: "Guide")
        }
    }
    @IBAction func qqLoginAction(sender: UIButton) {
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
//                    println(responseObject)
                    var json = JSON(responseObject)
                    
                    if "ok" == json["state"].stringValue {
                        self.AnalysisUserInfo(json["dataObject"])
                        hud.hide(true)
                        
                        self.Delegate?.onLoginSuccessfull()
                        self.backToPage()
                    }else{
                        hud.hide(true)
                        self.showCustomHUD(self.view, title: "登录失败,请稍候再试", imgName: "HUD_ERROR")
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("Error: " + error.localizedDescription)
                    hud.hide(true)
                    self.showCustomHUD(self.view, title: "登录失败,请稍候再试", imgName: "HUD_ERROR")
            })
        }else{
            println(response.errorMsg)
        }
    }
    /*
    {
    dataObject={
    addr="\U6210\U90fd\U5e02";continueLogin=1;headImg="http://cdn.mckuai.com/images/iphone/13.png";id=6;isImport=0;isLock=0;lastLoginIp="221.237.152.39";lastLoginMesTime="2015-04-10 17:10:08.353";lastLoginTime="2015-04-22 12:22:35.447";loginKey="6c5f6730-ba4c-4637-8f1b-b3fdb79a8743";loginNum=134;messageNum=2;nickName="\U4e00\U53f6\U4e4b\U79cb";regTime="2014-10-21 17:04:23.15";sex="\U7537";token="{\"code\":200,\"userId\":\"8A92E0F6637743BC4A46260D1C924B10\",\"token\":\"dEiesBe0EQgqnbrTi2zbRBuBCTxypfvhAwu2X8sXMLwKxdzFrTlE+/1kY+Ua428Mr6TkHea9v0hi0U0/xIGplqN/GkR+XvLz4BUeryLmo+Vs9YdNawos3e+/tN2kgVD+duru3h8aE6w=\"}";userName=8A92E0F6637743BC4A46260D1C924B10;userType=qq;
    };state=ok;
    }
    */
    func AnalysisUserInfo(j: JSON) {
        var userId = j["id"].intValue
        var userAddr = j["addr"].stringValue
        var Avatar = j["headImg"].stringValue
        var nickName = j["nickName"].stringValue
        var userLevel = j["level"].intValue
        var RC_token = j["token", "token"].stringValue
        var RC_ID = j["token", "userId"].stringValue
        
        //保存登录信息
        Defaults[D_USER_ID] = userId
        Defaults[D_USER_LEVEL] = userLevel
        Defaults[D_USER_NICKNAME] = nickName
        Defaults[D_USER_ARATAR] = Avatar
        Defaults[D_USER_ADDR] = userAddr
        Defaults[D_USER_RC_ID] = RC_ID
        Defaults[D_USER_RC_TOKEN] = RC_token
        
        appUserIdSave = userId
        appUserNickName = nickName
        appUserPic = Avatar
        appUserAddr = userAddr
        appUserLevel = userLevel
        appUserRCID = RC_ID
        appUserRCToken = RC_token
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
//            self.containerView.frame = CGRectMake(0, self.view.frame.size.height-keyHeight-150, self.view.bounds.size.width, 150)
            
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
        NSNotificationCenter.defaultCenter().addObserver(userLoginView, selector: "keyboardDidShowLogin:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(userLoginView, selector: "keyboardDidHiddenLogin:", name: UIKeyboardWillHideNotification, object: nil)
        ctl?.presentViewController(userLoginView, animated: true, completion: nil)
    }
    
    


    
}