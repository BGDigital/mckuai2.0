//
//  otherHeadViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/29.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class otherHeadViewController: UIViewController {

    
    @IBOutlet weak var imageBg: SABlurImageView!
    @IBOutlet weak var roundProgressView: MFRoundProgressView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var locationCity: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
    @IBOutlet weak var btnWork: UIButton!
    
    var lastSelected: UIButton!
    var headImg: String!
    var userId = 0
    var userLevel = 0
    var username = ""
    
    //大类型,小类型都默认取1
    var bigType = 1   //1:消息,2:动态,3:作品
    var smallType = 0  //0:All,1:@Me,2:系统
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300)
        //模糊背景
        imageBg.addBlurEffect(30, times: 1)
        //初始化Button
        addSubTextToBtn("动态", parent: btnMsg)
        addSubTextToBtn("作品", parent: btnWork)
        
        if let city = Defaults["CurrentCity"].string {
            locationCity.setTitle(city, forState: .Normal)
        } else {
            locationCity.setTitle("未定位", forState: .Normal)
        }
    }
    
    func addSubTextToBtn(aText: String, parent: UIButton) {
        var selectedImg = UIImage.applicationCreateImageWithColor(UIColor(hexString: "#40C84D")!)
        parent.setBackgroundImage(selectedImg, forState: .Selected)
        parent.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        //        parent.layer.cornerRadius = 30  //圆角,对.Selected没有效果?
        parent.tintColor = UIColor.clearColor()
        
        var lb = UILabel(frame: CGRectMake(0, btnMsg.bounds.size.height-20, btnMsg.bounds.size.width, 14))
        lb.text = aText
        lb.font = UIFont(name: lb.font.fontName, size: 12)
        lb.textColor = UIColor(hexString: "#BCABA8")
        lb.highlightedTextColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        parent.addSubview(lb)
    }
    
    //这个是大类型
    @IBAction func messageSelected(sender: UIButton) {
        sender.selected = true
        if lastSelected != nil && lastSelected != sender{
            lastSelected.selected = false
        }
        lastSelected = sender
        
        bigType = sender.tag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //外面调用的函数
    func RefreshHead(J: JSON) {
        //圆形头像
        roundProgressView.percent = 78
        headImg = J["headImg"].stringValue
        nickname.text = J["nike"].stringValue
        if !headImg.isEmpty {
            imageBg.sd_setImageWithURL(NSURL(string: headImg), placeholderImage: UIImage(named: "1024"), completed: {image, error, cacheType, imageURL in
                self.roundProgressView.imageView = UIImageView(image: image)
                self.imageBg.addBlurEffect(30, times: 1)
            })
            
            
        }
    }

}
