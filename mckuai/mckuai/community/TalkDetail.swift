//
//  TalkDetail.swift
//  mckuai
//
//  Created by 陈强 on 15/4/23.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//


import UIKit

class TalkDetail: UIViewController,UIWebViewDelegate,UMSocialUIDelegate,UITextViewDelegate, NJKWebViewProgressDelegate {
    
    var manager = AFHTTPRequestOperationManager()
    var _progressView: NJKWebViewProgressView!
    var _progressProxy: NJKWebViewProgress!
//    var progress = MBProgressHUD()
    var webView: UIWebView!
    var url:NSURL!
    var firstLoad:Bool = true
    var page_btn:UIButton!
    var collect_btn:UIButton!
    var share_btn:UIButton!
    var reply_btn:UIButton!
    var shang_btn:UIButton!
    
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
    var textView:KMPlaceholderTextView!
    var lableView:UILabel!

    
    var params:[String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        //初始化uiwebview
         initWebView()
         setRightBarButtonItem()
         initReplyBar();
        initNJKWebViewProgress()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    func initNJKWebViewProgress() {
        _progressProxy = NJKWebViewProgress()
        webView.delegate = _progressProxy
        _progressProxy.webViewProxyDelegate = self
        _progressProxy.progressDelegate = self
        
        var progressBarHeight: CGFloat = 2.0
        var navigationBarBounds = self.navigationController!.navigationBar.bounds
        var barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight)
        _progressView = NJKWebViewProgressView(frame: barFrame)
        _progressView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleTopMargin
        _progressView.progressBarView.backgroundColor = UIColor(hexString: "#2FA044")
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
        
        MobClick.event("talkDetail", attributes: ["type":"watchLouzhu"])
        
        var request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        
    }
    
