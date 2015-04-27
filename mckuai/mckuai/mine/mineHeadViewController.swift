//
//  mineHeadViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/23.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mineHeadViewController: UIViewController {

    @IBOutlet weak var imageBg: SABlurImageView!
    @IBOutlet weak var roundProgressView: MFRoundProgressView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var locationCity: UIButton!
    @IBOutlet weak var btnMsg: UIButton!
    @IBOutlet weak var btnDynamic: UIButton!
    @IBOutlet weak var btnWork: UIButton!
    
    var lastSelected: UIButton!
    var segmentedControl: HMSegmentedControl!
    var headImg: String!
    var userId = 0
    var userLevel = 0
    var username = ""
    
    //大类型,小类型都默认取1
    var bigType = 1   //1:消息,2:动态,3:作品
    var smallType = 0  //0:All,1:@Me,2:系统
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 325)
        initSegmentedControl()
        //模糊背景
        imageBg.addBlurEffect(30, times: 1)
        //初始化Button
        btnMsg.setBackgroundImage(UIImage(named: "1024"), forState: .Selected)
        btnMsg.setBackgroundImage(UIImage(named: ""), forState: .Normal)
        
        btnDynamic.setBackgroundImage(UIImage(named: "1024"), forState: .Selected)
        btnDynamic.setBackgroundImage(UIImage(named: ""), forState: .Normal)
        
        btnWork.setBackgroundImage(UIImage(named: "1024"), forState: .Selected)
        btnWork.setBackgroundImage(UIImage(named: ""), forState: .Normal)
        
        if let city = Defaults["CurrentCity"].string {
            locationCity.setTitle(city, forState: .Normal)
        } else {
            locationCity.setTitle("未定位", forState: .Normal)
        }
    }
    
    func initSegmentedControl() {
        segmentedControl = HMSegmentedControl(sectionTitles: ["全部", "@你", "系统"])
        segmentedControl.frame = CGRectMake(0, self.view.bounds.size.height-25, self.view.bounds.size.width, 25)
        
        
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
//        println("segment selected:\(sender.selectedSegmentIndex)")
        smallType = sender.selectedSegmentIndex
    }

    //这个是大类型
    @IBAction func messageSelected(sender: UIButton) {
        sender.selected = true
        if lastSelected != nil {
            lastSelected.selected = false
        }
        lastSelected = sender
        if sender.tag != 1 {
            segmentedControl.hidden = true
            //self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300)
        } else {
            segmentedControl.hidden = false
            //self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 325)
        }
        bigType = sender.tag
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
