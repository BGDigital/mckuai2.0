//
//  TalkDetail.swift
//  mckuai
//
//  Created by 陈强 on 15/4/23.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//


import UIKit

class TalkDetail: UIViewController,UIWebViewDelegate {
    var webView:UIWebView!
    var url:NSURL!
    var firstLoad:Bool = true
    var progress = MBProgressHUD()
    var page_btn:UIButton!
    var collect_btn:UIButton!
    var share_btn:UIButton!
    var reply_btn:UIButton!
    var btn_weight:Int = 40
    var btn_height:Int = 40
    
    var rightButtonItem:UIBarButtonItem?
    var rightButton:UIButton?
    let item_wight:CGFloat = 80
    let item_height:CGFloat = 45
    var id:String! {
        didSet {
            self.url = NSURL(string: "file:///Users/chenqiang/Downloads/mc-webapp(1)/postDetail.html")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()
        //初始化uiwebview
         initWebView()
         initNavigation()
         initToolBar()
    }
    
    func initNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00))
        
        setRightBarButtonItem()
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
        currentForumName = "矿工茶馆"
        self.navigationController?.tabBarController?.selectedIndex = 3
    }
    
    func initToolBar() {
        page_btn = UIButton(frame: CGRectMake(10
            , self.view.bounds.height-44-70, 50, 50))
        page_btn.backgroundColor = UIColor.blackColor()
        page_btn.layer.cornerRadius = 25
        page_btn.setTitle("2/6", forState: UIControlState.Normal)
        page_btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        reply_btn = UIButton(frame: CGRectMake(self.view.bounds.width-50-10, self.view.bounds.height-44-70, 50, 50))
        reply_btn.layer.cornerRadius = 25
        reply_btn.backgroundColor = UIColor.blackColor()
//        reply_btn.setBackgroundImage(UIImage(named: "first_normal"), forState: UIControlState.Normal)
//        reply_btn.setBackgroundImage(UIImage(named: "first_selected"), forState: UIControlState.Selected)
        
        share_btn = UIButton(frame: CGRectMake(self.view.bounds.width-50-10-50-20, self.view.bounds.height-44-70, 50, 50))
        share_btn.layer.cornerRadius = 25
        share_btn.backgroundColor = UIColor.blackColor()
        
        collect_btn = UIButton(frame: CGRectMake(self.view.bounds.width-50-10-50-20-50-20, self.view.bounds.height-44-70, 50, 50))
        collect_btn.layer.cornerRadius = 25
        collect_btn.backgroundColor = UIColor.blackColor()
        
        collect_btn.tag = 0
        collect_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        share_btn.tag = 1
        share_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        reply_btn.tag = 2
        reply_btn.addTarget(self, action: "toolBarFunc:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(page_btn)
        self.view.addSubview(reply_btn)
        self.view.addSubview(share_btn)
        self.view.addSubview(collect_btn)
    }
    
    func toolBarFunc(sender:UIButton) {
        if(sender.tag == 0){
            println("collect")
            collect_btn.enabled = false
        }else if(sender.tag == 1){
            println("share")
        }else if(sender.tag == 2){
            println("reply")
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
        self.tabBarController?.tabBar.hidden = false
    }
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    func showCustomHUD(view: UIView, title: String, imgName: String) {
        progress = MBProgressHUD.showHUDAddedTo(view, animated: true)
        progress.labelText = title
        progress.mode = MBProgressHUDMode.CustomView
        progress.customView = UIImageView(image: UIImage(named: imgName))
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        if firstLoad {
            self.showCustomHUD(self.view, title: "正在加载", imgName: "Guide")
        }
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        if firstLoad {
            self.progress.removeFromSuperview()
            self.firstLoad = false
        }
        self.webView.scrollView.header.endRefreshing()
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        MCUtils.showCustomHUD(self.view, title: "出错啦,加载失败", imgName: "Guide")
    }
    
    func initWebView() {
        webView = UIWebView(frame: self.view.bounds)
        var request = NSURLRequest(URL: url)
        webView.loadRequest(request)
        webView.delegate = self
        webView.backgroundColor = UIColor.whiteColor()
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
    
}