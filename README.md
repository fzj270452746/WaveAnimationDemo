# WaveAnimationDemo

类似水波纹效果，可用于下拉刷新。
实现原理：
由水波纹的特点类似于波浪形状，因此可根据正弦函数f(x) = Asin(ωx+φ)来实现波浪的形状。
A震动时所能达到的最高和最低点；
正弦完整的周期T = 2π/ω，因此周期越长，ω值越小
φ为相位，当φ为0时，x=0，则y=0.φ>0，则正弦函数向左偏移，φ<0，正弦函数向右偏移。

由上函数，要使我们的波浪向右移动，因此φ必须小于0

下面是绘制正弦函数的实现
/// 使用正弦函数 f(x) = Asin(ωx+φ)+k, wave向右移动，因此φ为负值
var y : CGFloat = 0
for x in stride(from: 0, through: width, by: 1) {
    /// 0.01 * angularSpeed决定了周期， angularSpeed值越大，周期越小
    y = height * sin(0.01 * (CGFloat(angularSpeed) * CGFloat(x) + offsetX))
    path.addLine(to: CGPoint(x: x, y: y))
}

正弦函数完成，就对其进行绘制使其形成一个封闭的图形，代码如下
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
        
以上一帧动画的图形，要实现动态波浪线的移动，因此需让其动起来。
/// 开始执行
    func startWave() -> Bool {
        if waveShapeLayer != nil {
            return false
        }
        
        waveShapeLayer = CAShapeLayer()
        waveShapeLayer.fillColor = waveColor.cgColor
        layer.addSublayer(waveShapeLayer)
        
        //使用CADisplayLink来不停刷新视图，使波浪线移动起来
        waveDisplayLink = CADisplayLink(target: self, selector: #selector(keyFrameWave))
        waveDisplayLink.add(to: .main, forMode: .commonModes)
        
        return true
    }

以上为主要核心代码。

如何使用？
1. 创建FFWaveView对象，将其添加到要使用的视图上，并设置Frame
 // FFWaveView setup
waveView = FFWaveView.addTo(view: tableview.tableHeaderView!, frame: CGRect(x: 0, y: headerView.frame.size.height - 10, width: view.frame.size.width, height: 10))
        
// optional
waveView.waveColor = UIColor.white
waveView.waveSpeed = 10
waveView.angularSpeed = 1.5

2. 调用
func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //拖拽时，开始执行
    if waveView.startWave() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            //延时结束动画
            self.waveView.stopWave()
        }
    }
}
    
1.可修改水波纹x移动的速度
2.可修改水波纹的颜色
3.可修改水波纹的周期
