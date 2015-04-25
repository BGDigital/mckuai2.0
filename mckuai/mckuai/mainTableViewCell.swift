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
    @IBOutlet weak var imageAlpha: UIView!
    @IBOutlet weak var replys: UIButton!
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
        self.title.text = json["title"].stringValue+"UITableView个人使用总结【前篇-增量加载】 - John.Lv - 博客园"
        self.title.sizeOfMultiLineLabel()
        //self.desc.text = json["shortDres"].stringValue
        //self.replys.text = json["talkNum"].stringValue
        var url = json["imgUrl"].stringValue
        self.imageV.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder"))
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
