//
//  ShareUtil.swift
//  mckuai
//
//  Created by 陈强 on 15/4/23.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//


import Foundation
import UIKit

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
