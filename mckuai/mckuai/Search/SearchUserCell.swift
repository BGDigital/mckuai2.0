//
//  SearchUserCell.swift
//  mckuai
//
//  Created by XingfuQiu on 15/5/11.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class SearchUserCell: UITableViewCell {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userNick: UILabel!
    @IBOutlet weak var userLevel: UILabel!
    @IBOutlet weak var userAddr: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userLevel.backgroundColor = UIColor(hexString: "#FCAA38")
        self.userLevel.layer.masksToBounds = true
        self.userLevel.layer.cornerRadius = 7
        
        self.userAvatar.layer.masksToBounds = true
        self.userAvatar.layer.cornerRadius = 25
        self.userAvatar.layer.borderColor = UIColor(hexString: "#000000", alpha: 0.1)!.CGColor
        self.userAvatar.layer.borderWidth = 1
        //self.username.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        
        //底部线
        var iWidth = UIScreen.mainScreen().bounds.size.width;
        var line = UIView(frame: CGRectMake(0, self.frame.size.height-1, iWidth, 1))
        line.backgroundColor = UIColor(hexString: "#EFF0F2")
        self.addSubview(line)
    }
    
    func update(j: JSON) {
//        println(j)
        self.userAvatar.sd_setImageWithURL(NSURL(string: j["headImg"].stringValue), placeholderImage: DefaultUserAvatar_big!)
        self.userNick.text = j["nike"].stringValue
        self.userLevel.text = "LV."+j["level"].stringValue
        if let address = j["addr"].string {
            self.userAddr.setTitle(address, forState: .Normal)
        } else {
            self.userAddr.setTitle("未定位", forState: .Normal)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .None
        // Configure the view for the selected state
    }

}
