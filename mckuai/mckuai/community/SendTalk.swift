//
//  SendTalk.swift
//  mckuai
//
//  Created by 陈强 on 15/5/4.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit


class SendTalk: UIViewController,UITextFieldDelegate,UITextViewDelegate,UzysAssetsPickerControllerDelegate, UIGestureRecognizerDelegate {

    
    var manager = AFHTTPRequestOperationManager()
    var progress = MBProgressHUD()
    
    
    var forumType_id:Int!
    var forumType_name:String!
    
    var type_id:Int!
    var type_name:String!
    
    var typeJson:Array<JSON>!
    
    
    var forumId_post:Int!
    var forumName_post:String!
    var talkTypeId_post:Int!
    var talkTypeName_post:String!
    
    var talkTitle_post:String!
    var content_post:String!
    
    
    
    var rightButtonItem:UIBarButtonItem?
    var rightButton:UIButton?
    let item_wight:CGFloat = 44
    let item_height:CGFloat = 44
    
    var small_height:CGFloat!
    var small_view_height:CGFloat!
    var content_view:UIView!
    
    var small_view:UIView!
    var isFirst:Bool! = true
    
    var big_last:UIButton!
    var small_last:UIButton!
    
    
    var textView:KMPlaceholderTextView!
    var textField:UITextField!
    
    var image_array = [UIImage]()
    
    var image_button = [UIButton]()
    
    var pic_wight:CGFloat!
    
    var old_frame:CGRect!
    
    var addPic:UIButton!
    
    var image_button_tag:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBarButtonItem()
        
        initBigKinds()
        
        initTextView()
        
