//
//  CollectionCell.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/28.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {

    @IBOutlet weak var roundProgressView: MFRoundProgressView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var locationCity: UIButton!
    var userId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(j: JSON) {
        self.roundProgressView.percent = CGFloat(j["process"].floatValue * 100)
        self.roundProgressView.imageUrl = j["headImg"].stringValue
        self.roundProgressView.level = j["level"].intValue
        self.nickname.text = j["nike"].stringValue
        var city: String!
        if let c = j["addr"].string {
            city = c
        } else {
            city  = "未定位"
        }
        self.locationCity.setTitle(city, forState: .Normal)
        self.userId = j["id"].intValue
    }
    
}
