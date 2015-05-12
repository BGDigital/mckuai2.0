//
//  MBProgress.swift
//  mckuai
//
//  Created by 陈强 on 15/4/26.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
class MBProgress {
    
    //将url 的querystring 分离成dictionary
    
    class func getQueryDictionary(query:String) -> [String:String]{
        var components = query.componentsSeparatedByString("&")
        var rs = [String:String]()
        
        
        for p in components {
            var tmp = p.componentsSeparatedByString("=")
            if tmp.count < 2 {
                continue
            }
            var key = tmp[0]
            var val = tmp[1]
            rs[key] = val
        }
        
        return rs
    }
    
    
    //截取小数点后的数
    class func getStr(str: Double) -> String {
        let d = "\(str)"
        var result = ""
        for character in d {
            if (character == ".") {
                break
            } else {
                result = result+"\(character)"
            }
        }
        if result.toInt() == 0 {
            return "1"
        } else {
            return result
        }
    }
    
    //计算时间差
    class func compDate(beginStr: String) -> String {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = NSLocale(localeIdentifier: NSGregorianCalendar)
        let date = formatter.dateFromString(beginStr)
        if date == nil {
            return "时间格式出错"
        }
        var second:NSTimeInterval
        second = -date!.timeIntervalSinceNow
        if second < 60 {
            return "刚刚"
        } else if (second/60) < 60 {
            var tmp = second/60
            var s = getStr(tmp)
            return "\(s)分钟前"
        } else if (second/60/60) < 24 {
            var tmp = second/60/60
            var s = getStr(tmp)
            return "\(s)小时前"
        } else if (second/60/60/24) < 30 {
            var tmp = second/60/60/24
            var s = getStr(tmp)
            return "\(s)天前"
        } else if (second/60/60/24/30) < 12 {
            var tmp = second/60/60/24/30
            var s = getStr(tmp)
            return "\(s)月前"
        } else {
            var tmp = second/60/60/24/30/12
            var s = getStr(tmp)
            return "\(s)年前"
        }
    }
}