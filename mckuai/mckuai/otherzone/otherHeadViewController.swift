//
//  otherHeadViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/29.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

protocol OtherProtocol {
    func onRefreshDataSource(iType: Int)
}

class otherHeadViewController: UIViewController {

    
    @IBOutlet weak var imageBg: SABlurImageView!
    @IBOutlet weak var roundProgressView: MFRoundProgressView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var locationCity: UIButton!
    @IBOutlet weak var btnDynamic: UIButton!
    @IBOutlet weak var btnWork: UIButton!
    var Delegate: OtherProtocol?
    var lastSelected: UIButton!
    var headImg: String!
    var userId = 0
    var userLevel = 0
    var username = ""
    
    //大类型,小类型都默认取1
    var bigType = 1   //1:动态,2:作品
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300)
        //模糊背景
        imageBg.addBlurEffect(30, times: 1)
        //初始化Button
        addSubTextToBtn("动态", parent: btnDynamic)
        addSubTextToBtn("作品", parent: btnWork)
        btnDynamic.selected = true
        lastSelected = btnDynamic
        //所在城市
        if let city = Defaults[D_CURRENTCITY].string {
            locationCity.setTitle(city, forState: .Normal)
        } else {
            locationCity.setTitle("未定位", forState: .Normal)
        }
    }
    
    func addSubTextToBtn(aText: String, parent: UIButton) {
        var selectedImg = UIImage.applicationCreateImageWithColor(UIColor(hexString: "#40C84D")!)
        parent.setBackgroundImage(selectedImg, forState: .Selected)
        parent.setTitleColor(UIColor.whiteColor(), forState: .Selected)
        parent.layer.masksToBounds = true
        parent.layer.cornerRadius = 25  //圆角,对.Selected没有效果?
        parent.tintColor = UIColor.clearColor()
        parent.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0)
        
        var lb = UILabel(frame: CGRectMake(0, btnDynamic.bounds.size.height-20, btnDynamic.bounds.size.width, 14))
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
        Delegate?.onRefreshDataSource(bigType)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //外面调用的函数
    func RefreshHead(J: JSON) {
        //圆形头像
        roundProgressView.percent = CGFloat(J["process"].floatValue * 100)
        roundProgressView.imageUrl = J["headImg"].stringValue
        self.roundProgressView.level = J["level"].intValue
        headImg = J["headImg"].stringValue
        nickname.text = J["nike"].stringValue
        if !headImg.isEmpty {
            imageBg.sd_setImageWithURL(NSURL(string: headImg), placeholderImage: UIImage(named: "Avatar"), completed: {image, error, cacheType, imageURL in
                //self.roundProgressView.imageView = UIImageView(image: image)
                self.imageBg.addBlurEffect(8, times: 1)
            })
        }
        btnDynamic.setTitle(J["dynamicNum"].stringValue, forState: .Normal)
        btnWork.setTitle(J["workNum"].stringValue, forState: .Normal)
    }

}
