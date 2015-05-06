//
//  ImageUtil.swift
//  mckuai
//
//  Created by 陈强 on 15/5/5.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class ImageUtil {
    

    //等比例
    class func thumbnailWithImageWithoutScale(image:UIImage!,asize:CGSize) -> UIImage{
        var newImage:UIImage!
        
        if(image == nil){
            newImage = nil
        }else{
            var oldsize:CGSize = image.size
            
            if(oldsize.width<=asize.width || oldsize.height<=asize.height){
                newImage = image
            }else{
                var rect:CGRect = CGRect()
                if (asize.width/asize.height > oldsize.width/oldsize.height) {
                    rect.size.width = asize.height*oldsize.width/oldsize.height;
                    rect.size.height = asize.height;
                    rect.origin.x = (asize.width - rect.size.width)/2;
                    rect.origin.y = 0;
                }
                else{
                    rect.size.width = asize.width;
                    rect.size.height = asize.width*oldsize.height/oldsize.width;
                    rect.origin.x = 0;
                    rect.origin.y = (asize.height - rect.size.height)/2;
                }
                
                UIGraphicsBeginImageContext(asize);
                var context:CGContextRef = UIGraphicsGetCurrentContext();
                CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor);
                UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
                image.drawInRect(rect)
                newImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
        }
        
        return newImage
    }
    
}