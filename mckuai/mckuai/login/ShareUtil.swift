//
//  ShareUtil.swift
//  mckuai
//
//  Created by 陈强 on 15/4/23.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//


import Foundation
import UIKit

let UMAppKey = "5538b66767e58e1165003a77"
let qq_AppId = "101155101"
let qq_AppKey = "78b7e42e255512d6492dfd135037c91c"
let wx_AppId = "wx49ba2c7147d2368d"
let wx_AppKey = "85aa75ddb9b37d47698f24417a373134"
let share_url = "http://www.mckuai.com"
let shareToNames : [AnyObject] = [UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]
class ShareUtil {
    
    class func shareInitWithTextAndPicture(controller: UIViewController,text:String,image:UIImage,callDelegate:UMSocialUIDelegate) {
        
        UMSocialConfig.setFinishToastIsHidden(true, position: UMSocialiToastPositionTop)
        
        UMSocialData.defaultData().extConfig.qzoneData.title = "麦块for我的世界"
        UMSocialData.defaultData().extConfig.qqData.title = "麦块for我的世界"
        UMSocialData.defaultData().extConfig.wechatSessionData.title = "麦块for我的世界"
        UMSocialData.defaultData().extConfig.wechatTimelineData.title = "麦块for我的世界"
        
        UMSocialData.defaultData().extConfig.qzoneData.url = "http://www.mckuai.com";
        UMSocialData.defaultData().extConfig.qqData.url = "http://www.mckuai.com";
        UMSocialData.defaultData().extConfig.wechatSessionData.url = "http://www.mckuai.com";
        UMSocialData.defaultData().extConfig.wechatTimelineData.url = "http://www.mckuai.com";
        UMSocialSnsService.presentSnsIconSheetView(controller, appKey: UMAppKey, shareText: text, shareImage: image, shareToSnsNames: shareToNames, delegate:callDelegate)
    }
    
    
}
