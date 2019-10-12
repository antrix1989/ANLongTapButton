//
//  ANLongTapButton.swift
//
//  Created by Sergey Demchenko on 11/5/15.
//  Copyright © 2015 antrix1989. All rights reserved.
//

import UIKit

@IBDesignable
open class ANLongTapButton: UIButton, CAAnimationDelegate
{
    @IBInspectable open var barWidth: CGFloat = 10
    @IBInspectable open var barColor: UIColor = UIColor.yellow
    @IBInspectable open var barTrackColor: UIColor = UIColor.gray
    @IBInspectable open var bgCircleColor: UIColor = UIColor.blue
    @IBInspectable open var startAngle: CGFloat = -90
    @IBInspectable open var timePeriod: TimeInterval = 3
    @IBInspectable open var reverseAnimationTimePeriod: TimeInterval = 0.5
    @IBInspectable open var animatedRollback: Bool = false
    
    /// Invokes when timePeriod has elapsed.
    open var didTimePeriodElapseBlock : (() -> Void) = { () -> Void in }
    
    /// Invokes when either time period has elapsed or when user cancels touch.
    open var didFinishBlock : (() -> Void) = { () -> Void in }
    
    /// Invokes when user started touch.
    open var didStartBlock : (() -> Void) = { () -> Void in }
    
    var timePeriodTimer: Timer?
    var circleLayer: CAShapeLayer?
    var isFinished = true
    
    // MARK: - Animation keys
    private var drawCircleAnimationKey: String { "drawCircleAnimation" }
    private var undrawCircleAnimationKey: String { "undrawCircleAnimation" }
    
    open override func prepareForInterfaceBuilder()
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
    
