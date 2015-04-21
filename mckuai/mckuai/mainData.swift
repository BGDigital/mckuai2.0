//
//  mainData.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/17.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation

class Data {
    internal class entry {
        let title: String
        let picURL: String
        let replys: Int
        init(title: String, pic: String, reply: Int) {
            self.title = title
            self.picURL = pic
            self.replys = reply
        }
    }
    
    let Items = []
}
