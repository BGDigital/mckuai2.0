//
//  mainHeaderViewController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/4/22.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class mainHeaderViewController: UIViewController, CityProtocol {

    @IBOutlet weak var roundProgressView: MFRoundProgressView!
    @IBOutlet weak var username: UIButton!
    @IBOutlet weak var times: UIButton!
    @IBOutlet weak var chatTitle: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var bag: UIButton!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var level: UIButton!
    @IBOutlet weak var locationCity: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        roundProgressView.percent = 78
        roundProgressView.imageView = UIImageView(image: UIImage(named: "1024"))
        username.imageEdgeInsets = UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)
        //locationCity.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        imageV.sd_setImageWithURL(nil, placeholderImage: UIImage(named: "placeholder"))
        times.backgroundColor = UIColor(red: 0.843, green: 0.243, blue: 0.255, alpha: 1.00)
        
        //添加事件
        //locationCity.addTarget(self, action: "openCityList", forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openCityList(sender: UIButton) {
        println("打开城市列表")
        var cityList = cityListViewController()
        cityList.Delegate = self
        //self.navigationController?.pushViewController(cityList, animated: true)
        self.presentViewController(cityList, animated: true, completion: nil)
    }
    
    func onSelectCity(selectedCity: String) {
        locationCity.setTitle(selectedCity, forState: .Normal)
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
