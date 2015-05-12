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
    @IBOutlet weak var imgJian: UIImageView!
    @IBOutlet weak var imgJing: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
        self.username.imageView?.layer.masksToBounds = true
        self.username.imageView?.layer.cornerRadius = 10
        self.replys.titleEdgeInsets = UIEdgeInsetsMake(-2, 0, 0, 0)
        
        imgJian.hidden = true
        imgJing.hidden = true
        
        //底部线
        self.username.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        var line1 = UIView(frame: CGRectMake(0, self.frame.size.height-6, self.frame.size.width, 1))
        line1.backgroundColor = UIColor(hexString: "#E1E3E5")
        self.addSubview(line1)
        
        var line = UIView(frame: CGRectMake(0, self.frame.size.height-5, self.frame.size.width, 5))
        line.backgroundColor = UIColor(hexString: "#EFF0F2")
        self.addSubview(line)
    }
    
    func update(json: JSON) {
        self.title.text = json["talkTitle"].stringValue
        self.title.sizeOfMultiLineLabel()
        var icon = json["headImg"].stringValue
        if !icon.isEmpty {
            self.username.sd_setImageWithURL(NSURL(string: icon), forState: .Normal, placeholderImage: UIImage(named: "SmallAvatar"), completed: { img,_,_,url in
                var rect = CGRectMake(0, 0, 20, 20)
                UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
                if(img != nil){
                    img.drawInRect(rect)
                }
                
                var newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.username.setImage(newImage, forState: .Normal)
            })
        }
        self.username.setTitle(json["userName"].stringValue, forState: .Normal)
        self.replys.setTitle(json["replyNum"].stringValue, forState: .Normal)
        self.times.text = MCUtils.compDate(json["replyTime"].stringValue)
        imgJian.hidden = "1" == json["isDing"].stringValue
        imgJing.hidden = "1" == json["isJing"].stringValue
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
