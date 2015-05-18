//
//  mineTableViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mineTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MineProtocol, UITextViewDelegate {
    var tableView: UITableView!
    var isFirstLoad = true
    var mineType = "message"
    var mineMsgType = "reply"
    var head: mineHeadViewController!
    let NAVBAR_CHANGE_POINT:CGFloat = 50
    var offsetY: CGFloat!
    var manager = AFHTTPRequestOperationManager()
    var page: PageInfo!
    var hud: MBProgressHUD?
    
    //快捷回复
    var containerView:UIView!
    var cancleButton:UIButton!
    var sendButton:UIButton!
    var viewButton:UIButton!
    var textView:KMPlaceholderTextView!
    var selectData: JSON!
    
    var json: JSON! {
        didSet {
            if "ok" == self.json["state"].stringValue {
                page = PageInfo(
                    currentPage: self.json["dataObject", "list", "page"].intValue,
                    pageCount: self.json["dataObject", "list", "pageCount"].intValue,
                    pageSize: self.json["dataObject", "list", "pageSize"].intValue,
                    allCount: self.json["dataObject", "list", "allCount"].intValue)
                if let d = self.json["dataObject", "list", "data"].array {
                    if page.currentPage == 1 {
//                        println("刷新数据")
                        self.datasource = d
                    } else {
//                        println("加载更多")
                        self.datasource = self.datasource + d
                    }
                }
                self.User = self.json["dataObject", "user"] as JSON
            }
            head.RefreshHead(User, parent: self)
            self.tableView.reloadData()
        }
    }
    var User: JSON!
    var datasource: Array<JSON> = Array() {
        didSet {
            if self.datasource.count < page.allCount {
                self.tableView.footer.hidden = self.datasource.count < page.pageSize
//                println("没有达到最大值 \(self.tableView.footer.hidden)")
            } else {
//                println("最大值了,noMoreData")
                self.tableView.footer.hidden = true
            }
            self.tableView.reloadData()
        }
    }
    
    class func initializationMine()->UIViewController{
        var mine = UIStoryboard(name: "mine", bundle: nil).instantiateViewControllerWithIdentifier("mineTableViewController") as! mineTableViewController
        return UINavigationController(rootViewController: mine)
    }
    
    func setupViews() {
        self.tableView = UITableView(frame: CGRectMake(0, -64, self.view.frame.size.width, self.view.frame.size.height+64), style: UITableViewStyle.Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleBottomMargin | .FlexibleTopMargin
        tableView.delegate = self
        tableView.dataSource = self
        tableView.opaque = false
        tableView.backgroundColor = UIColor.whiteColor()
        tableView.separatorStyle = .None
        tableView.backgroundView = nil //这个可以改背影
        tableView.scrollsToTop = false
        
        //添加Header
        self.head = UIStoryboard(name: "mine", bundle: nil).instantiateViewControllerWithIdentifier("mineHeadViewController") as! mineHeadViewController
        tableView.tableHeaderView = self.head.view
        self.head.Delegate = self
        self.view.addSubview(tableView)
        
        self.tableView.addLegendHeaderWithRefreshingBlock({self.loadNewData()})
        self.tableView.addLegendFooterWithRefreshingBlock({self.loadMoreData()})
        self.tableView.footer.hidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initReplyBar()
        
        if isFirstLoad {
            loadDataWithoutMJRefresh()
        }
    }
    
    func loadDataWithoutMJRefresh() {
        hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud?.labelText = MCUtils.TEXT_LOADING
        loadNewData()
    }


    func scrollViewDidScroll(scrollView: UIScrollView) {
        var color = UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00)
        self.offsetY = scrollView.contentOffset.y
        if self.offsetY > NAVBAR_CHANGE_POINT {
            var alpha = 1 - (NAVBAR_CHANGE_POINT + 64 - offsetY) / 64
            self.navigationItem.title = "个人中心"
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
        } else {
            self.navigationItem.title = ""
            self.navigationController?.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.mineType != "work" {
            return 100
        } else {
            return 80
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if !self.datasource.isEmpty {
            self.tableView.backgroundView = nil
            return self.datasource.count
        } else {
            MCUtils.showEmptyView(self.tableView, aImg: Load_Empty!, aText: "你还没有发布作品,快去社区发贴吧")
            return 0
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.mineType != "work" {
            var cell = tableView.dequeueReusableCellWithIdentifier("messageCell") as? messageCell
            
            if cell == nil {
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("messageCell", owner: self, options: nil)
                cell = nib.lastObject as? messageCell
            }
            let d = self.datasource[indexPath.row] as JSON
            cell?.update(d, iType: self.mineType, sMsgType: self.mineMsgType)
            // Configure the cell...
            
            return cell!

        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("mainSubCell") as? mainSubCell
            
            if cell == nil {
                let nib: NSArray = NSBundle.mainBundle().loadNibNamed("mainSubCell", owner: self, options: nil)
                cell = nib.lastObject as? mainSubCell
            }
            let d = self.datasource[indexPath.row] as JSON
            cell?.update(d)
            return cell!

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectData = self.datasource[indexPath.row]
        if self.mineMsgType == "reply" {
            self.textView.placeholder = "回复 " + self.selectData["userName"].stringValue
            self.textView.becomeFirstResponder()
        } else {
            if self.mineMsgType != "system" {
                let id = self.selectData["id"].stringValue
                TalkDetail.showTalkDetailPage(self.navigationController, id: id)
            }
        }
        
    }
    
    override func becomeFirstResponder() -> Bool {
        return super.becomeFirstResponder()
    }
    
    func loadNewData() {
        //开始刷新
        var param = [
            "act": "center",
            "id": appUserIdSave,
            "page": 1,
            "type":self.mineType,
            "messageType": self.mineMsgType]
        manager.GET(URL_MC,
            parameters: param,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.isFirstLoad = false
                self.json = JSON(responseObject)
                self.tableView.header.endRefreshing()
                self.hud?.hide(true)
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.header.endRefreshing()
                self.hud?.hide(true)
                MCUtils.showCustomHUD("数据加载失败", aType: .Error)
        })
    }
    
    func loadMoreData() {
        var param = [
            "act": "center",
            "id": appUserIdSave,
            "page": page.currentPage+1,
            "type":self.mineType,
            "messageType": self.mineMsgType]
        manager.GET(URL_MC,
            parameters: param,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                self.json = JSON(responseObject)
                self.tableView.footer.endRefreshing()
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.tableView.footer.endRefreshing()
                MCUtils.showCustomHUD("数据加载失败", aType: .Error)
        })
    }

    //刷新数据
    //1:消息,2:动态,3:作品
    //0:@Me,1:系统, 2:为空,不用传
    func onRefreshDataSource(iType: Int, iMsgType: Int) {
        //大类型
        switch (iType) {
        case 1:
            self.mineType = "message"
        case 2:
            self.mineType = "dynamic"
            break
        default:
            self.mineType = "work"
            break
        }
        //小类型
        switch (iMsgType) {
        case 0:
            self.mineMsgType = "reply"
            break
        case 1:
            self.mineMsgType = "system"
            break
        default:
            self.mineMsgType = ""
            break
        }
        //开始加载数据
        loadDataWithoutMJRefresh()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.offsetY > 64 {
            return
        }
        //View 渐隐
        var navAlpha = 1
        var color = UIColor(hexString: MCUtils.COLOR_NavBG)
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.navigationController?.navigationBar.lt_setBackgroundColor(color?.colorWithAlphaComponent(0))
        })
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView("mineTableView")
        self.tabBarController?.tabBar.hidden = true
        self.scrollViewDidScroll(self.tableView)
        
        //        //注册键盘通知事件
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView("mineTableView")
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //快捷回复
    func initReplyBar() {
        self.containerView = UIView(frame: CGRectMake(0, self.view.bounds.height, self.view.bounds.width, 100))
        self.containerView.backgroundColor = UIColor(red: 0.949, green: 0.949, blue: 0.949, alpha: 1.00)
        
        var line = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 1))
        line.backgroundColor = UIColor(hexString: "#D8D8D8")
        
        self.cancleButton = UIButton(frame: CGRectMake(5, 3, 50, 25))
        self.cancleButton.setTitle("取消", forState: UIControlState.Normal)
        self.cancleButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.cancleButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        self.cancleButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.cancleButton.addTarget(self, action: "cancleReply", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.sendButton = UIButton(frame: CGRectMake(self.containerView.frame.size.width-5-50, 3, 50, 25))
        self.sendButton.setTitle("发送", forState: UIControlState.Normal)
        self.sendButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.sendButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        self.sendButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.sendButton.addTarget(self, action: "sendReply", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.viewButton = UIButton(frame: CGRectMake((self.containerView.frame.size.width)/2-40, 3, 80, 25))
        self.viewButton.setTitle("查看原帖", forState: UIControlState.Normal)
        self.viewButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        self.viewButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        self.viewButton.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.viewButton.addTarget(self, action: "showReply", forControlEvents: UIControlEvents.TouchUpInside)

        self.textView = KMPlaceholderTextView(frame: CGRectMake(5, 33, self.containerView.frame.size.width-10, 60))
        self.textView.delegate = self
        textView.layer.borderColor = UIColor(hexString: "#C7C7C7")!.CGColor
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius = 5;
        textView.layer.masksToBounds = true;
        textView.userInteractionEnabled = true;
        textView.font = UIFont.systemFontOfSize(15)
        textView.scrollEnabled = true;
        textView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapDismiss.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapDismiss)
        
        self.containerView.addSubview(self.cancleButton)
        self.containerView.addSubview(self.viewButton)
        self.containerView.addSubview(self.sendButton)
        self.containerView.addSubview(self.textView)
        self.containerView.addSubview(line)
        self.containerView.hidden = true
        self.view.addSubview(containerView)
    }
    
    //查看原帖
    func showReply() {
        self.textView.resignFirstResponder()
        let id = self.selectData["id"].stringValue
        TalkDetail.showTalkDetailPage(self.navigationController, id: id)
    }
    
    //取消回复
    func cancleReply() {
        self.textView.resignFirstResponder()
    }
    //发送回复
    func sendReply() {
        self.sendButton.enabled = false
        var replyContext = self.textView.text
        if(replyContext == nil || replyContext.isEmpty){
            self.textView.shake(.Horizontal, numberOfTimes: 10, totalDuration: 0.8, completion: {})
            MCUtils.showCustomHUD("回复的内容不能为空", aType: .Error)
            self.sendButton.enabled = true
            return
        }
        
        var hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "正在发送"
        //
        var params = [
            "act":"addReplyByCenter",
            "loginId": appUserIdSave,
            "replyContent": replyContext,
            "cont2": selectData["cont2"].stringValue]
        manager.POST(URL_MC,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                println(responseObject)
                var json = JSON(responseObject)
                
                if "ok" == json["state"].stringValue {
                    self.textView.resignFirstResponder()
                    hud.hide(true)
                    MCUtils.showCustomHUD("快速回复成功", aType: .Success)
                    self.sendButton.enabled = true
                    self.textView.text = ""
                }else{
                    hud.hide(true)
                    self.sendButton.enabled = true
                    MCUtils.showCustomHUD("回复失败,请稍候再试", aType: .Error)
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                hud.hide(true)
                self.sendButton.enabled = true
                MCUtils.showCustomHUD("回复失败,请稍候再试", aType: .Error)
//                    MobClick.event("talkDetail", attributes: ["type":"sendReply","result":"error"])
        })
    }
    
    func dismissKeyboard(){
//        MobClick.event("talkDetail", attributes: ["type":"cancleReplyOther"])
        println("dismissKeyboard")
        self.textView.resignFirstResponder()
    }
    

    func textViewDidChange(textView: UITextView) {
        self.textView.scrollRangeToVisible(self.textView.selectedRange)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {

    }
    
    func keyboardDidShow(notification:NSNotification) {
        self.containerView.hidden = false
        var userInfo: NSDictionary = notification.userInfo! as NSDictionary
        var v : NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        var keyHeight = v.CGRectValue().size.height
        var duration = userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        var curve:NSNumber = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        var temp:UIViewAnimationCurve = UIViewAnimationCurve(rawValue: curve.integerValue)!
        UIView.animateWithDuration(duration.doubleValue, animations: {
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(temp)
            
            self.containerView.frame = CGRectMake(0, self.view.frame.size.height-keyHeight-100, self.view.bounds.size.width, 100)
            
        })
        
    }
    
    func keyboardDidHidden(notification:NSNotification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        self.containerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.bounds.size.width, 100)
        self.containerView.hidden = true
        
        UIView.commitAnimations()
    }
    

}
