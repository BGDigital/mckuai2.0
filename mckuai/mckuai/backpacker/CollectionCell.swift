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
        UIImageView().sd_setImageWithURL(NSURL(string: j["headImg"].stringValue), placeholderImage: UIImage(named: "Guide"), completed: {img,_,_,_ in
            self.roundProgressView.imageView = UIImageView(image: img)
        })

        self.roundProgressView.percent = CGFloat(j["process"].floatValue)
        self.nickname.text = j["nike"].stringValue
        self.locationCity.setTitle("成都", forState: .Normal)
        self.userId = j["id"].intValue
    }
    
}
