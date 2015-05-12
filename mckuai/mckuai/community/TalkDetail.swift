//
//  TalkDetail.swift
//  mckuai
//
//  Created by 陈强 on 15/4/23.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//


import UIKit

class TalkDetail: UIViewController,UIWebViewDelegate,UMSocialUIDelegate,UITextViewDelegate {
    
    var manager = AFHTTPRequestOperationManager()
    var progress = MBProgressHUD()
    var webView: UIWebView!
    var url:NSURL!
    var firstLoad:Bool = true
    var page_btn:UIButton!
    var collect_btn:UIButton!
    var share_btn:UIButton!
    var reply_btn:UIButton!
    var btn_wight:CGFloat = 48
    var btn_height:CGFloat = 48
    
    var rightButtonItem:UIBarButtonItem?
    var rightButton:UIButton?
    let item_wight:CGFloat = 80
    let item_height:CGFloat = 44
    var admin:String = "all"

    var id:String! {
        didSet {
            self.url = NSURL(string: webView_url+"&id="+id+"&admin="+admin)
        }
    }
    
    
    var containerView:UIView!
    var cancleButton:UIButton!
    var sendButton:UIButton!
    var textView:UITextView!
    var lableView:UILabel!

    
    var params:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化uiwebview
         initWebView()
         setRightBarButtonItem()
         initReplyBar();
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
        self.webView.delegate = nil
    }

    
    func setRightBarButtonItem() {
        self.rightButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.rightButton!.frame=CGRectMake(0,0,item_wight,item_height)
        self.rightButton?.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.rightButton!.setTitle("只看楼主", forState: UIControlState.Normal)
        self.rightButton?.setTitle("查看全部", forState: UIControlState.Selected)
        self.rightButton?.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        self.rightButton?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.rightButton!.userInteractionEnabled = true
        self.rightButton?.addTarget(self, action: "rightBarButtonItemClicked", forControlEvents: UIControlEvents.TouchUpInside)
        var barButtonItem = UIBarButtonItem(customView:self.rightButton!)
        
        var negativeSpacer = UIBarButtonItem(barButtonSystemItem:UIBarButtonSystemItem.FixedSpace,target:self,action:nil)
        negativeSpacer.width = -15
        self.navigationItem.rightBarButtonItems = [negativeSpacer,barButtonItem];
        
    }
    
    func rightBarButtonItemClicked() {
        println("only louzhu")
        self.rightButton?.enabled = false
        if(self.rightButton?.selected == false){
           self.rightButton?.selected = true
           self.admin = "admin"
           self.url = NSURL(string: webView_url+"&id="+id+"&admin="+admin)
        }else{
            self.rightButton?.selected = false
            self.admin = "all"
            self.url = NSURL(string: webView_url+"&id="+id+"&admin="+admin)
        }
        
        var request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        
    }
    
    func initToolBar() {
//        page_btn = UIButton(frame: CGRectMake(10
//            , self.view.bounds.height-btn_height-10, btn_wight, btn_height))
//        page_btn.backgroundColor = UIColor.blackColor()
//        page_btn.layer.cornerRadius = 25
//        page_btn.setTitle("2/6", forState: UIControlState.Normal)
//        page_btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        reply_btn = UIButton(frame: CGRectMake(self.view.bounds.width-48-10,self.view.bounds.height-btn_height-20, 48, 48))
//        reply_btn.layer.cornerRadius = 25
//        reply_btn.backgroundColor = UIColor.blackColor()
        reply_btn.setBackgroundImage(UIImage(named: "reply_icon"), forState: UIControlState.Normal)
//        reply_btn.setBackgroundImage(UIImage(named: "first_selected"), forState: UIControlState.Selected)
        
        share_btn = UIButton(frame: CGRectMake(self.view.bounds.width-48-10-40-48,self.view.bounds.height-btn_height-20, 48, 48))
//        share_btn.layer.cornerRadius = 25
//        share_btn.backgroundColor = UIColor.blackColor()
        share_btn.setBackgroundImage(UIImage(named: "share_icon"), forState: UIControlState.Normal)
        collect_btn = UIButton(frame: CGRectMake(10, self.view.bounds.height-btn_height-20, 48, 48))
//        collect_btn.layer.cornerRadius = 25
//        collect_btn.backgroundColor = UIColor.blackColor()
        
        collect_btn.setBackgroundImage(UIImage(named: "collect_normal"), forState: UIControlState.Normal)
        collect_btn.setBackgroundImage(UIImage(named: "collect_selected"), forState: UIControlState.Selected)
        collect_btn.setBackgroundImage(UIImage(named: "collect_selected"), forState: UIControlState.Disabled)
        collect_btn.tag = 0
        collect_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        share_btn.tag = 1
        share_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        reply_btn.tag = 2
        reply_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        
//        self.view.addSubview(page_btn)
        self.view.addSubview(reply_btn)
        self.view.addSubview(share_btn)
        self.view.addSubview(collect_btn)
    }
    
    
    func toCollectTalk() {
        
        
        
        let params = [
            "userId":String(stringInterpolationSegment: appUserIdSave),
            "talkId":String(self.id)
        ]
        
        manager.POST(toCollect_url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                
                if "ok" == json["state"].stringValue {
                    self.showCustomHUD(self.view, title: "帖子收藏成功", imgName: "HUD_OK")
                    self.collect_btn.selected = true
                    self.collect_btn.enabled = true
                }else{
                    self.collect_btn.enabled = true
                    self.showCustomHUD(self.view, title: "帖子收藏失败", imgName: "HUD_ERROR")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.collect_btn.enabled = true
                self.showCustomHUD(self.view, title: "帖子收藏失败", imgName: "HUD_ERROR")
        })
        
        
    }
    
    func cancleCollectTalk() {
        let params = [
            "userId":String(stringInterpolationSegment: appUserIdSave),
            "talkId":String(self.id)
        ]
        
        manager.POST(cancleCollect_url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                
                if "ok" == json["state"].stringValue {
                    self.showCustomHUD(self.view, title: "取消收藏成功", imgName: "HUD_OK")
                    self.collect_btn.selected = false
                    self.collect_btn.enabled = true
                }else{
                    self.collect_btn.enabled = true
                    self.showCustomHUD(self.view, title: "取消收藏失败", imgName: "HUD_ERROR")
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.collect_btn.enabled = true
                self.showCustomHUD(self.view, title: "取消收藏失败", imgName: "HUD_ERROR")
        })
    }
    
    func toolBarFunc(sender:UIButton) {
        if(sender.tag == 0){
            if(appUserIdSave == 0) {
               NewLogin.showUserLoginView(self.navigationController, aDelegate: nil)
                //NewLogin.showUserLoginView(self,returnIsShow: false, aDelegate: nil)
            }else{
                
                self.collect_btn.enabled = false
                
                if(self.collect_btn?.selected == false){
                    toCollectTalk()
                }else{
                    cancleCollectTalk()
                }
                
            }
            

            
        }else if(sender.tag == 1){
            var shareImg:UIImage!
            var shareText:String!
            
            if let query = self.webView.stringByEvaluatingJavaScriptFromString("getShareParams()"){
                var shareParams = MBProgress.getQueryDictionary(query)
                shareText = shareParams["shareText"]?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                if(shareParams["shareImg"] != nil && shareParams["shareImg"] != "empty"){
                    
                    UIImage(data: NSData(contentsOfURL: NSURL(string:shareParams["shareImg"]!)!)!)
                }else{
                    shareImg = UIImage(named: "1024")
                }
                if(shareText != nil && shareImg != nil){
                    ShareUtil.shareInitWithTextAndPicture(self, text: "", image: shareImg!, callDelegate: self)
                }
                
            }
            
        }else if(sender.tag == 2){
            println("reply")
            
            


            if(appUserIdSave == 0) {
                NewLogin.showUserLoginView(self.navigationController, aDelegate: nil)
                //NewLogin.showUserLoginView(self,returnIsShow: false, aDelegate: nil)
            }else{
                
                if let query = self.webView.stringByEvaluatingJavaScriptFromString("getParameters()"){
                    //                println("返回内容："+query)
                    var param = MBProgress.getQueryDictionary(query)
                    println(param["openUserId"])
                    FollowTalk.showFollowTalkView(self.navigationController,dict: param,viewController: self)
                }
               
            }
            
            
            
        }
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if(response.responseCode.value == UMSResponseCodeSuccess.value) {
            println("回调ok");
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    @IBAction func jumpTo(sender: UIButton) {
//        self.navigationController?.popViewControllerAnimated(false)
        currentForumName = "矿工茶馆"
        self.navigationController?.tabBarController?.selectedIndex = 3
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    override func viewWillAppear(animated: Bool) {
        //注册键盘通知事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.lt_reset()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBar.lt_reset()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
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
    
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool{
        let url = request.URL
        if (url!.scheme == "ios") {
            var fun = url!.host
            var arg0 = url!.query
            
            
            let param = MBProgress.getQueryDictionary(arg0!)
            
            dispatchAction(fun!,param: param);
            
            return false;
        }
        
        return true;
    }
    
    private func dispatchAction(action:String,param:[String:String]) {

        if action == "viewuser" && param["id"] != nil{
            if let id = param["id"]!.toInt(){
                MCUtils.openOtherZone(self.navigationController, userId: id)
            }
        }
        self.params = param;
        if action == "reply" {
            println("Reply...........")
//

            if(appUserIdSave == 0) {
                NewLogin.showUserLoginView(self.navigationController, aDelegate: nil)
//                NewLogin.showUserLoginView(self,returnIsShow: false, aDelegate: nil)
            }else{
               self.textView.becomeFirstResponder() 
            }
            
        }
        if action == "toForumList" && param["forumName"] != nil {
            currentForumName = param["forumName"]
            if(self.navigationController?.tabBarController?.selectedIndex == 3){
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                self.navigationController?.tabBarController?.selectedIndex = 3
            }
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        if firstLoad {
//            self.showCustomHUD(self.view, title: "正在加载", imgName: "Guide")
            progress = MBProgressHUD.showHUDAddedTo(view, animated: true)
            progress.labelText = "正在加载"
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if firstLoad {
            self.progress.removeFromSuperview()
            self.firstLoad = false
        }
        self.webView.scrollView.header.endRefreshing()
        initToolBar()
        self.rightButton?.enabled = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        MBProgress.showCustomHUD(self.view, title: "出错啦,加载失败", imgName: "Guide")
    }
    
    func initWebView() {
        if IS_IOS8() {
            webView = UIWebView(frame: self.view.bounds)
        } else {
            webView = UIWebView(frame: CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64))
        }
        webView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()

        var request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        
        self.webView.scrollView.addLegendHeaderWithRefreshingBlock({self.reloadView()})
        self.view.addSubview(webView)
    }
    
    func reloadView() {
        self.webView.reload()
    }
    class func showTalkDetailPage(fromNavigation:UINavigationController?,id:String){
        var talkDetail = UIStoryboard(name: "TalkDetail", bundle: nil).instantiateViewControllerWithIdentifier("talkDetail") as! TalkDetail
        
        talkDetail.id = id
        if (fromNavigation != nil) {
            fromNavigation?.pushViewController(talkDetail, animated: true)
        } else {
            fromNavigation?.presentViewController(talkDetail, animated: true, completion: nil)
        }
        
    }
    
    
    func initReplyBar() {
        self.containerView = UIView(frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, 150))
        self.containerView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.00)
        
        self.cancleButton = UIButton(frame: CGRectMake(5, 5, 50, 30))
        self.cancleButton.setTitle("取消", forState: UIControlState.Normal)
        self.cancleButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.cancleButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        self.cancleButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.cancleButton.addTarget(self, action: "cancleReply", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.sendButton = UIButton(frame: CGRectMake(self.containerView.frame.size.width-5-50, 5, 50, 30))
        self.sendButton.setTitle("发送", forState: UIControlState.Normal)
        self.sendButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.sendButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        self.sendButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        self.sendButton.addTarget(self, action: "sendReply", forControlEvents: UIControlEvents.TouchUpInside)
        self.lableView = UILabel(frame: CGRectMake((self.containerView.frame.size.width)/2-40, 5, 80, 30))
        self.lableView.text = "写回复"
        self.lableView.textAlignment = NSTextAlignment.Center
        self.lableView.textColor = UIColor.grayColor()
        
        self.textView = UITextView(frame: CGRectMake(15, 50, self.containerView.frame.size.width-30, 80))
        self.textView.delegate = self
        textView.layer.borderColor = UIColor.grayColor().CGColor;
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius = 6;
        textView.layer.masksToBounds = true;
        textView.userInteractionEnabled = true;
        textView.font = UIFont.systemFontOfSize(14)
        textView.scrollEnabled = true;
        textView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        
        
        self.containerView.addSubview(self.cancleButton)
        self.containerView.addSubview(self.lableView)
        self.containerView.addSubview(self.sendButton)
        self.containerView.addSubview(self.textView)
        self.view.addSubview(containerView)
        self.containerView.alpha = 0
    }
    
    func cancleReply() {
        println("cancleReply")
        self.textView.resignFirstResponder()
    }
    
    func sendReply() {
        println("sendReply")
        
        self.sendButton.enabled = false
        var replyContext = self.textView.text
        if(replyContext == nil || replyContext.isEmpty){
            self.showCustomHUD(self.view, title: "回复的内容不能为空", imgName:  "Guide")
            self.sendButton.enabled = true
            return
        }
        
        if(self.params != nil) {
            self.params["replyContext"] = replyContext
            self.params["device"] = "ios"
            self.params["userId"] = String(stringInterpolationSegment: appUserIdSave)
            var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud.labelText = "正在发送"
            
            manager.POST(replyTalk_url,
                parameters: self.params,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    var json = JSON(responseObject)
                    
                    if "ok" == json["state"].stringValue {
                        self.textView.resignFirstResponder()
                        hud.hide(true)
                        self.showCustomHUD(self.view, title: "回复成功", imgName:  "HUD_OK")
                        self.sendButton.enabled = true
                        
                        if self.params["isOver"] == "yes" {
                           self.afterReply()
                        }

                    }else{
                        self.rightButton?.enabled = true
                        hud.hide(true)
                        self.showCustomHUD(self.view, title: "回复失败,请稍候再试", imgName: "Guide")
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("Error: " + error.localizedDescription)
                    self.rightButton?.enabled = true
                    hud.hide(true)
                    self.showCustomHUD(self.view, title: "回复失败,请稍候再试", imgName: "Guide")
            })
            
            
        }

        
    }
    
    func dismissKeyboard(){
        self.textView.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
    }
    
    func textViewDidChange(textView: UITextView) {
        self.textView.scrollRangeToVisible(self.textView.selectedRange)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        
    }
    
    func keyboardDidShow(notification:NSNotification) {
        self.containerView.alpha = 1
        var userInfo: NSDictionary = notification.userInfo! as NSDictionary
        var v : NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        var keyHeight = v.CGRectValue().size.height
        var duration = userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        var curve:NSNumber = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        var temp:UIViewAnimationCurve = UIViewAnimationCurve(rawValue: curve.integerValue)!
        UIView.animateWithDuration(duration.doubleValue, animations: {
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(temp)
            
            self.containerView.frame = CGRectMake(0, self.view.frame.size.height-keyHeight-150, self.view.bounds.size.width, 150)
            
        })
        
    }
    
    func keyboardDidHidden(notification:NSNotification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        self.containerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.bounds.size.width, 150)
        self.containerView.alpha = 0
        
        UIView.commitAnimations()
    }
    
    
    func afterReply(){
        println("addReplyHtml")
        if(self.admin != "admin"){
            self.webView.stringByEvaluatingJavaScriptFromString("addReplyHtml()");
        }
        
    }
    

    
}