//
//  avatar.swift
//  mckuai
//
//  Created by 夕阳 on 15/2/2.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class Avatar:UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate,UzysAssetsPickerControllerDelegate{
    
    var manager = AFHTTPRequestOperationManager()
    var imgPrex = "http://cdn.mckuai.com/images/iphone/"
    var isNew = false
    
    var isLocationPic = false
    
    var hud:MBProgressHUD?
    
    var chosedAvatar:String?{
        didSet{
            choseAvatar()
        }
    }
    var avatars = ["0.png","1.png","2.png","3.png","4.png","5.png","6.png","7.png","8.png","9.png","10.png","11.png","12.png","13.png","14.png"]
    
    @IBOutlet weak var avatar: UIImageView!
    
    @IBOutlet weak var avatarList: UICollectionView!
    
    var addPic:UIButton!
    override func viewDidLoad() {
        
        initNavigation()
        
        if chosedAvatar == nil {
            chosedAvatar = avatars[0]
        }else{
            choseAvatar()
        }
        
        avatarList.dataSource = self
        avatarList.delegate = self
        avatarList.scrollEnabled = false
        
        initAddPicButtton()
        
        
    }
    
    func initAddPicButtton(){
        var addLable = UILabel(frame: CGRectMake(20, self.avatarList.frame.size.height-180,150 , 25))
        addLable.text = "选择本地图片"
        addLable.textColor = UIColor(red: 0.263, green: 0.263, blue: 0.263, alpha: 1.00)
        self.view.addSubview(addLable)
        addPic = UIButton(frame: CGRectMake(10,self.avatarList.frame.size.height-140 , 60, 60))
        addPic.setImage(UIImage(named: "addImage"), forState: UIControlState.Normal)
        addPic.addTarget(self, action: "addPicAction", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addPic)
    }
    
    func addPicAction() {
        
        MobClick.event("headImgPage", attributes: ["type":"addPic","result":"all"])
        
        var appearanceConfig = UzysAppearanceConfig()
        appearanceConfig.finishSelectionButtonColor = UIColor.greenColor()
        UzysAssetsPickerController.setUpAppearanceConfig(appearanceConfig)
        
        var picker = UzysAssetsPickerController()
        picker.delegate = self
        picker.maximumNumberOfSelectionVideo = 0;
        picker.maximumNumberOfSelectionPhoto = 1;
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func uzysAssetsPickerController(picker: UzysAssetsPickerController!, didFinishPickingAssets assets: [AnyObject]!) {

        if(assets.count == 1){
            var assets_array = assets as NSArray
            assets_array.enumerateObjectsUsingBlock({ obj, index, stop in
//                println(index)
                var representation:ALAsset = obj as! ALAsset
                var returnImg = UIImage(CGImage: representation.thumbnail().takeUnretainedValue())
                
                self.avatar.image = returnImg
                
                self.isLocationPic = true
                self.isNew = true
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
        UIAlertView(title: "", message: "图片已达到上限", delegate: self, cancelButtonTitle: "确定").show()
    }
    
    
    
    
    
    func initNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let navigationTitleAttribute : NSDictionary = NSDictionary(objectsAndKeys: UIColor.whiteColor(),NSForegroundColorAttributeName)
        self.navigationController?.navigationBar.titleTextAttributes = navigationTitleAttribute as [NSObject : AnyObject]
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(red: 0.247, green: 0.812, blue: 0.333, alpha: 1.00))
        var back = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "backToPage")
        back.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = back
        self.navigationController?.interactivePopGestureRecognizer.delegate = self    // 启用 swipe back
        
        
        var sendButton = UIBarButtonItem()
        sendButton.title = "保存"
        sendButton.target = self
        sendButton.action = Selector("save")
        self.navigationItem.rightBarButtonItem = sendButton
    }
    
    func backToPage() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func postHeadInfoToServer() {
        if(chosedAvatar != nil){
            let dic = [
                "flag" : NSString(string: "headImg"),
                "userId": appUserIdSave,
                "headImg" : chosedAvatar!
            ]
            
            manager.POST(saveUser_url,
                parameters: dic,
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    var json = JSON(responseObject)
                    
                    if "ok" == json["state"].stringValue {
                        MobClick.event("headImgPage", attributes: ["type":"savePic","result":"success"])
                        if(self.hud != nil){
                            self.hud?.hide(true)
                        }

                        MCUtils.showCustomHUD(self.view, title: "保存信息成功", imgName: "HUD_OK")
                        isLoginout = true
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{

                        if(self.hud != nil){
                            self.hud?.hide(true)
                        }
                        MobClick.event("headImgPage", attributes: ["type":"savePic","result":"error"])
                        MCUtils.showCustomHUD(self.view, title: "保存信息失败", imgName: "HUD_ERROR")
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
//                    println("Error: " + error.localizedDescription)

                    if(self.hud != nil){
                        self.hud?.hide(true)
                    }
                    MobClick.event("headImgPage", attributes: ["type":"savePic","result":"error"])
                    MCUtils.showCustomHUD(self.view, title: "保存信息失败", imgName: "HUD_ERROR")
            })
            
        }
    }
    
    func save(){
        
        MobClick.event("headImgPage", attributes: ["type":"savePic","result":"all"])
        if !isNew {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        if(self.isLocationPic == true){
            
            hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud?.labelText = "保存中..."
            manager.POST(upload_url,
                parameters:nil,
                constructingBodyWithBlock: { (formData:AFMultipartFormData!) in
                        var key = "fileHeadImg"
                        var value = "fileNameHeadImg.jpg"

                        var imageData = UIImageJPEGRepresentation(self.avatar.image, 1.0)
                        formData.appendPartWithFileData(imageData, name: key, fileName: value, mimeType: "image/jpeg")
                    
                },
                success: { (operation: AFHTTPRequestOperation!,
                    responseObject: AnyObject!) in
                    var json = JSON(responseObject)
                    if "ok" == json["state"].stringValue {
                        println(json["msg"])
                        self.chosedAvatar = json["msg"].stringValue
                        MobClick.event("headImgPage", attributes: ["type":"addPic","result":"success"])
                        self.postHeadInfoToServer()
                        
                    }else{
                        self.hud?.hide(true)
                        MCUtils.showCustomHUD(self.view, title: "图片上传失败,请稍候再试", imgName: "HUD_ERROR")
                        MobClick.event("headImgPage", attributes: ["type":"addPic","result":"error"])
                    }
                    
                },
                failure: { (operation: AFHTTPRequestOperation!,
                    error: NSError!) in
//                    println("Error: " + error.localizedDescription)
                    self.hud?.hide(true)
                    MCUtils.showCustomHUD(self.view, title: "图片上传失败,请稍候再试", imgName: "HUD_ERROR")
                    MobClick.event("headImgPage", attributes: ["type":"addPic","result":"error"])
            })
        }else{
            hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
            hud?.labelText = "保存中"
            self.postHeadInfoToServer()
        }
        

    }
    func choseAvatar(){
        if chosedAvatar == nil || self.avatar == nil {
            return
        }

        var a_url = chosedAvatar!.hasPrefix("http://") ? chosedAvatar! : imgPrex + chosedAvatar!

        self.avatar.sd_setImageWithURL(NSURL(string: a_url))
        
//        GTUtil.loadImage( a_url, callback: {
//            (img:UIImage?)->Void in
//            self.avatar.image = img
//        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        chosedAvatar = avatars[indexPath.row]
        isNew = true
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.frame.size.height = CGFloat(50 * avatars.count)
        return avatars.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var chosing = collectionView.dequeueReusableCellWithReuseIdentifier("avt", forIndexPath: indexPath) as! AvatarHolder
        chosing.url = imgPrex + avatars[indexPath.row]
        return chosing
    }
    
    
    class func changeAvatar(ctl:UINavigationController,url:String?){
        var avatar_view = UIStoryboard(name: "profile_layout", bundle: nil).instantiateViewControllerWithIdentifier("avatar_chose") as! Avatar
        avatar_view.chosedAvatar = url
        ctl.pushViewController(avatar_view, animated: true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        MobClick.beginLogPageView("userInfoSetHeadImg")
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("userInfoSetHeadImg")
    }
    
    
}

class AvatarHolder:UICollectionViewCell{
    
    @IBOutlet weak var holder: UIImageView!
    var url:String?{
        didSet{
            
            self.holder.sd_setImageWithURL(NSURL(string: url!))
        }
    }
    
    
    
    
}