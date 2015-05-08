//
//  NewLogin.swift
//  mckuai
//
//  Created by 陈强 on 15/5/7.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit

class NewLogin: UIViewController {
    
    var superUIViewController:UIViewController!
    var isShow:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        //        //设置navigation
        initNavigation()
        
        // Do any additional setup after loading the view.
    }
    
    
    func initNavigation() {
        
        var closeLogin = UIButton(frame: CGRectMake(10, 30, 21, 21))
        closeLogin.setImage(UIImage(named: "nav_back"), forState: UIControlState.Normal)
        closeLogin.addTarget(self, action: "backToPage", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(closeLogin)
//        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor().colorWithAlphaComponent(0))
        
//        self.navigationController?.navigationBar.hidden = true
        
//        var back = UIBarButtonItem(image: UIImage(named: "nav_back"), style: UIBarButtonItemStyle.Bordered, target: self, action: "backToPage")
//        back.tintColor = UIColor.whiteColor()
//        self.navigationItem.leftBarButtonItem = back
    }
    
    func backToPage() {
            UIView.animateWithDuration(0.3,
                animations : {
                    self.view.frame.origin = CGPoint(x: 0,y: UIScreen.mainScreen().bounds.size.height)
                },
                completion : {_ in
                    
                    if(self.isShow){
                        self.superUIViewController.tabBarController?.tabBar.hidden = false
                        self.view.removeFromSuperview()
                    }
                    
//                    self.view.removeFromSuperview()
                }
            )
    }
    
    
    override func viewWillAppear(animated: Bool) {
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func showUserLoginView(fromViewController:UIViewController,returnIsShow:Bool){
//        var userLoginView = UIStoryboard(name: "NewLogin", bundle: nil).instantiateViewControllerWithIdentifier("newLogin") as! NewLogin
//        if (ctl != nil) {
//            ctl?.pushViewController(userLoginView, animated: true)
//        } else {
//            ctl?.presentViewController(userLoginView, animated: true, completion: nil)
//        }
        
        
        userLoginView = UIStoryboard(name: "NewLogin", bundle: nil).instantiateViewControllerWithIdentifier("newLogin") as! NewLogin
        userLoginView.view.frame = CGRectMake(0,UIScreen.mainScreen().bounds.size.height,UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        userLoginView.superUIViewController = fromViewController
        userLoginView.isShow = returnIsShow
        fromViewController.tabBarController?.tabBar.hidden = true
        fromViewController.navigationController?.view.addSubview(userLoginView.view)
        UIView.animateWithDuration(0.3,
            animations : {
                userLoginView.view.frame.origin = CGPoint(x: 0,y: 0)
            },
            completion : {_ in

            }
        )
        
        
        
    }
    
    
    


    
}