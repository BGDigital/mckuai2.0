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
        self.username.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        
        //底部线  +50是为了滑动删除时样式的同步
        var linetop = UIView(frame: CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width+100, 0.5))
        linetop.backgroundColor = UIColor(hexString: "#E1E3E5")
        self.addSubview(linetop)
        
        var line1 = UIView(frame: CGRectMake(0, 8, self.frame.size.width+50, 0.5))
        line1.backgroundColor = UIColor(hexString: "#E1E3E5")
        self.addSubview(line1)
        
        var line = UIView(frame: CGRectMake(0, 0, self.frame.size.width+50, 8))
        line.backgroundColor = UIColor(hexString: "#EFF0F2")
        self.addSubview(line)
    }
    
    func update(json: JSON) {
//        println(json)
        self.title.text = json["talkTitle"].stringValue
        self.title.sizeOfMultiLineLabel()
        var imgPath = json["headImg"].string != nil ? json["headImg"].stringValue : json["icon"].stringValue
        var disName = json["userName"].string != nil ? json["userName"].stringValue : json["forumName"].stringValue
        if !imgPath.isEmpty {
            self.username.sd_setImageWithURL(NSURL(string: imgPath), forState: .Normal, placeholderImage: DefaultUserAvatar_small, completed: { img,_,_,url in
                if(img != nil){
                    var rect = CGRectMake(0, 0, 20, 20)
                    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
                        img.drawInRect(rect)
                    var newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    self.username.setImage(newImage, forState: .Normal)
                }
            })
        }
        self.username.setTitle(disName, forState: .Normal)
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
