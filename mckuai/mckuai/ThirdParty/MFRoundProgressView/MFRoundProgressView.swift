//
//  MFRoundProgressView.swift
//  components
//
//  Created by Marius Fanu on 26/01/15.
//  Copyright (c) 2015 Alecs Popa. All rights reserved.
//

import UIKit

@IBDesignable

class MFRoundProgressView: UIView {
    
    @IBInspectable var percent:CGFloat = 50.0 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var imageUrl: String! {
        didSet {
            showPercent = imageUrl.isEmpty
            imageView.frame = CGRectMake(9, 9, self.frame.width-18, self.frame.height-18)
            imageView.sd_setImageWithURL(NSURL(string: imageUrl), placeholderImage: DefaultUserAvatar_big)
            //imageView.frame = CGRect(x: 10, y: 10, width: self.frame.width-20, height: self.frame.height-20)
            imageView.layer.masksToBounds = true
            imageView.layer.cornerRadius = (self.frame.width - 18) / 2
            self.addSubview(imageView)
            setNeedsDisplay()
        }
    }
    //进度条颜色
    @IBInspectable var progressColor:UIColor = UIColor(hexString: "#40C74D")! {
        didSet {
            setNeedsDisplay()
        }
    }
    //进度条背景颜色
    @IBInspectable var progressBackgroundColor:UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4) {
        didSet {
            setNeedsDisplay()
        }
    }
    //进度条的进度宽度
    @IBInspectable var progressLineWidth:CGFloat = 2.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    //用户等级
    @IBInspectable var level:Int = 0 {
        didSet {
            lb_level.frame = CGRectMake(8, 5, 24, 24)
            //圆角背景
            lb_level.setBackgroundImage(UIImage(named: "level_bg"), forState: .Normal)
            lb_level.setTitle("lv." + String(level), forState: .Normal)
            lb_level.titleLabel?.font = UIFont(name: lb_level.titleLabel!.font.fontName, size: 10)
            lb_level.setTitleColor(UIColor.whiteColor(), forState: .Normal)


            self.addSubview(lb_level)
            setNeedsDisplay()
        }
    }
    
    //用户头像图片
    private var imageView: UIImageView = UIImageView(image: UIImage(named: "Avatar"))
    //是否显示进度数字
    private var showPercent: Bool = true
    //是否显示阴影
    private var showShadow: Bool = false
    //进度开始,结束点
    private var startAngle: CGFloat = CGFloat(-120 * M_PI / 180)
    private var endAngle: CGFloat = CGFloat(240 * M_PI / 180)
    private var lb_level: UIButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.clearColor()
    }

    
    override func drawRect(rect: CGRect) {
        // General Declarations
        var context = UIGraphicsGetCurrentContext()
        
        // Color Declarations
//        let progressColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
//        let backGroundColor = UIColor(red: 0.502, green: 0.502, blue: 0.502, alpha: 0.2)
//        let progressBackgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.4)
        let titleColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.8)
        
        // Shadow Declarations
        let innerShadow = UIColor.blackColor().colorWithAlphaComponent(0.22)
        let innerShadowOffset = CGSize(width: 3.1, height: 3.1)
        let innerShadowBlurRadius = CGFloat(4)
        
        // Background Drawing
        let backgroundPath = UIBezierPath(ovalInRect: CGRect(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect), width: rect.width, height: rect.height))
        backgroundColor?.setFill()
        backgroundPath.fill()
        
        // Background Inner Shadow  这个地方是阴影
        if showShadow {
            CGContextSaveGState(context);
            UIRectClip(backgroundPath.bounds);
            CGContextSetShadowWithColor(context, CGSizeZero, 0, nil);
            
            CGContextSetAlpha(context, CGColorGetAlpha(innerShadow.CGColor))
            CGContextBeginTransparencyLayer(context, nil)
            
            let opaqueShadow = innerShadow.colorWithAlphaComponent(1)
            CGContextSetShadowWithColor(context, innerShadowOffset, innerShadowBlurRadius, opaqueShadow.CGColor)
            CGContextSetBlendMode(context, kCGBlendModeSourceOut)
            CGContextBeginTransparencyLayer(context, nil)
            
            opaqueShadow.setFill()
            backgroundPath.fill()
            CGContextEndTransparencyLayer(context);
            
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
        }

        
        // ProgressBackground Drawing
        let kMFPadding = CGFloat(15)
        
        let progressBackgroundPath = UIBezierPath(ovalInRect: CGRect(x: CGRectGetMinX(rect) + kMFPadding/2, y: CGRectGetMinY(rect) + kMFPadding/2, width: rect.size.width - kMFPadding, height: rect.size.height - kMFPadding))
        progressBackgroundColor.setStroke()
        progressBackgroundPath.lineWidth = progressLineWidth
        progressBackgroundPath.stroke()
        
        // Progress Drawing
        let progressRect = CGRect(x: CGRectGetMinX(rect) + kMFPadding/2, y: CGRectGetMinY(rect) + kMFPadding/2, width: rect.size.width - kMFPadding, height: rect.size.height - kMFPadding)
        let progressPath = UIBezierPath()
        progressPath.addArcWithCenter(CGPoint(x: CGRectGetMidX(progressRect), y: CGRectGetMidY(progressRect)), radius: CGRectGetWidth(progressRect) / 2, startAngle: startAngle, endAngle: (endAngle - startAngle) * (percent / 100) + startAngle, clockwise: true)
        progressColor.setStroke()
        progressPath.lineWidth = progressLineWidth
        progressPath.lineCapStyle = kCGLineCapRound
        progressPath.stroke()
        
        
        if (showPercent) {
            // Text Drawing
            let textRect = CGRect(x: CGRectGetMinX(rect), y: CGRectGetMinY(rect), width: rect.size.width, height: rect.size.height)
            let textContent = NSString(string: "\(Int(percent))")
            var textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
            textStyle.alignment = .Center
            
            let textFontAttributes = [
                NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: rect.width / 3)!,
                NSForegroundColorAttributeName: titleColor,
                NSParagraphStyleAttributeName: textStyle]
            
            let textHeight = textContent.boundingRectWithSize(CGSize(width: textRect.width, height: textRect.height), options: .UsesLineFragmentOrigin, attributes: textFontAttributes, context: nil).height
            
            CGContextSaveGState(context)
            CGContextClipToRect(context, textRect)
            textContent.drawInRect(CGRect(x: CGRectGetMinX(textRect), y: CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textHeight) / 2, width: CGRectGetWidth(textRect), height: textHeight), withAttributes: textFontAttributes)
            CGContextRestoreGState(context);
        }
        
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
