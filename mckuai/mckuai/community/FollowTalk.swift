//
//  FollowTalk.swift
//  mckuai
//
//  Created by 陈强 on 15/5/6.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit


class FollowTalk: UIViewController,UITextViewDelegate,UzysAssetsPickerControllerDelegate, UIGestureRecognizerDelegate {

    var manager = AFHTTPRequestOperationManager()
    var progress = MBProgressHUD()
    var params = [String: String]()
    var fromViewController:UIViewController!
    var textView:UITextView!
    var pic_wight:CGFloat!
    var addPic:UIButton!
    var image_array = [UIImage]()
    
    var image_button = [UIButton]()
    
    var image_button_tag:Int = 0
    
    var sendButton:UIBarButtonItem!
    
    var content:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pic_wight = (self.view.frame.width-6*10)/5
        
        sendButton = UIBarButtonItem()
        sendButton.title = "发送"
        sendButton.target = self
        sendButton.action = Selector("send")
        self.navigationItem.rightBarButtonItem = sendButton
        initTextView()
        initimage()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func initTextView() {
        self.textView = UITextView(frame: CGRectMake(0, 0,self.view.frame.width, self.view.frame.height-pic_wight-5-260))
        self.textView.delegate = self
//                    textView.layer.borderColor = UIColor.grayColor().CGColor;
        //            textView.layer.borderWidth = 1;
        textView.userInteractionEnabled = true;
        textView.font = UIFont.systemFontOfSize(14)
        textView.scrollEnabled = true;
        textView.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        textView.textAlignment = NSTextAlignment.Left
        textView.text = "内容..."
        textView.textColor = UIColor.lightGrayColor()
//        textView.backgroundColor = UIColor.greenColor()
        var tapDismiss = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tapDismiss)
        self.view.addSubview(self.textView)
        
