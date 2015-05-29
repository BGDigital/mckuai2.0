//
//  messageCell.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/24.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

enum talkType {
    case talk_reply_by_other
}

class messageCell: UITableViewCell {

    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var message1: UILabel!
    var sysImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.username.imageView?.layer.masksToBounds = true
        self.username.imageView?.layer.cornerRadius = 10
        self.username.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 0)
        // Initialization code
    }
    
    //取消这个函数,不用了
    private func setHtmlText(title: String, text: String) {
        var html: NSString = "<font size = 4, color=#A2A3A4>"+title+"</font><br><font size=4, color=#4D4E4F>" + text + "</font>"
        var commentsRequested: NSAttributedString!
        Async.background {
            commentsRequested = NSAttributedString(
                data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil,
                error: nil)
        } .main {
            self.message.attributedText = commentsRequested
        }
    }

    private func setLabelFrame(str: String) {
        self.message.numberOfLines = 2
        self.message.textColor = UIColor(hexString: "#4C4D4E")
        self.message1.hidden = true

        self.message.text = str
        self.message.sizeOfMultiLineLabel()
    }
    
    private func setLabelFrame(str1: String, str2: String) {
        self.message.numberOfLines = 1
        self.message.textColor = UIColor(hexString: "#A4A5A6")
        self.message1.hidden = false
        self.message.text = "《" + str1 + "》"
        self.message1.text = str2
    }
    
    private func addSystemNoteImg() {
        sysImg = UIImageView(frame: CGRectMake(self.bounds.size.width-45-8, self.bounds.size.height-45, 45, 45))
        sysImg.image = UIImage(named: "second_selected")
        self.contentView.addSubview(sysImg)
    }
    
    //这里只处理消息和动态两种类型
    func update(json: JSON, iType: String, sMsgType: String) {
        switch iType {
        case "message":
            switch sMsgType {
            case "reply":
                var sText = self.getMsgType(json["type"].stringValue)
                var str = json["userName"].stringValue + sText
                self.username.setTitle(str, forState: .Normal)
                var Avatar = json["headImg"].stringValue
                self.username.sd_setImageWithURL(NSURL(string: Avatar), forState: .Normal, placeholderImage: DefaultUserAvatar_small!, completed: { img,_,_,_ in
                    if img != nil {
                        var rect = CGRectMake(0, 0, 20, 20)
                        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
                        img.drawInRect(rect)
                        var newImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        self.username.setImage(newImage, forState: .Normal)
                    }
                })
                self.time.text = MCUtils.compDate(json["insertTime"].stringValue)
                setLabelFrame(json["talkTitle"].stringValue, str2: json["cont"].stringValue)
            default:  //system
                var Avatar = json["headImg"].stringValue
                self.username.sd_setImageWithURL(NSURL(string: Avatar), forState: .Normal, placeholderImage: DefaultUserAvatar_small!, completed: { img,_,_,_ in
                    if img != nil {
                        var rect = CGRectMake(0, 0, 20, 20)
                        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
                        img.drawInRect(rect)
                        var newImage = UIGraphicsGetImageFromCurrentImageContext()
                        UIGraphicsEndImageContext()
                        self.username.setImage(newImage, forState: .Normal)
                    }
                })
                self.username.setTitle("系统消息", forState: .Normal)
                self.time.text = MCUtils.compDate(json["insertTime"].stringValue)
                setLabelFrame(json["showText"].stringValue)
                //如果是系统信息,添加一个小图标
                //addSystemNoteImg()
            }
        case "dynamic":
            self.username.imageView?.layer.masksToBounds = false
            var sText = self.getMsgType(json["type"].stringValue)
            self.username.setTitle(sText, forState: .Normal)
            if json["type"].stringValue == "talk_reply" {
                self.username.setImage(UIImage(named: "mine_reply"), forState: .Normal)
            } else {
                self.username.setImage(UIImage(named: "mine_create"), forState: .Normal)
            }
            self.time.text = MCUtils.compDate(json["insertTime"].stringValue)
            setLabelFrame(json["talkTitle"].stringValue, str2: json["cont"].stringValue)
        case "work":
            break
        default:
            break
        }
        
        
        
        //var url = json["imgUrl"].stringValue
        //self.imageV.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "loading"))
    }
    
    private func getMsgType(s: String) -> String {
        switch s {
        case "talk_reply_by_other":
            return "  回复你的帖子"
        case "talk_reply":
            return "回复了"
        case "talk_add":
            return "创造了"
        default:
            return "  @了你"
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .None

        // Configure the view for the selected state
    }
    
}
