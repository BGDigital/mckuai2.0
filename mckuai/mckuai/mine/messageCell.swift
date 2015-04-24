//
//  messageCell.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/24.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class messageCell: UITableViewCell {

    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    var sysImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func setLabelFrame(str: String) {
        self.message.text = str+"/字符串在指定区域内按照指定的字体显示时,需要的高度和宽度(宽度在字符串只有一行时有用)一般用法:指定区域的宽度而高度用MAXFLOAT,则返回值包含对应的高度"
        self.message.sizeOfMultiLineLabel()
    }
    
    private func addSystemNoteImg() {
        sysImg = UIImageView(frame: CGRectMake(self.bounds.size.width-45-8, self.bounds.size.height-45, 45, 45))
        sysImg.image = UIImage(named: "second_selected")
        self.contentView.addSubview(sysImg)
    }
    
    func update(json: JSON) {
        var str = json["userName"].stringValue + "  " + json["type"].stringValue
        self.username.setTitle(str, forState: .Normal)
        self.time.text = json["insertTime"].stringValue
        setLabelFrame(json["cont"].stringValue)
        
        //如果是系统信息,添加一个小图标
        addSystemNoteImg()
        //var url = json["imgUrl"].stringValue
        //self.imageV.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder"))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