    open override func awakeFromNib()
    {
        super.awakeFromNib()
        
        addTarget(self, action: #selector(start(_:forEvent:)), for: .touchDown)
        addTarget(self, action: #selector(cancel(_:forEvent:)), for: .touchUpInside)
        addTarget(self, action: #selector(cancel(_:forEvent:)), for: .touchCancel)
        addTarget(self, action: #selector(cancel(_:forEvent:)), for: .touchDragExit)
        addTarget(self, action: #selector(cancel(_:forEvent:)), for: .touchDragOutside)
    }
    
    open override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        
        let center = self.center()
        let radius = self.radius()
        
        if let context = UIGraphicsGetCurrentContext() {
            context.clear(rect)
            drawBackground(context, center: center, radius: radius)
            drawBackgroundCircle(context, center: center, radius: radius)
            drawTrackBar(context, center: center, radius: radius)
        }
    }
    
    // MARK: - Internal
    
    @objc func start(_ sender: AnyObject, forEvent event: UIEvent)
    {
        isFinished = false
        reset()
        didStartBlock()
        
        timePeriodTimer = Timer.schedule(delay: timePeriod) { [weak self] (timer) -> Void in
            self?.timePeriodTimer?.invalidate()
            self?.timePeriodTimer = nil
            self?.isFinished = true
            self?.didFinishBlock()
            self?.didTimePeriodElapseBlock()
        }
        
        let center = self.center()
        var radius = self.radius()
        radius = radius - (barWidth / 2)
        
        circleLayer = CAShapeLayer()
        circleLayer!.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: degreesToRadians(startAngle), endAngle: degreesToRadians(startAngle + 360), clockwise: true).cgPath
        circleLayer!.fillColor = UIColor.clear.cgColor
        circleLayer!.strokeColor = barColor.cgColor
        circleLayer!.lineWidth = barWidth
        
        let animation = strokeEndAnimation()
        circleLayer!.add(animation, forKey: drawCircleAnimationKey)
        self.layer.addSublayer(circleLayer!)
    }
    
    @objc func cancel(_ sender: AnyObject, forEvent event: UIEvent)
    {
        let isNotFinished = !isFinished
        if isNotFinished {
            isFinished = true
            didFinishBlock()
        }
        
        if let circleLayer = self.circleLayer, let currentStrokeValue = circleLayer.presentation()?.strokeEnd, animatedRollback, isNotFinished {
            resetTimer()
            
            let reverseAnimation = strokeReverseAnimation(fromValue: currentStrokeValue)
            reverseAnimation.delegate = self
            circleLayer.pauseAnimation()
            circleLayer.add(reverseAnimation, forKey: undrawCircleAnimationKey)
            circleLayer.removeAnimation(forKey: drawCircleAnimationKey)
            circleLayer.resumeAnimation()
        } else {
            reset()
        }
    }
    
    func reset()
    {
        resetTimer()
        resetCircleLayer()
    }
    
    private func resetTimer()
    {
        timePeriodTimer?.invalidate()
        timePeriodTimer = nil
    }
    
    private func resetCircleLayer()
    {
        circleLayer?.removeAllAnimations()
        circleLayer?.removeFromSuperlayer()
        circleLayer = nil
    }
    
    // MARK: - CAAnimationDelegate
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool)
    {
        resetCircleLayer()
    }
    
    private func drawBackground(_ context: CGContext, center: CGPoint, radius: CGFloat)
    {
        if let backgroundColor = self.backgroundColor {
            context.setFillColor(backgroundColor.cgColor);
            context.fill(bounds)
        }
    }
    
    private func drawBackgroundCircle(_ context: CGContext, center: CGPoint, radius: CGFloat)
    {
        context.setFillColor(bgCircleColor.cgColor)
        context.beginPath()
        context.addArc(center: center, radius: radius, startAngle: 0, endAngle: 360, clockwise: false)
        context.closePath()
        context.fillPath()
    }
    
    private func drawTrackBar(_ context: CGContext, center: CGPoint, radius: CGFloat)
    {
        if (barWidth > radius) {
            barWidth = radius;
        }
        
        context.setFillColor(barTrackColor.cgColor)
        context.beginPath()
        context.addArc(center: center, radius: radius, startAngle: degreesToRadians(startAngle), endAngle: degreesToRadians(startAngle + 360), clockwise: false)
        context.addArc(center: center, radius: radius - barWidth, startAngle: degreesToRadians(startAngle + 360), endAngle: degreesToRadians(startAngle), clockwise: true)
        context.closePath()
        context.fillPath()
    }
    
    private func drawProgressBar(_ context: CGContext, center: CGPoint, radius: CGFloat)
    {
        if (barWidth > radius) {
            barWidth = radius;
        }
        
        context.setFillColor(barColor.cgColor)
        context.beginPath()
        context.addArc(center: center, radius: radius, startAngle: degreesToRadians(startAngle), endAngle: degreesToRadians(startAngle + 90), clockwise: false)
        context.addArc(center: center, radius: radius - barWidth, startAngle: degreesToRadians(startAngle + 90), endAngle: degreesToRadians(startAngle), clockwise: true)
        context.closePath()
        context.fillPath()
    }
    
    // MARK: - Private
    
    private func strokeEndAnimation() -> CABasicAnimation
    {
        return strokeAnimation(fromValue: 0, toValue: 1, duration: timePeriod)
    }
    
    private func strokeReverseAnimation(fromValue: Any) -> CABasicAnimation
    {
        return strokeAnimation(fromValue: fromValue, toValue: 0, duration: reverseAnimationTimePeriod)
    }
    
    private func strokeAnimation(fromValue: Any, toValue: Any, duration: TimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.isRemovedOnCompletion = true
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        return animation
    }
    
    fileprivate func center() -> CGPoint
    {
        return CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    fileprivate func radius() -> CGFloat
    {
        let center = self.center()
        
        return min(center.x, center.y)
    }
    
    fileprivate func degreesToRadians (_ value: CGFloat) -> CGFloat { return value * CGFloat.pi / CGFloat(180.0) }
}

fileprivate extension CALayer
{
    
    func pauseAnimation()
    {
        let pausedTime = convertTime(CACurrentMediaTime(), from: nil)
        speed = 0
        timeOffset = pausedTime
    }

    func resumeAnimation()
    {
        let pausedTime = timeOffset
        speed = 1
        timeOffset = 0
        beginTime = 0
        let timeSincePause = convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        beginTime = timeSincePause
    }
    
}
