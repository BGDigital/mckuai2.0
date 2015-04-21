//
//  communityViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/21.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class communityViewController: UIViewController {

    class func mainRoot()->UIViewController{
        var main = UIStoryboard(name: "community", bundle: nil).instantiateViewControllerWithIdentifier("communityViewController") as! UIViewController
        main.tabBarItem = UITabBarItem(title: "聊天", image: UIImage(named: "second_normal"), selectedImage: UIImage(named: "second_selected"))
        return UINavigationController(rootViewController: main)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
