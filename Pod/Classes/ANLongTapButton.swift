//
//  ANLongTapButton.swift
//
//  Created by Sergey Demchenko on 11/5/15.
//  Copyright © 2015 antrix1989. All rights reserved.
//

import UIKit

@IBDesignable
public class ANLongTapButton: UIButton
{
    @IBInspectable public var barWidth: CGFloat = 10
    @IBInspectable public var barColor: UIColor = UIColor.yellowColor()
    @IBInspectable public var barTrackColor: UIColor = UIColor.grayColor()
    @IBInspectable public var bgCircleColor: UIColor = UIColor.blueColor()
    @IBInspectable public var startAngle: CGFloat = -90
    @IBInspectable public var timePeriod: NSTimeInterval = 3
    
    public var didTimePeriodElapseBlock : (() -> Void) = { () -> Void in }
    
    var timePeriodTimer: NSTimer?
    var circleLayer: CAShapeLayer?
    
    public override func prepareForInterfaceBuilder()
    {
        let center = self.center()
        let radius = self.radius()
        
        if let context = UIGraphicsGetCurrentContext() {
            drawBackground(context, center: center, radius: radius)
            drawBackgroundCircle(context, center: center, radius: radius)
            drawTrackBar(context, center: center, radius: radius)
            drawProgressBar(context, center: center, radius: radius)
        }
    }
    
    public override func awakeFromNib()
    {
        super.awakeFromNib()
        
        addTarget(self, action: Selector("start:forEvent:"), forControlEvents: .TouchDown)
        addTarget(self, action: Selector("cancel:forEvent:"), forControlEvents: .TouchUpInside)
        addTarget(self, action: Selector("cancel:forEvent:"), forControlEvents: .TouchCancel)
        addTarget(self, action: Selector("cancel:forEvent:"), forControlEvents: .TouchDragExit)
        addTarget(self, action: Selector("cancel:forEvent:"), forControlEvents: .TouchDragOutside)
    }
    
    public override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)
        
        let center = self.center()
        let radius = self.radius()
        
        if let context = UIGraphicsGetCurrentContext() {
            CGContextClearRect(context, rect)
            drawBackground(context, center: center, radius: radius)
            drawBackgroundCircle(context, center: center, radius: radius)
            drawTrackBar(context, center: center, radius: radius)
        }
    }
    
    // MARK: - Internal
    
    func start(sender: AnyObject, forEvent event: UIEvent)
    {
        reset()
        
        timePeriodTimer = NSTimer.schedule(delay: timePeriod) { [weak self] (timer) -> Void in
            self?.timePeriodTimer?.invalidate()
            self?.timePeriodTimer = nil
            
            self?.didTimePeriodElapseBlock()
        }
        
        let center = self.center()
        var radius = self.radius()
        radius = radius - (barWidth / 2)
        
        circleLayer = CAShapeLayer()
        circleLayer!.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: degreesToRadians(startAngle), endAngle: degreesToRadians(startAngle + 360), clockwise: true).CGPath
        circleLayer!.fillColor = UIColor.clearColor().CGColor
        circleLayer!.strokeColor = barColor.CGColor
        circleLayer!.lineWidth = barWidth
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = timePeriod
        animation.removedOnCompletion = true
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        circleLayer!.addAnimation(animation, forKey: "drawCircleAnimation")
        self.layer.addSublayer(circleLayer!)
    }
    
    func cancel(sender: AnyObject, forEvent event: UIEvent)
    {
        reset()
    }
    
    func reset()
    {
        timePeriodTimer?.invalidate()
        timePeriodTimer = nil
        circleLayer?.removeAllAnimations()
        circleLayer?.removeFromSuperlayer()
        circleLayer = nil
    }
    
    func drawBackground(context: CGContextRef, center: CGPoint, radius: CGFloat)
    {
        if let backgroundColor = self.backgroundColor {
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextFillRect(context, bounds)
        }
    }
    
    func drawBackgroundCircle(context: CGContextRef, center: CGPoint, radius: CGFloat)
    {
        CGContextSetFillColorWithColor(context, bgCircleColor.CGColor)
        CGContextBeginPath(context)
        CGContextAddArc(context, center.x, center.y, radius, 0, 360, 0)
        CGContextClosePath(context)
        CGContextFillPath(context)
    }
    
    func drawTrackBar(context: CGContextRef, center: CGPoint, radius: CGFloat)
    {
        if (barWidth > radius) {
            barWidth = radius;
        }
        
        CGContextSetFillColorWithColor(context, barTrackColor.CGColor)
        CGContextBeginPath(context)
        CGContextAddArc(context, center.x, center.y, radius, degreesToRadians(startAngle), degreesToRadians(startAngle + 360), 0);
        CGContextAddArc(context, center.x, center.y, radius - barWidth, degreesToRadians(startAngle + 360), degreesToRadians(startAngle), 1);
        CGContextClosePath(context)
        CGContextFillPath(context)
    }
    
    func drawProgressBar(context: CGContextRef, center: CGPoint, radius: CGFloat)
    {
        if (barWidth > radius) {
            barWidth = radius;
        }
        
        CGContextSetFillColorWithColor(context, barColor.CGColor)
        CGContextBeginPath(context)
        CGContextAddArc(context, center.x, center.y, radius, degreesToRadians(startAngle), degreesToRadians(startAngle + 90), 0);
        CGContextAddArc(context, center.x, center.y, radius - barWidth, degreesToRadians(startAngle + 90), degreesToRadians(startAngle), 1);
        CGContextClosePath(context)
        CGContextFillPath(context)
    }
    
    // MARK: - Private
    
    private func center() -> CGPoint
    {
        return CGPointMake(bounds.size.width / 2, bounds.size.height / 2)
    }
    
    private func radius() -> CGFloat
    {
        let center = self.center()
        
        return min(center.x, center.y)
    }
    
    private func degreesToRadians (value: CGFloat) -> CGFloat { return value * CGFloat(M_PI) / CGFloat(180.0) }
}
