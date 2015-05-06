//
//  mainTableViewCell.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/17.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mainTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var replys: UIButton!
    @IBOutlet weak var userName: UIButton!
    @IBOutlet weak var liveType: UIButton!
    @IBOutlet weak var liveStatus: UIButton!
    //var midBtn: UIView!
//    这两句话有什么用
//    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//    }
//    
//    required init(coder decoder: NSCoder) {
//        super.init(coder: decoder)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    func update(json: JSON, iType: Int) {
        self.title.text = json["talkTitle"].stringValue
        self.title.sizeOfMultiLineLabel()
        self.replys.setTitle(json["replyNum"].stringValue, forState: .Normal)
        switch iType {
        case 0:
            self.userName.setTitle(json["userName"].stringValue, forState: .Normal)
            var headImg = json["headImg"].stringValue
            self.userName.sd_setImageWithURL(NSURL(string: headImg), forState: .Normal, placeholderImage: UIImage(named: "first_normal"), completed: { img,_,_,_ in
                var rect = CGRectMake(0, 0, 20, 20)
                UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
                img.drawInRect(rect)
                var newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.userName.setImage(newImage, forState: .Normal)
            })
            
            //self.userName.setImage(MCUtils.getHeadImg(headImg, rect: CGRectMake(0, 0, 20, 20)), forState: .Normal)
            self.liveType.setTitle(json["talkType"].stringValue, forState: .Normal)
            if let url = json["mobilePic"].string {
                self.imageV.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder"))
            }
            
            if json["isLive"].boolValue {
                self.liveStatus.setTitle("正在直播", forState: .Normal)
            } else {
                self.liveStatus.setTitle("暂停直播", forState: .Normal)
            }
        default:
            var icon = json["icon"].stringValue
            
            self.userName.sd_setImageWithURL(NSURL(string: icon), forState: .Normal, placeholderImage: UIImage(named: "first_normal"), completed: { img,_,_,_ in
                var rect = CGRectMake(0, 0, 20, 20)
                UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
                img.drawInRect(rect)
                var newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.userName.setImage(newImage, forState: .Normal)
            })
            
            //self.userName.setImage(MCUtils.getHeadImg(icon, rect: CGRectMake(0, 0, 20, 20)), forState: .Normal)
            self.userName.setTitle(json["forumName"].stringValue, forState: .Normal)
            self.liveType.setTitle(json["replyNum"].stringValue, forState: .Normal)
            self.liveType.setImage(UIImage(named: "replys"), forState: .Normal)
            self.liveStatus.setTitle(MCUtils.compDate(json["replyTime"].stringValue), forState: .Normal)
            self.liveStatus.setImage(UIImage.applicationCreateImageWithColor(UIColor.whiteColor()), forState: .Normal)
            if let url = json["mobilePic"].string {
                self.imageV.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.replys.titleEdgeInsets = UIEdgeInsetsMake(-2, 2, 0, 0)
        // Configure the view for the selected state
    }
    
}
