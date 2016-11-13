//
//  FFWaveView.swift
//  WaveAnimationDemo
//
//  Created by Jacqui on 2016/11/11.
//  Copyright © 2016年 Jugg. All rights reserved.
//

import UIKit

class FFWaveView: UIView {

    var angularSpeed : Float = 1.8              ///< 决定周期
    var waveSpeed : Float = 2                   ///< wave's speed
    var waveColor : UIColor! = UIColor.white    ///< wave's color
    
    fileprivate var offsetX : CGFloat = 0.0     ///< offset x
    fileprivate var waveDisplayLink : CADisplayLink!
    fileprivate var waveShapeLayer : CAShapeLayer!
    
    class func addTo(view: UIView, frame: CGRect) -> FFWaveView {
        let waveView = FFWaveView(frame: frame)
        view.addSubview(waveView)
        return waveView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// setup default value
    func setup() {
        angularSpeed = 1.8
        waveSpeed = 2
        waveColor = UIColor.white
    }
    
    
    /// 开始执行
    func startWave() -> Bool {
        if waveShapeLayer != nil {
            return false
        }
        
        waveShapeLayer = CAShapeLayer()
        waveShapeLayer.fillColor = waveColor.cgColor
        layer.addSublayer(waveShapeLayer)
        
        waveDisplayLink = CADisplayLink(target: self, selector: #selector(keyFrameWave))
        waveDisplayLink.add(to: .main, forMode: .commonModes)
        
        return true
    }
    
    /// 实时刷新
    func keyFrameWave() {
        //根据速度计算波浪偏移
        offsetX -= CGFloat(CGFloat(waveSpeed) )
        
        let width : CGFloat = self.frame.size.width
        let height : CGFloat = self.frame.size.height
        
        // 创建path
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: height/2))
        
        
        /// 使用正弦函数 f(x) = Asin(ωx+φ)+k, wave向右移动，因此φ为负值
        var y : CGFloat = 0
        for x in stride(from: 0, through: width, by: 1) {
            
            /// 0.01 * angularSpeed决定了周期， angularSpeed值越大，周期越小
            y = height * sin(0.01 * (CGFloat(angularSpeed) * CGFloat(x) + offsetX))
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        waveShapeLayer.path = path
    }
    
    func stopWave() {
        UIView.animate(withDuration: 1,
                       animations: {
                        self.alpha = 0
        }) { (finished) in
            self.waveDisplayLink.invalidate()
            self.waveDisplayLink = nil
            self.waveShapeLayer.removeFromSuperlayer()
            self.waveShapeLayer = nil
            
            self.alpha = 1
        }
    }
    
}
