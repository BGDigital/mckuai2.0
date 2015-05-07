//
//  mainSubCell.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/21.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mainSubCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var replys: UIButton!
    @IBOutlet weak var times: UILabel!
    var sign_jh, sign_tj: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        self.username.imageView?.layer.masksToBounds = true
        self.username.imageView?.layer.cornerRadius = 10
        self.replys.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0)
        
        //底部线
        self.username.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        var line = UIView(frame: CGRectMake(0, self.bounds.size.height-5, self.bounds.size.width, 5))
        line.backgroundColor = UIColor(hexString: "#EFF0F2")
        self.addSubview(line)
        //精华
        //self.sign_jh = UILabel(frame: CGRectMake(15, 0, 30, 15))
        self.sign_jh = UILabel(frame: CGRectMake(self.bounds.size.width-15, 20, 15, 15))
        sign_jh.backgroundColor = UIColor(hexString: "#40C84D")
        sign_jh.font = UIFont(name: sign_jh.font.fontName, size: 12)
        sign_jh.text = "精"
        sign_jh.textAlignment = .Center
        sign_jh.textColor = UIColor.whiteColor()
        self.addSubview(sign_jh)
        //推荐
//        self.sign_tj = UILabel(frame: CGRectMake(48, 0, 30, 15))
        self.sign_tj = UILabel(frame: CGRectMake(self.bounds.size.width-15, 38, 15, 15))
        sign_tj.backgroundColor = UIColor(hexString: "#FBA836")
        sign_tj.font = UIFont(name: sign_tj.font.fontName, size: 12)
        sign_tj.text = "荐"
        sign_tj.textAlignment = .Center
        sign_tj.textColor = UIColor.whiteColor()
        self.addSubview(sign_tj)

    }
    
    func update(json: JSON) {
        self.title.text = json["talkTitle"].stringValue
        self.title.sizeOfMultiLineLabel()
        var icon = json["headImg"].stringValue
        if !icon.isEmpty {
            self.username.sd_setImageWithURL(NSURL(string: icon), forState: .Normal, placeholderImage: UIImage(named: "Avatar"), completed: { img,_,_,url in
                println("imageUrl:\(url)")
                var rect = CGRectMake(0, 0, 20, 20)
                UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
                img.drawInRect(rect)
                var newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.username.setImage(newImage, forState: .Normal)
            })
        }
        self.username.setTitle(json["userName"].stringValue, forState: .Normal)
        self.replys.setTitle(json["replyNum"].stringValue, forState: .Normal)
        self.times.text = MCUtils.compDate(json["replyTime"].stringValue)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
