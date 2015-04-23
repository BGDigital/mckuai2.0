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
    
    var segmentedControl: HMSegmentedControl!
    var headImg: String!
    var userId = 0
    var userLevel = 0
    var username = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 325)
        segmentedControl = HMSegmentedControl(sectionTitles: ["全部", "@你", "系统"])
        segmentedControl.frame = CGRectMake(0, self.view.bounds.size.height-25, self.view.bounds.size.width, 25)
        segmentedControl.addTarget(self, action: "segmentSelected", forControlEvents: UIControlEvents())  //这里不能用ValueChange,会报错!
        self.view.addSubview(segmentedControl)
        //模糊背景
        imageBg.addBlurEffect(30, times: 1)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func segmentSelected(sender: HMSegmentedControl) {
        println("segment selected:\(sender.selectedSegmentIndex)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshHead(j: JSON) {
        //圆形头像
        roundProgressView.percent = 78
        headImg = j["headImg"].stringValue
        nickname.text = j["nike"].stringValue
        if !headImg.isEmpty {
            imageBg.sd_setImageWithURL(NSURL(string: headImg), placeholderImage: UIImage(named: "1024"), completed: {image, error, cacheType, imageURL in
                self.roundProgressView.imageView = UIImageView(image: image)
                self.imageBg.addBlurEffect(30, times: 1)
            })
            
            
        }
    }


}