        self.textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if (textView.text == "") {
            textView.text = "内容..."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        if (textView.text == "内容..."){
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        self.textView.scrollRangeToVisible(self.textView.selectedRange)
    }
    
    
    func dismissKeyboard(){
        self.textView.resignFirstResponder()
    }
    
    func initimage() {
        
        
        addPic = UIButton(frame: CGRectMake(10, self.textView.frame.origin.y+self.textView.frame.size.height+5, pic_wight, pic_wight))
        addPic.setImage(UIImage(named: "addImage"), forState: UIControlState.Normal)
        addPic.addTarget(self, action: "addPicAction", forControlEvents: UIControlEvents.TouchUpInside)
        image_button += [addPic]
        self.view.addSubview(addPic)
    }
    
    func removeImg(sender:UIButton) {
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
    
    func addPicAction() {
        
        MobClick.event("followTalkPage", attributes: ["type":"addpic","result":"all"])
        if(self.image_button.count >= 5){
            MCUtils.showCustomHUD(self.view, title: "最多同时支持四张图片上传", imgName: "HUD_ERROR")
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
                var returnImg = UIImage(CGImage: representation.defaultRepresentation().fullScreenImage().takeUnretainedValue(), scale:CGFloat(representation.defaultRepresentation().scale()), orientation:UIImageOrientation(rawValue: representation.defaultRepresentation().orientation().rawValue)!)
                
                
                var image_x = CGFloat(self.image_button.count-1)*(self.pic_wight+10)+10
                
                var img_btn = UIButton(frame: CGRectMake(image_x, self.addPic.frame.origin.y
                    , self.pic_wight, self.pic_wight))
                
                img_btn.setImage(returnImg, forState: UIControlState.Normal)
                img_btn.addTarget(self, action: "removeImg:", forControlEvents: UIControlEvents.TouchUpInside)
                img_btn.tag = self.image_button_tag++
                self.image_button.insert(img_btn, atIndex: self.image_button.count-1)
                self.image_array += [returnImg!]
                self.image_button.last!.frame.origin.x = self.image_button.last!.frame.origin.x+self.pic_wight+10
                self.view.addSubview(img_btn)
                
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
        var alertView = UIAlertView(title: "", message: "图片已达到上限", delegate: self, cancelButtonTitle: "确定").show()
    }
    
    
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
//        println("choose--------->>")
//        println(info)
//        
//        var image_x = CGFloat(image_button.count-1)*(self.pic_wight+10)+10
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
//        //        image_array += [ImageUtil.thumbnailWithImageWithoutScale(img, asize: CGSize(width: 620, height: 350))]
//        image_array += [img]
//        image_button.last!.frame.origin.x = image_button.last!.frame.origin.x+self.pic_wight+10
//        self.view.addSubview(img_btn)
//        picker.dismissViewControllerAnimated(true, completion: nil)
//        
//        
//    }
    
//    func imagePickerControllerDidCancel(picker: UIImagePickerController){
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

    
    func send() {
        
        
        MobClick.event("followTalkPage", attributes: ["type":"send","result":"all"])
        
        self.sendButton.enabled = false
        content = self.textView.text
        if(content == nil || content.isEmpty || content == "内容..."){
            MCUtils.showCustomHUD(self.view, title: "跟贴的内容不能为空", imgName:  "HUD_ERROR")
            self.sendButton.enabled = true
            return
        }
        
        
        
        
        if(self.params.count != 0) {

            
            progress = MBProgressHUD.showHUDAddedTo(view, animated: true)
            progress.labelText = "正在发送"
            
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
                            self.content! += json["msg"].stringValue
                            
                            self.postTalkToServer()
                            MobClick.event("followTalkPage", attributes: ["type":"addpic","result":"success"])
                        }else{
                            self.sendButton?.enabled = true
                            self.progress.removeFromSuperview()
                            MCUtils.showCustomHUD(self.view, title: "图片上传失败,请稍候再试", imgName: "HUD_ERROR")
                            MobClick.event("followTalkPage", attributes: ["type":"addpic","result":"error"])
                        }
                        
                    },
                    failure: { (operation: AFHTTPRequestOperation!,
                        error: NSError!) in
                        println("Error: " + error.localizedDescription)
                        self.progress.removeFromSuperview()
                        MCUtils.showCustomHUD(self.view, title: "图片上传失败,请稍候再试", imgName: "HUD_ERROR")
                        MobClick.event("followTalkPage", attributes: ["type":"addpic","result":"error"])
                })
            }else{
                self.postTalkToServer()
            }
        
        }
        
    }
    
    
    func postTalkToServer() {
        
        self.params["content"] = content
        self.params["device"] = "ios"
        self.params["userId"] = String(stringInterpolationSegment: appUserIdSave)
        
        manager.POST(followTalk_url,
            parameters: self.params,
            success: { (operation: AFHTTPRequestOperation!,
                responseObject: AnyObject!) in
                var json = JSON(responseObject)
                
                if "ok" == json["state"].stringValue {
                    self.progress.labelText = "发送成功"
                    NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "returnPage", userInfo: nil, repeats: false)
                    MobClick.event("followTalkPage", attributes: ["type":"send","result":"success"])
                    
                }else{
                    self.sendButton?.enabled = true
                    self.progress.removeFromSuperview()
                    MCUtils.showCustomHUD(self.view, title: "跟贴失败,请稍候再试", imgName: "HUD_ERROR")
                    MobClick.event("followTalkPage", attributes: ["type":"send","result":"error"])
                }
                
            },
            failure: { (operation: AFHTTPRequestOperation!,
                error: NSError!) in
                println("Error: " + error.localizedDescription)
                self.sendButton?.enabled = true
                self.progress.removeFromSuperview()
                MCUtils.showCustomHUD(self.view, title: "跟贴失败,请稍候再试", imgName: "HUD_ERROR")
                MobClick.event("followTalkPage", attributes: ["type":"send","result":"error"])
        })
    }
    
    
    func returnPage() {
        if self.params["isOver"] == "yes" {
            (self.fromViewController as! TalkDetail).afterReply()
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    class func showFollowTalkView(ctl:UINavigationController?,dict: [String: String]!,viewController:UIViewController){
        var followTalkView = UIStoryboard(name: "FollowTalk", bundle: nil).instantiateViewControllerWithIdentifier("followTalk") as! FollowTalk
        followTalkView.params = dict
        followTalkView.fromViewController = viewController
        if (ctl != nil) {
            ctl?.pushViewController(followTalkView, animated: true)
        } else {
            ctl?.presentViewController(followTalkView, animated: true, completion: nil)
        }
        
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("followTalk")
        
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("followTalk")
    }
    
}