        self.old_frame = self.view.frame
        self.view.backgroundColor = UIColor(red: 0.933, green: 0.941, blue: 0.949, alpha: 1.00)
        
    }
    
    func initTextView() {
        
        if(small_height != nil){
            
            content_view = UIView(frame: CGRectMake(0, small_height+20, self.view.frame.width, self.view.frame.height-small_height-20-20))
            textField = UITextField(frame: CGRectMake(0, 5, self.content_view.frame.width, 30))
            textField.borderStyle = UITextBorderStyle.None
            textField.leftViewMode = UITextFieldViewMode.Always
            var whiteView = UIView(frame: CGRectMake(0, 0, 5, 30))
            textField.leftView = whiteView
            textField.textAlignment = NSTextAlignment.Left
            textField.backgroundColor = UIColor.whiteColor()
            textField.placeholder = "帖子标题"
//            textField.setValue(UIColor.lightGrayColor(), forKeyPath: "_placeholderLabel.textColor")
            textField.font = UIFont.systemFontOfSize(14)
            textField.clearButtonMode = UITextFieldViewMode.WhileEditing
            textField.delegate = self
            
            
            
            self.textView = KMPlaceholderTextView(frame: CGRectMake(0, self.textField.frame.origin.y+self.textField.frame.size.height+5,self.content_view.frame.width, 200))
            self.textView.delegate = self
//            textView.layer.borderColor = UIColor.grayColor().CGColor;
//            textView.layer.borderWidth = 1;
            textView.userInteractionEnabled = true;
            textView.font = UIFont.systemFontOfSize(14)
            textView.scrollEnabled = true;
            textView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
//            textView.textAlignment = NSTextAlignment.Left
            textView.placeholder = "内容"
            textView.textColor = UIColor.lightGrayColor()
            
            var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
            self.view.addGestureRecognizer(tapDismiss)
            
            self.pic_wight = (self.view.frame.width-6*10)/5
            
            addPic = UIButton(frame: CGRectMake(0, self.textView.frame.origin.y+self.textView.frame.size.height+5, pic_wight, pic_wight))
            addPic.setImage(UIImage(named: "addImage"), forState: UIControlState.Normal)
            addPic.addTarget(self, action: "addPicAction", forControlEvents: UIControlEvents.TouchUpInside)
            
            image_button += [addPic]
            
            content_view.addSubview(textField)
            content_view.addSubview(textView)
            content_view.addSubview(addPic)
            
            self.view.addSubview(content_view)
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
//        if (textView.text == "") {
//            textView.text = "内容"
//            textView.textColor = UIColor.lightGrayColor()
//        }
    }
    
    func textViewDidBeginEditing(textView: UITextView){
//        if (textView.text == "内容"){
//            textView.text = ""
//            textView.textColor = UIColor.blackColor()
//        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.textView.scrollRangeToVisible(self.textView.selectedRange)
    }
    
    func addPicAction() {
        println("addpics")
        MobClick.event("sendTalkPage", attributes: ["type":"addPic","result":"all"])
        if(self.image_button.count >= 5){
            MCUtils.showCustomHUD("最多同时支持四张图片上传", aType: .Error)
        }else{
            
            
            
            var appearanceConfig = UzysAppearanceConfig()
            appearanceConfig.finishSelectionButtonColor = UIColor.greenColor()
            UzysAssetsPickerController.setUpAppearanceConfig(appearanceConfig)
            
            var picker = UzysAssetsPickerController()
            picker.delegate = self
            picker.maximumNumberOfSelectionVideo = 0;
            picker.maximumNumberOfSelectionPhoto = 4-self.image_array.count;
            
            self.presentViewController(picker, animated: true, completion: nil)
        }

        
    }
    
    
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {
        
        if(assets.count != 0){
            var assets_array = assets as NSArray
            assets_array.enumerateObjectsUsingBlock({ obj, index, stop in
                println(index)
                var representation:ALAsset = obj as! ALAsset
                var returnImg = UIImage(CGImage: representation.defaultRepresentation().fullResolutionImage().takeUnretainedValue(), scale:CGFloat(representation.defaultRepresentation().scale()), orientation:UIImageOrientation(rawValue: representation.defaultRepresentation().orientation().rawValue)!)
                
                var image_x = CGFloat(self.image_button.count-1)*(self.pic_wight+10)
                
                var img_btn = UIButton(frame: CGRectMake(image_x, self.addPic.frame.origin.y
                    , self.pic_wight, self.pic_wight))
                
                img_btn.setImage(returnImg, forState: UIControlState.Normal)
                img_btn.addTarget(self, action: "removeImg:", forControlEvents: UIControlEvents.TouchUpInside)
                img_btn.tag = self.image_button_tag++
                self.image_button.insert(img_btn, atIndex: self.image_button.count-1)
                self.image_array += [returnImg!]
                self.image_button.last!.frame.origin.x = self.image_button.last!.frame.origin.x+self.pic_wight+10
                self.content_view.addSubview(img_btn)
                
            })
        }
        
        
        //        if(assets[0].valueForProperty(ALAssetPropertyType).isEqualToString(ALAssetTypePhoto)){
        //            [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //                ALAsset *representation = obj;
        //
        //                UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
        //                scale:representation.defaultRepresentation.scale
        //                orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
        //
        //                }];
        //        }
    }
    
    
    func uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection(picker: UzysAssetsPickerController!) {
        //UIAlertView(title: "", message: "图片已达到上限", delegate: self, cancelButtonTitle: "确定").show()
    }

    
//     func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
//        println("choose--------->>")
//        println(info)
//        
//        var image_x = CGFloat(image_button.count-1)*(self.pic_wight+10)
//        
//        var img_btn = UIButton(frame: CGRectMake(image_x, self.addPic.frame.origin.y
//            , self.pic_wight, self.pic_wight))
//        
//        var img = info[UIImagePickerControllerEditedImage] as! UIImage
//        img_btn.setImage(img, forState: UIControlState.Normal)
//        img_btn.addTarget(self, action: "removeImg:", forControlEvents: UIControlEvents.TouchUpInside)
//        img_btn.tag = self.image_button_tag++
//        
//        image_button.insert(img_btn, atIndex: image_button.count-1)
////        image_array += [ImageUtil.thumbnailWithImageWithoutScale(img, asize: CGSize(width: 620, height: 350))]
//        image_array += [img]
//        image_button.last!.frame.origin.x = image_button.last!.frame.origin.x+self.pic_wight+10
//        self.content_view.addSubview(img_btn)
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        
//        
//    }
    
    func removeImg(sender:UIButton) {
        
        MobClick.event("sendTalkPage", attributes: ["type":"removePic"])
        var selected_index:Int = 0
        println(sender.tag)
        for(var i=0;i<self.image_button.count;i++) {
            if(sender.tag == self.image_button[i].tag){
                selected_index = i
                break
            }
        }
        for(var i=0;i<self.image_button.count;i++){
            if(self.image_button[i].frame.origin.x>sender.frame.origin.x){
                self.image_button[i].frame.origin.x -= (self.pic_wight+10)
            }
        }
        sender.hidden = true
        self.image_button.removeAtIndex(selected_index)
        self.image_array.removeAtIndex(selected_index)

    }
    
//     func imagePickerControllerDidCancel(picker: UIImagePickerController){
//        
//        
//        println("cancel--------->>")
//        
//        
//        
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        
//        
//    }
    
    func dismissKeyboard(){
        self.textView.resignFirstResponder()
        self.textField.resignFirstResponder()
    }
    
    func initBigKinds(){
        var bigLable = UILabel(frame: CGRectMake(5, 65, 150, 20))
        bigLable.text = "请选择版块类型"
        bigLable.font = UIFont.systemFontOfSize(14)
        bigLable.textColor = UIColor.grayColor()
        self.view.addSubview(bigLable)
        
        
        
        if(forumName != nil){
            var button_wight = (self.view.frame.width-50)/4
            for(var i = 0;i<forumName.count;i++){
                var flag = i/4
                
                var forum_Id = forumName[i]["id"].intValue
                var forum_Name = forumName[i]["name"].stringValue
                var btn_height = bigLable.frame.origin.y+bigLable.frame.size.height+5
                var btn_wight = CGFloat((i+1)*10)+(button_wight * CGFloat(i))
                if(flag != 0) {
                    btn_height = btn_height + CGFloat(flag)*20 + CGFloat(flag)*5
                    btn_wight = btn_wight - CGFloat(flag)*self.view.frame.width + CGFloat(flag)*10
                    
                }

                
                var big_btn = UIButton(frame: CGRectMake(btn_wight,btn_height , button_wight, 20))
                big_btn.titleLabel?.font = UIFont.systemFontOfSize(10)
                big_btn.setTitle(forum_Name, forState: UIControlState.Normal)
                big_btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
                big_btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                big_btn.backgroundColor = UIColor.lightGrayColor()
                big_btn.tag = forum_Id
                big_btn.addTarget(self, action: "clickBigKinds:", forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(big_btn)
                
                self.small_height = btn_height

            }
        }else{
            self.rightButton?.enabled = false
        }
        
    }
    
    func clickBigKinds(sender:UIButton) {
        println(sender.titleLabel?.text!)
        self.forumType_id = sender.tag
        self.forumType_name = sender.titleLabel?.text
        sender.setBackgroundImage(UIImage(named: "post_big_select"), forState: .Selected)
        sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        sender.selected = true
        if(self.big_last != nil){
            self.big_last.selected = false
        }
        self.big_last = sender
        showSmallKinds()
    }
    
    func showSmallKinds(){
        if(self.small_view != nil){
            self.small_view.removeFromSuperview()
        }
        
        small_view = UIView(frame: CGRectMake(0, small_height+20, self.view.frame.width-20, 70))
        small_view.alpha = 0
        
        var smallLable = UILabel(frame: CGRectMake(5, 0, 150, 20))
        smallLable.text = "请选择发帖类型"
        smallLable.font = UIFont.systemFontOfSize(14)
        smallLable.textColor = UIColor.grayColor()
        small_view.addSubview(smallLable)
        
        for(var i = 0;i<forumName.count;i++) {
            if(self.forumType_id == forumName[i]["id"].intValue){
                self.typeJson = forumName[i]["includeType"].array
                break
            }
        }
        
        if(self.typeJson != nil){
            var button_wight = (self.view.frame.width-50)/4
            for(var i = 0;i<self.typeJson.count;i++){
                var flag = i/4
                
                var smallId = self.typeJson[i]["smallId"].intValue
                var smallName = self.typeJson[i]["smallName"].stringValue
                var btn_height = smallLable.frame.origin.y+smallLable.frame.size.height+5
                var btn_wight = CGFloat((i+1)*10)+(button_wight * CGFloat(i))
                if(flag != 0) {
                    btn_height = btn_height + CGFloat(flag)*20 + CGFloat(flag)*5
                    btn_wight = btn_wight - CGFloat(flag)*self.view.frame.width + CGFloat(flag)*10
                    
                }
                
                var small_btn = UIButton(frame: CGRectMake(btn_wight,btn_height , button_wight, 20))
                small_btn.userInteractionEnabled = true
                small_btn.titleLabel?.font = UIFont.systemFontOfSize(10)
                small_btn.setTitle(smallName, forState: UIControlState.Normal)
                small_btn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
                small_btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                small_btn.backgroundColor = UIColor.lightGrayColor()
                small_btn.tag = smallId
                small_btn.addTarget(self, action: "clicksmallKinds:", forControlEvents: UIControlEvents.TouchUpInside)
                small_view.addSubview(small_btn)
                small_view_height = btn_height
            }
            
        }
        
        


        self.view.addSubview(small_view)
        
        
        UIView.animateWithDuration(0.5, animations: {
            UIView.setAnimationBeginsFromCurrentState(true)
            self.small_view.alpha = 1
            if(self.isFirst == true){
                println(self.small_view_height+20)
                self.content_view.frame = CGRectMake(0,self.content_view.frame.origin.y+70, self.content_view.frame.width ,self.content_view.frame.height)
            }

            
        })
        isFirst = false
    }
    
    
    func clicksmallKinds(sender:UIButton) {
        println("clicksmallKinds")
        self.type_id = sender.tag
        self.type_name = sender.titleLabel?.text
        sender.selected = true
        sender.setBackgroundImage(UIImage(named: "post_big_select"), forState: .Selected)
        sender.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        if(self.small_last != nil){
            self.small_last.selected = false
        }
        self.small_last = sender
    }
    
    
    func setRightBarButtonItem() {
        self.rightButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        self.rightButton!.frame=CGRectMake(0,0,item_wight,item_height)
        self.rightButton?.titleLabel?.font = UIFont.systemFontOfSize(16)
        self.rightButton!.setTitle("发表", forState: UIControlState.Normal)
        self.rightButton!.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
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
        println("send talk")
        

        MobClick.event("sendTalkPage", attributes: ["type":"send","result":"all"])
        
        self.rightButton?.enabled = false

        
        forumId_post = self.forumType_id
        forumName_post = self.forumType_name
        talkTypeId_post = self.type_id
        talkTypeName_post = self.type_name
        
        talkTitle_post = self.textField.text
        content_post = self.textView.text
        
        if(forumName_post == nil || forumName_post.isEmpty){
            MCUtils.showCustomHUD("请选择版块类型", aType: .Error)
            self.rightButton?.enabled = true
            return
        }
        
        if(talkTypeName_post == nil || talkTypeName_post.isEmpty){
            MCUtils.showCustomHUD("请选择帖子类型", aType: .Error)
            self.rightButton?.enabled = true
            return
        }
        
        if(talkTitle_post == nil || talkTitle_post.isEmpty || count(talkTitle_post)<5){
            MCUtils.showCustomHUD("帖子标题不能少于5个字符", aType: .Error)
            self.rightButton?.enabled = true
            return
        }
        
        if(content_post == nil || content_post.isEmpty || content_post == "内容" || count(content_post)<15){
            MCUtils.showCustomHUD("发帖内容不能少于15个字符", aType: .Error)
            self.rightButton?.enabled = true
            return
        }
        
        
        
        
        self.progress = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        self.progress.labelText = "正在发送"
        
        if(self.image_array.count != 0){
            
            manager.POST(upload_url,
                parameters:nil,
                constructingBodyWithBlock: { (formData:AFMultipartFormData!) in
                    
                    for(var i=0;i<self.image_array.count;i++){
                        var key = "file"+String(i)
                        var value = "fileName"+String(i)+".jpg"
                        var imageData = UIImageJPEGRepresentation(self.image_array[i], 0.0)
                        
                        formData.appendPartWithFileData(imageData, name: key, fileName: value, mimeType: "image/jpeg")
                    }
                    
                    
                },
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    var json = JSON(responseObject)
                    if "ok" == json["state"].stringValue {
                        println(json["msg"])
                        self.content_post! += json["msg"].stringValue
                        MobClick.event("sendTalkPage", attributes: ["type":"addPic","result":"success"])
                        self.postTalkToServer()
                        
                    }else{
                        self.rightButton?.enabled = true
                        self.progress.removeFromSuperview()
                        MCUtils.showCustomHUD("图片上传失败,请稍候再试", aType: .Error)
                        MobClick.event("sendTalkPage", attributes: ["type":"addPic","result":"error"])
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
                    println("Error: " + error.localizedDescription)
                    self.rightButton?.enabled = true
                    self.progress.removeFromSuperview()
                    MCUtils.showCustomHUD("图片上传失败,请稍候再试", aType: .Error)
                    MobClick.event("sendTalkPage", attributes: ["type":"addPic","result":"error"])
            })
            
        }else{
            self.postTalkToServer()
        }
        
     }
    
    
    func postTalkToServer() {

        let params = [
            "userId":String(stringInterpolationSegment: appUserIdSave),
            "forumId":String(self.forumId_post),
            "forumName":self.forumName_post,
            "talkTypeid":String(self.talkTypeId_post),
            "talkTypeName":self.talkTypeName_post,
            "talkTitle":self.talkTitle_post,
            "content":self.content_post,
            "device":"ios"
        ]
        
        manager.POST(addTalk_url,
            parameters: params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                
                if "ok" == json["state"].stringValue {
                    println(json["msg"])
                    var addTalkId = json["msg"].stringValue
                    self.progress.labelText = "发送成功"
                    MobClick.event("community",attributes: ["type":"sendTalk","result":"success"])
                    NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "returnPage", userInfo: nil, repeats: false)
//                    self.navigationController?.popViewControllerAnimated(true)
                    
                    MobClick.event("sendTalkPage", attributes: ["type":"send","result":"success"])
                    
                }else{
                    self.rightButton?.enabled = true
                    self.progress.removeFromSuperview()
                    MCUtils.showCustomHUD("帖子发送失败,请稍候再试", aType: .Error)
                    MobClick.event("community",attributes: ["type":"sendTalk","result":"error"])
                    MobClick.event("sendTalkPage", attributes: ["type":"send","result":"error"])
                }

            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.rightButton?.enabled = true
                self.progress.removeFromSuperview()
                MCUtils.showCustomHUD("帖子发送失败,请稍候再试", aType: .Error)
                MobClick.event("sendTalkPage", attributes: ["type":"send","result":"error"])
        })
        
        
        
    }
    
    func returnPage(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func keyboardDidShow(notification:NSNotification) {
        var userInfo: NSDictionary = notification.userInfo! as NSDictionary
        var v : NSValue = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        
        var keyHeight = v.CGRectValue().size.height
        var duration = userInfo.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
        var curve:NSNumber = userInfo.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
        var temp:UIViewAnimationCurve = UIViewAnimationCurve(rawValue: curve.integerValue)!
        

        
        UIView.animateWithDuration(duration.doubleValue, animations: {
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(temp)
            
            self.view.frame.origin = CGPointMake(0, -80)
            
        })
        
    }
    
    func keyboardDidHidden(notification:NSNotification) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.25)
        self.view.frame.origin = CGPointMake(0, 0)
        UIView.commitAnimations()
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func showSendTalkPage(fromNavigation:UINavigationController?){
        var sendTalk = UIStoryboard(name: "SendTalk", bundle: nil).instantiateViewControllerWithIdentifier("sendTalk") as! SendTalk
        if (fromNavigation != nil) {
            fromNavigation?.pushViewController(sendTalk, animated: true)
        } else {
            fromNavigation?.presentViewController(sendTalk, animated: true, completion: nil)
        }
        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
            MobClick.beginLogPageView("sendTalk")
            //注册键盘通知事件
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHidden:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    override func viewWillDisappear(animated: Bool) {
            MobClick.endLogPageView("sendTalk")
            NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}