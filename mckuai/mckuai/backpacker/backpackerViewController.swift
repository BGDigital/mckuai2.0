//
//  backpackerViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/28.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class backpackerViewController: UIViewController {

    var segmentedControl: HMSegmentedControl!
    var favorite: favoriteViewController!
    var friends: friendsViewController!
    var UserId: Int!
    
    init(uId: Int) {
        super.init(nibName: nil, bundle: nil)
        self.UserId = uId
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true  //这句在pop回来的时候没有效果
        self.view.backgroundColor = UIColor.whiteColor()
        initSegmentedControl()
        initSubView()
        //设置标题颜色
        self.navigationItem.title = "背包"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func viewDidDisappear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    func initSubView() {
        var rect = CGRectMake(0, 99, self.view.bounds.size.width, self.view.bounds.size.height-99)
        //麦友
        if friends == nil {
            friends = UIStoryboard(name: "friends", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("friendsViewController") as! friendsViewController
        }
        friends.setNavi(self.navigationController)
        friends.view.frame = rect
        friends.view.hidden = true
        self.view.addSubview(friends.view)
        
        //收藏贴子
        if favorite == nil {
            favorite = favoriteViewController()
        }
        favorite.view.frame = rect
        self.view.addSubview(favorite.view)
    }
    
    func initSegmentedControl() {
        segmentedControl = HMSegmentedControl(sectionTitles: ["贴子", "麦友"])
        segmentedControl.frame = CGRectMake(0, 64, self.view.frame.size.width, 35)
        
        
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
        println("segment selected:\(sender.selectedSegmentIndex)")
        switch (sender.selectedSegmentIndex) {
        case 0:
            friends.view.hidden = true
            favorite.view.hidden = false
            self.view.bringSubviewToFront(favorite.view)
            break
        case 1:
            friends.view.hidden = false
            favorite.view.hidden = true
            self.view.bringSubviewToFront(friends.view)
            break
        default:
            break
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(animated: Bool) {
            MobClick.beginLogPageView("backpackerView")
            self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor(hexString: MCUtils.COLOR_NavBG))
            self.tabBarController?.tabBar.hidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        MobClick.endLogPageView("backpackerView")
    }

}
