//
//  GuidePageController.swift
//  mckuai
//
//  Created by XingfuQiu on 15/5/6.
//  Copyright (c) 2015年 XingfuQiu. All rights reserved.
//

import UIKit

class GuidePageController: UIViewController , UIScrollViewDelegate {
    
    internal init(datas:Array<NSString>,button:UIButton?) {
        super.init(nibName: nil, bundle: nil)
        
        self.mDatas = datas
        self.btnSubmit = button
    }
    
    required internal init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Must call a designated initializer of the superclass 'UIVierController'
    var scrollView:UIScrollView!
    var pageControl:UIPageControl!
    var btnSubmit:UIButton?
    var mDatas:Array<NSString>!
    var firstPop:Bool=true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        //Creating some shorthand for these values
        var wBounds = self.view.bounds.width
        var hBounds = self.view.bounds.height
        
        // This houses all of the UIViews / content
        scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.frame = self.view.frame
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        scrollView.bounces = false
        self.view.addSubview(scrollView)
        
        self.scrollView.contentSize = CGSize(width: wBounds * CGFloat(mDatas.count), height: hBounds/2)
        
        //点指示器
        pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 0, y: hBounds-35, width: wBounds, height: 0)
        pageControl.backgroundColor = UIColor(white: 0, alpha: 0)
        pageControl.numberOfPages = mDatas.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.whiteColor()
        pageControl.pageIndicatorTintColor = UIColor(hexString: "#000000", alpha: 0.1)
        self.view.addSubview(pageControl)
        
        //根据数据数量来动态创建视图
        let size = mDatas.count
        for count in 0 ..<  size{
            var view = UIView()
            view.backgroundColor = UIColor.whiteColor()
            //设置左边距离，根据数据对应数组的位置
            let lBounds = wBounds * CGFloat(count)
            view.frame = CGRectMake(lBounds, 0, wBounds, hBounds)
            
            let path = mDatas[count] as String
            var image = UIImage(named: path)!
            let insets=UIEdgeInsetsMake(0, 0, 0, 0)
            //这里设置图片拉伸
            image.resizableImageWithCapInsets(insets, resizingMode: UIImageResizingMode.Stretch)
            var imageView = UIImageView(image: image)
            imageView.frame = CGRectMake(0, 0, wBounds, hBounds)
            view.addSubview(imageView)
            
            if((self.btnSubmit) != nil && count == size-1){
                view.addSubview(self.btnSubmit!)
            }
            
            //把视图加入到scrollView中
            self.scrollView.addSubview(view)
            self.scrollView.bringSubviewToFront(view)
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        var xOffset: CGFloat = scrollView.contentOffset.x
        var x: Float = Float(xOffset)
        var width:Float = Float(self.view.bounds.width)
        
        pageControl.currentPage = Int(x / width) 
    }

}

