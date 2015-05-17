//
//  mineHeadViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/23.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

protocol MineProtocol {
    func onRefreshDataSource(iType: Int, iMsgType: Int)
}

class mineHeadViewController: UIViewController, UMSocialUIDelegate {

    @IBOutlet weak var imageBg: SABlurImageView!
    @IBOutlet weak var roundProgressView: MFRoundProgressView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var locationCity: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
    @IBOutlet weak var btnDynamic: UIButton!
    @IBOutlet weak var btnWork: UIButton!
    var Delegate: MineProtocol?
    var parentVC: UIViewController!
    
    var lastSelected: UIButton!
    var segmentedControl: HMSegmentedControl!
    var headImg: String!
    var userId = 0
    var userLevel = 0
    var username = ""
    
    //大类型,小类型都默认取1
    var bigType = 1   //1:消息,2:动态,3:作品
    var smallType = 1  //0:为空,不用传,1:@Me,2:系统
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 325)
        initSegmentedControl()
        //初始化Button
        addSubTextToBtn("消息", parent: btnMsg)
        addSubTextToBtn("动态", parent: btnDynamic)
        addSubTextToBtn("作品", parent: btnWork)
        //设置消息为选中状态
        btnMsg.selected = true
        lastSelected = btnMsg
        
        if let city = Defaults[D_USER_ADDR].string {
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
        parent.layer.cornerRadius = 25
        parent.tintColor = UIColor.clearColor()
        parent.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0)
        
        var lb = UILabel(frame: CGRectMake(0, btnMsg.bounds.size.height-20, btnMsg.bounds.size.width, 14))
        lb.text = aText
        lb.font = UIFont(name: lb.font.fontName, size: 12)
        lb.textColor = UIColor(hexString: "#FFFFFF") //#BCABA8
        lb.highlightedTextColor = UIColor.whiteColor()
        lb.textAlignment = .Center
        parent.addSubview(lb)
    }
    
    func initSegmentedControl() {
        segmentedControl = HMSegmentedControl(sectionTitles: ["@你", "系统"])
        segmentedControl.frame = CGRectMake(0, self.view.bounds.size.height-35, self.view.bounds.size.width, 35)
        
        
        segmentedControl.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleWidth
        segmentedControl.backgroundColor = UIColor.whiteColor()
        segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10)
        segmentedControl.textColor = UIColor(red: 0.694, green: 0.694, blue: 0.694, alpha: 1.00)
        segmentedControl.selectedTextColor = UIColor(red: 0.255, green: 0.788, blue: 0.298, alpha: 1.00)
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.selectionIndicatorColor = UIColor(red: 0.255, green: 0.788, blue: 0.298, alpha: 1.00)
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.addTarget(self, action: "segmentSelected:", forControlEvents: UIControlEvents.ValueChanged)  //这里不能用ValueChange,会报错!
        self.view.addSubview(segmentedControl)
    }
    
    @IBAction func segmentSelected(sender: HMSegmentedControl) {
        smallType = sender.selectedSegmentIndex
        Delegate?.onRefreshDataSource(self.bigType, iMsgType: self.smallType)
    }

    //这个是大类型
    @IBAction func messageSelected(sender: UIButton) {
        sender.selected = true
        if lastSelected != nil && lastSelected != sender{
            lastSelected.selected = false
        }
        lastSelected = sender
        if sender.tag != 1 {
            MobClick.event("mineCenter", attributes: ["Type":sender.tag == 2 ? "Dynamic" : "Work"])
            segmentedControl.hidden = true
            self.smallType = 2
            //self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300)
        } else {
            MobClick.event("mineCenter", attributes: ["Type":"Message"])
            segmentedControl.hidden = false
            self.smallType = 0
            //self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 325)
        }
        bigType = sender.tag
        Delegate?.onRefreshDataSource(self.bigType, iMsgType: self.smallType)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //外面调用的函数
    func RefreshHead(J: JSON, parent: UIViewController) {
        //圆形头像
        self.parentVC = parent
        roundProgressView.percent = CGFloat(J["process"].floatValue * 100)
        self.roundProgressView.imageUrl = J["headImg"].stringValue
        self.roundProgressView.level = J["level"].intValue
        self.userId = J["id"].intValue
        headImg = J["headImg"].stringValue
        nickname.text = J["nike"].stringValue
        if !headImg.isEmpty {
            imageBg.sd_setImageWithURL(NSURL(string: headImg), placeholderImage: UIImage(named: "Avatar"), completed: {image, error, cacheType, imageURL in
//                self.roundProgressView.imageView = UIImageView(image: image)
                self.imageBg.addBlurEffect(8, times: 1)
            })
        //
        btnMsg.setTitle(J["messageNum"].stringValue, forState: .Normal)
            println(btnMsg.titleLabel?.text)
        btnDynamic.setTitle(J["dynamicNum"].stringValue, forState: .Normal)
        btnWork.setTitle(J["workNum"].stringValue, forState: .Normal)
        }
    }
    
    func didFinishGetUMSocialDataInViewController(response: UMSocialResponseEntity!) {
        if(response.responseCode.value == UMSResponseCodeSuccess.value) {
            MobClick.event("Share", attributes: ["Address":"个人中心", "Type": "Success"])
            MCUtils.showCustomHUD("分享成功", aType: .Success)
        }
    }
    
    @IBAction func onShare(sender: AnyObject) {
        MobClick.event("mineCenter", attributes: ["Type":"Share"])
        var url = "http://www.mckuai.com/u/\(userId)"
        println(url)
        MobClick.event("Share", attributes: ["Address":"个人中心", "Type": "start"])
        ShareUtil.shareInitWithTextAndPicture(parentVC, text: "我的麦块", image: DefaultShareImg!, shareUrl: url, callDelegate: self)
    }

    @IBAction func setUserInfoAction(sender: UIButton) {
        MobClick.event("mineCenter", attributes: ["Type":"Setting"])
        UserInfo.showUserInfoView(MCUtils.mainNav,aDelegate: (MCUtils.leftView as! leftMenuViewController))
    }

}
