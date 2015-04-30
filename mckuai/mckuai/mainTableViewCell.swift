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
        self.replys.backgroundColor = UIColor(red: 0.251, green: 0.784, blue: 0.302, alpha: 1.00)
        self.replys.layer.cornerRadius = 2
        //println("I'm running! \(self.imageV.frame)")
//        midBtn = UIView(frame: self.imageV.frame)
//        self.midBtn.backgroundColor = UIColor.blackColor()
//        self.midBtn.alpha = 0.3
//        self.addSubview(self.midBtn)
    }
    
    func update(json: JSON) {
        self.title.text = json["talkTitle"].stringValue
        self.title.sizeOfMultiLineLabel()
        self.replys.setTitle(json["replyNum"].stringValue, forState: .Normal)
        self.userName.setTitle(json["userName"].stringValue, forState: .Normal)
        var headImg = json["headImg"].stringValue
        self.userName.setImage(MCUtils.getHeadImg(headImg, rect: CGRectMake(0, 0, 20, 20)), forState: .Normal)
        self.liveType.setTitle(json["talkType"].stringValue, forState: .Normal)
        var url = json["mobilePic"].stringValue
        self.imageV.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder"))
        
        if json["isLive"].boolValue {
            self.liveStatus.setTitle("正在直播", forState: .Normal)
        } else {
            self.liveStatus.setTitle("暂停直播", forState: .Normal)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