    func initToolBar() {


        reply_btn = UIButton(frame: CGRectMake(self.view.bounds.width-45-10,self.view.bounds.height-btn_height-20, 45, 45))

        reply_btn.setBackgroundImage(UIImage(named: "reply_icon"), forState: UIControlState.Normal)
        share_btn = UIButton(frame: CGRectMake(self.view.bounds.width-45-10-45-10,self.view.bounds.height-btn_height-20, 45, 45))
        share_btn.setBackgroundImage(UIImage(named: "share_icon"), forState: UIControlState.Normal)
        collect_btn = UIButton(frame: CGRectMake(10, self.view.bounds.height-btn_height-20, 45, 45))
        
        shang_btn = UIButton(frame: CGRectMake(self.view.bounds.width-45-10-45-45-10-10, self.view.bounds.height-btn_height-20, 45, 45))
        
        shang_btn.setBackgroundImage(UIImage(named: "shang_normal"), forState: UIControlState.Normal)
        shang_btn.setBackgroundImage(UIImage(named: "shang_selected"), forState: UIControlState.Selected)
        shang_btn.setBackgroundImage(UIImage(named: "shang_selected"), forState: UIControlState.Disabled)

        
        collect_btn.setBackgroundImage(UIImage(named: "collect_normal"), forState: UIControlState.Normal)
        collect_btn.setBackgroundImage(UIImage(named: "collect_selected"), forState: UIControlState.Selected)
        collect_btn.setBackgroundImage(UIImage(named: "collect_selected"), forState: UIControlState.Disabled)
        collect_btn.tag = 0
        collect_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        share_btn.tag = 1
        share_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        reply_btn.tag = 2
        reply_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        
        shang_btn.tag = 3
        shang_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        
        
        
//        self.view.addSubview(page_btn)
        self.view.addSubview(reply_btn)
        self.view.addSubview(share_btn)
        self.view.addSubview(collect_btn)
        self.view.addSubview(shang_btn)
        
        if(appUserIdSave != 0){
            let params = [
                "userId":String(stringInterpolationSegment: appUserIdSave),
                "talkId":String(self.id)
            ]
            
            manager.POST(isCollect_url,
                parameters: params,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    var json = JSON(responseObject)
                    
                    if "ok" == json["state"].stringValue {
                        
                        if(json["msg"].stringValue.componentsSeparatedByString("collect").count>1) {
                            self.collect_btn.selected = true
                        }
                        if(json["msg"].stringValue.componentsSeparatedByString("dashang").count>1) {
//                            self.shang_btn.selected = true
                            self.shang_btn.enabled = false
                        }
                        
                        
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("Error: " + error.localizedDescription)
                    
            })
            
        }
        
 
        
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
                    MCUtils.showCustomHUD("帖子收藏成功", aType: .Success)
                    self.collect_btn.selected = true
                    self.collect_btn.enabled = true
                }else{
                    self.collect_btn.enabled = true
                    MCUtils.showCustomHUD("帖子收藏失败", aType: .Error)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.collect_btn.enabled = true
                MCUtils.showCustomHUD("帖子收藏失败", aType: .Error)
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
                    MCUtils.showCustomHUD("取消收藏成功", aType: .Success)
                    self.collect_btn.selected = false
                    self.collect_btn.enabled = true
                }else{
                    self.collect_btn.enabled = true
                    MCUtils.showCustomHUD("取消收藏失败", aType: .Error)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.collect_btn.enabled = true
                MCUtils.showCustomHUD("取消收藏失败", aType: .Error)
        })
    }
    
    func toolBarFunc(sender:UIButton) {
        if(sender.tag == 0){
            
            MobClick.event("talkDetail", attributes: ["type":"collect"])
            
            if(appUserIdSave == 0) {
               NewLogin.showUserLoginView(self.navigationController, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
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
            
            MobClick.event("talkDetail", attributes: ["type":"shareTalk"])
            
            var shareImg: UIImage!
            var shareText:String!
            
            if let query = self.webView.stringByEvaluatingJavaScriptFromString("getShareParams()"){
                var shareParams = MBProgress.getQueryDictionary(query)
                shareText = shareParams["shareText"]?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
                if(shareParams["shareImg"] != nil && shareParams["shareImg"] != "empty"){
                    shareImg = UIImage(data: NSData(contentsOfURL: NSURL(string:shareParams["shareImg"]!)!)!)
                }
                
                if(shareImg == nil){
                    shareImg = UIImage(named: "share_default")
                }
                
                if(shareText != nil && shareImg != nil){
                    MobClick.event("Share", attributes: ["Address":"详情页", "Type": "start"])
                    ShareUtil.shareInitWithTextAndPicture(self, text: shareText, image: shareImg!,shareUrl:"http://www.mckuai.com/thread-"+id+".html", callDelegate: self)
                }
            }
            
        }else if(sender.tag == 2){
            MobClick.event("talkDetail", attributes: ["type":"followTalk"])
            println("reply")
            if(appUserIdSave == 0) {
                NewLogin.showUserLoginView(self.navigationController, aDelegate: nil)
            }else{
                
                if let query = self.webView.stringByEvaluatingJavaScriptFromString("getParameters()"){
                    //                println("返回内容："+query)
                    var param = MBProgress.getQueryDictionary(query)
                    println(param["openUserId"])
                    FollowTalk.showFollowTalkView(self.navigationController,dict: param,viewController: self)
                }
               
            }
        }else if(sender.tag == 3){
            MobClick.event("talkDetail", attributes: ["type":"daShang"])
            if(appUserIdSave == 0) {
                NewLogin.showUserLoginView(self.navigationController, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
            }else{
                let alert = SCLAlertView()
                alert.addButton("必须要", action: {
                    if(self.shang_btn.selected == false){
                        
                        let params = [
                            "userId":String(stringInterpolationSegment: appUserIdSave),
                            "talkId":String(self.id)
                        ]
                        
                        self.manager.POST(daShang_url,
                            parameters: params,
                            success: { (operation: AFHTTPRequestOperation!,
                                responseObject: AnyObject!) in
                                var json = JSON(responseObject)
                                
                                if "ok" == json["state"].stringValue {
                                    self.shang_btn.enabled = false
                                    MCUtils.showCustomHUD("感谢你的打赏", aType: .Success)
                                    self.webView.stringByEvaluatingJavaScriptFromString("daShang()");
                                }else{
                                    MCUtils.showCustomHUD(json["msg"].stringValue, aType: .Error)
                                }
                                
                            },
                            failure: { (operation: AFHTTPRequestOperation!,
                                error: NSError!) in
                                println("Error: " + error.localizedDescription)
                                
                        })
                        
                        
                    }else{
                        MCUtils.showCustomHUD("钻石再多也只能打赏一次哦", aType: .Success)
                    }
                })
                alert.showInfo("打赏楼主", subTitle: "土豪,你确定要给楼主打赏钻石吗?", closeButtonTitle: "取消", duration: 0)
            }
        }
    }
    
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if(response.responseCode.value == UMSResponseCodeSuccess.value) {
            MCUtils.showCustomHUD("分享成功", aType: .Success)
            MobClick.event("Share", attributes: ["Address":"详细页", "Type": "Success"])
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
    
    


    
    override func viewDidAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.lt_reset()
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
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
                MCUtils.openOtherZone(self.navigationController, userId: id, showPop: true)
                
                MobClick.event("talkDetail", attributes: ["type":"clickHeadImg"])
                
            }
        }
        self.params = param;
        if action == "reply" {
            
            MobClick.event("talkDetail", attributes: ["type":"replyJs"])
            
            println("Reply...........")
            if(appUserIdSave == 0) {
                NewLogin.showUserLoginView(self.navigationController, aDelegate: (MCUtils.mainHeadView as! mainHeaderViewController))
            }else{
               self.textView.becomeFirstResponder()
            }
            
        }
        if action == "toForumList" && param["forumName"] != nil {
            
            MobClick.event("talkDetail", attributes: ["type":"toForumList"])
            
            currentForumName = param["forumName"]
            if(self.navigationController?.tabBarController?.selectedIndex == 3){
                self.navigationController?.popViewControllerAnimated(true)
            }else{
                self.navigationController?.tabBarController?.selectedIndex = 3
            }
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.webView.scrollView.header.endRefreshing()
        initToolBar()
        self.rightButton?.enabled = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        MCUtils.showCustomHUD("出错啦,加载失败", aType: .Error)
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
        self.webView.scrollView.header = MJRefreshNormalHeader(refreshingBlock: { self.reloadView()
        })
//        self.webView.scrollView.addLegendHeaderWithRefreshingBlock({self.reloadView()})
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
        
        self.textView = KMPlaceholderTextView(frame: CGRectMake(15, 50, self.containerView.frame.size.width-30, 80))
        self.textView.delegate = self
        self.textView.placeholder = "快速回复"
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
        
        MobClick.event("talkDetail", attributes: ["type":"cancleReplyButton"])
        self.textView.resignFirstResponder()
    }
    
    func sendReply() {
        println("sendReply")
        MobClick.event("talkDetail", attributes: ["type":"sendReply","result":"all"])
        self.sendButton.enabled = false
        var replyContext = self.textView.text
        if(replyContext == nil || replyContext.isEmpty){
            MCUtils.showCustomHUD("回复的内容不能为空", aType: .Error)
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
                        MCUtils.showCustomHUD("回复成功", aType: .Success)
                        self.sendButton.enabled = true
                        self.textView.text = ""
                        if self.params["isOver"] == "yes" {
                           self.afterReply()
                        }
                        MobClick.event("talkDetail", attributes: ["type":"sendReply","result":"success"])
                    }else{
                        self.sendButton?.enabled = true
                        hud.hide(true)
                        MCUtils.showCustomHUD("回复失败,请稍候再试", aType: .Error)
                        MobClick.event("talkDetail", attributes: ["type":"sendReply","result":"error"])
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("Error: " + error.localizedDescription)
                    self.sendButton?.enabled = true
                    hud.hide(true)
                    MCUtils.showCustomHUD("回复失败,请稍候再试", aType: .Error)
                    MobClick.event("talkDetail", attributes: ["type":"sendReply","result":"error"])
            })
            
            
        }

        
    }
    
    func dismissKeyboard(){
        MobClick.event("talkDetail", attributes: ["type":"cancleReplyOther"])
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            MobClick.beginLogPageView("talkDetail")
            //        //注册键盘通知事件
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHidden:", name: UIKeyboardWillHideNotification, object: nil)
            
            self.tabBarController?.tabBar.hidden = true
            self.navigationController?.navigationBar.lt_reset()
            self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        
        self.navigationController?.navigationBar.addSubview(_progressView)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("talkDetail")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        _progressView.removeFromSuperview()
    }
    
    func webViewProgress(webViewProgress: NJKWebViewProgress!, updateProgress progress: Float) {
        _progressView.setProgress(progress, animated: true)
    }
    
    
    

    
}