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
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var liveView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .None
    }
    
    func update(json: JSON) {
        self.title.text = json["talkTitle"].stringValue
        self.title.sizeOfMultiLineLabel()
        self.username.setTitle(json["forumName"].stringValue, forState: .Normal)
        self.replys.setTitle(json["replyNum"].stringValue, forState: .Normal)
        self.times.text = MCUtils.compDate(json["replyTime"].stringValue)
        var url = json["mobilePic"].stringValue
        if !json["hasImg"].boolValue {
            self.title.textColor = UIColor.whiteColor()
            self.alphaView.hidden = false
            self.liveView.hidden = true
            self.imageV.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder"))
        } else {
            self.alphaView.hidden = true
            self.liveView.hidden = false
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
