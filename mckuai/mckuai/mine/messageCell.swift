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
    var sysImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    private func setHtmlText(title: String, text: String) {
        var html: NSString = "<font size = 4, color=#A2A3A4>"+title+"</font><br><font size=4, color=#4D4E4F>" + text + "</font>"
//        var commentsRequested: NSAttributedString!
//        Async.background {
//            commentsRequested = NSAttributedString(
//                data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
//                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
//                documentAttributes: nil,
//                error: nil)
//        } .main {
//            self.message.attributedText = commentsRequested
//        }
        //let commentsQueue:dispatch_queue_t = dispatch_queue_create("comments queue", nil)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            let commentsRequested = NSAttributedString(
                data: html.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
                options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil,
                error: nil)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.message.attributedText = commentsRequested
            })
        })
    }

    private func setLabelFrame(str: String) {
        self.message.text = str
        self.message.sizeOfMultiLineLabel()
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
                self.time.text = MCUtils.compDate(json["insertTime"].stringValue)
                setHtmlText("《" + json["talkTitle"].stringValue + "》", text: json["cont"].stringValue)
                //setLabelFrame("《" + json["talkTitle"].stringValue + "》\n" + json["cont"].stringValue)
            default:  //system
                self.username.setImage(UIImage(named: "Guide"), forState: .Normal)
                self.username.setTitle("系统消息", forState: .Normal)
                self.time.text = MCUtils.compDate(json["insertTime"].stringValue)
                setLabelFrame(json["showText"].stringValue)
                //如果是系统信息,添加一个小图标
                addSystemNoteImg()
            }
        case "dynamic":
            var sText = self.getMsgType(json["type"].stringValue)
            self.username.setTitle(sText, forState: .Normal)
            self.time.text = MCUtils.compDate(json["insertTime"].stringValue)
            setHtmlText("《" + json["talkTitle"].stringValue + "》", text: json["cont"].stringValue)
            //setLabelFrame("《" + json["talkTitle"].stringValue + "》\n" + json["cont"].stringValue)
        case "work":
            break
        default:
            break
        }
        
        
        
        //var url = json["imgUrl"].stringValue
        //self.imageV.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "placeholder"))
    }
    
    private func getMsgType(s: String) -> String {
        switch s {
        case "talk_reply_by_other":
            return "  回复你的贴子"
        case "talk_reply":
            return "回复了"
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
