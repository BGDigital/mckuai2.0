//
//  SecondViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/16.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class liveViewController: UIViewController {

    class func mainRoot()->UIViewController{
        var main = UIStoryboard(name: "live", bundle: nil).instantiateViewControllerWithIdentifier("liveViewController") as! UIViewController
        main.tabBarItem = UITabBarItem(title: "直播", image: UIImage(named: "third_normal"), selectedImage: UIImage(named: "third_selected"))
        return UINavigationController(rootViewController: main)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pushViewController(sender: AnyObject) {
        var viewcontroller = UIViewController()
        viewcontroller.title = "pushed Controller"
        viewcontroller.view.backgroundColor = UIColor.greenColor()
        self.navigationController?.pushViewController(viewcontroller, animated: true)
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
