//
//  WSLoader.swift
//  WSLoader Example
//
//  Created by CoooooooderJ on 2019/9/24.
//  Copyright © 2019 CoooooooderJ. All rights reserved.
//

import UIKit

extension WSLoader {
    
}

class WSLoader: UIView {
    
    enum LoaderStyle {
        case none
        case label              // loader 中间有一个标签
        case bilabel            // loader 中间有双标签，默认主标签较大
        case excutable          // 可操作，点击暂停和启动， 配合 playAction 和 pauseAction 使用
    }
    
    enum LoaderState {
        case label
        case animating
        case paused
    }
    
    var style: LoaderStyle {
        get {
            return self.loaderStyle
        }
    }
    
    // 当 style 为 excutable 时，loader 会在这几个状态中变换
    // 开始执行时间任务时，loader 状态为 animating 或者 paused；任务完成时，为 label（或者自定制状态）
    var state: LoaderState {
        get {
            return self.loaderState
        }
        set {
            self.loaderState = newValue
            DispatchQueue.main.async {
                if self.style == .excutable && newValue == .animating {
                    self.stackView.isHidden = true
                    self.playButton.isHidden = false
                    self.playButton.setImage(UIImage(named: "pause")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                    self.playButton.imageEdgeInsets = UIEdgeInsets.zero
                }else if self.style == .excutable && newValue == .paused {
                    self.stackView.isHidden = true
                    self.playButton.isHidden = false
                    self.playButton.setImage(UIImage(named: "play")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                    self.playButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
                }else {
                    if self.value == 1 && self.stopPulsingWhenFinish {
                        self.isPulsing = false
                    }
                    self.stackView.isHidden = false
                    self.playButton.isHidden = true
                }
            }
        }
    }
    
    var playAction: ((_ atPercentageValue: CGFloat) -> ())?
    var pauseAction: ((_ atPercentageValue: CGFloat) -> ())?
    
    // MARK:- user configurable vars
    
    // 是否跳动
    var isPulsing: Bool = false {
        didSet {
            isPulsing ? animatePulsing() : removePulsing()
        }
    }
    
    var stopPulsingWhenFinish = false
    
    // 跳动层的颜色
    var pulsingColor: UIColor {
        get {
            guard let color = pulsingLayer.fillColor else { return UIColor.clear }
            return UIColor(cgColor: color)
        }
        set {
            pulsingLayer.fillColor = newValue.cgColor
        }
    }
    
    // 跳动层动画的时间函数
    var pulsingTimingFunction: CAMediaTimingFunction {
        get {
            return pulsingAnimation.timingFunction ?? CAMediaTimingFunction(name: .easeOut)
        }
        set {
            pulsingAnimation.timingFunction = newValue

            if isPulsing {
                self.removePulsing()
                self.animatePulsing()
            }
        }
    }
    
    // 跳动层动画的单次动画时间
    var pulsingDuration: CFTimeInterval {
        get {
            return pulsingAnimation.duration * 2
        }
        set {
            pulsingAnimation.duration = newValue / 2
            if isPulsing {
                self.removePulsing()
                self.animatePulsing()
            }
        }
    }
    
    // 跳动层放大倍数
    var pulsingScale: CGFloat {
        get {
            return pulsingAnimation.toValue as! CGFloat
        }
        set {
            pulsingAnimation.toValue = newValue
            if isPulsing {
                self.removePulsing()
                self.animatePulsing()
            }
        }
    }
    
    // 轨道颜色， 默认 lightGray
    var trackColor: UIColor {
        get {
            guard let color = trackLayer.strokeColor else { return UIColor.lightGray }
            return UIColor(cgColor: color)
        }
        set {
            trackLayer.strokeColor = newValue.cgColor
        }
    }
    // loader 的 tintColor， 默认 red
    var loaderColor: UIColor {
        get {
            guard let color = shapeLayer.strokeColor else { return UIColor.red }
            return UIColor(cgColor: color)
        }
        set {
            shapeLayer.strokeColor = newValue.cgColor
        }
    }
    // 轨道宽度， 默认 5
    var trackWidth: CGFloat {
        get {
            return trackLayer.lineWidth > 5 ? trackLayer.lineWidth : 5
        }
        set {
            shapeLayer.lineWidth = newValue
            trackLayer.lineWidth = newValue
        }
    }
    // 中间空白的颜色， 默认 clear
    var fillColor: UIColor {
        get {
            let color = trackLayer.fillColor
            return UIColor(cgColor: color!)
        }
        set {
            trackLayer.fillColor = newValue.cgColor
        }
    }
    // 当前 loader 的百分比
    var value: CGFloat {
        get {
            return shapeLayer.strokeEnd
        }
        set {
            shapeLayer.strokeEnd = newValue
            if newValue >= 1 {
                self.state = .label
            }
        }
    }
    // 当样式含有一到两个 label 时，主 label 的字体
    var textFont: UIFont {
        get {
            return textLabel.font
        }
        set {
            if style != .none {
                textLabel.font = newValue
            }
        }
    }
    // 当样式含有两个 label 时，副 label 的字体
    var subTextFont: UIFont {
        get {
            return subTextLabel.font
        }
        set {
            if style == .bilabel {
                subTextLabel.font = newValue
            }
        }
    }
    // 当样式含有一到两个 label 时，主 label 的颜色
    var textColor: UIColor {
        get {
            return textLabel.textColor
        }
        set {
            if style != .none {
                textLabel.textColor = newValue
            }
        }
    }
    // 当样式含有两个 label 时，副 label 的颜色
    var subTextColor: UIColor {
        get {
            return subTextLabel.textColor
        }
        set {
            if style == .bilabel {
                subTextLabel.textColor = newValue
            }
        }
    }
    // 当样式含有一到两个 label 时，主 label 的文字
    var text: String? {
        get {
            return textLabel.text
        }
        set {
            if style != .none {
                textLabel.text = newValue
            }
        }
    }
    // 当样式含有两个 label 时， 副 label 的文字
    var subText: String? {
        get {
            return subTextLabel.text
        }
        set {
            if style == .bilabel {
                subTextLabel.text = newValue
            }
        }
    }
    
    // 当样式为 excutable 时， 按钮的 tintColor
    var buttonTintColor: UIColor? {
        get {
            return playButton.tintColor
        }
        set {
            if style == .excutable {
                playButton.tintColor = newValue
            }
        }
    }
    
    // 按钮的大小
    var buttonSize: CGSize {
        get {
            return playButton.frame.size
        }
        set {
            if style == .excutable {
                let w = newValue.width
                let h = newValue.height
                let x = (frame.width - w) / 2
                let y = (frame.height - h) / 2
                playButton.frame = CGRect(x: x, y: y, width: w, height: h)
            }
        }
    }
    
    // MARK:- sublayers, subviews and private vars
    
    fileprivate var trackLayer: CAShapeLayer!
    fileprivate var shapeLayer: CAShapeLayer!
    fileprivate var pulsingLayer: CAShapeLayer!
    
    fileprivate var loaderStyle: LoaderStyle = .none
    fileprivate var loaderState: LoaderState = .label
    
    // label 和 button 的容器
    private let stackView = UIStackView()
    
    private lazy var textLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var subTextLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "download"
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var playButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "play")?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        btn.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return btn
    }()
        
    private lazy var pulsingAnimation: CABasicAnimation = {
        let anim = CABasicAnimation(keyPath: "transform.scale")
        anim.toValue = 1.3
        anim.duration = 0.8
        anim.autoreverses = true
        anim.repeatCount = Float.infinity
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
        return anim
    }()
    
    // MARK:- functions
    
    init(frame: CGRect, style: LoaderStyle) {
        let newFrame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: frame.width))
        super.init(frame: newFrame)
        self.loaderStyle = style
        if style == .excutable {
            self.loaderState = .paused
        }
        
        setupLayers()
        setupViews()
        
        isPulsing = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayers() {
        pulsingLayer = createShapeLayer(.red, fillColor: .gray, lineWidth: 0)
        self.layer.addSublayer(pulsingLayer)
        
        trackLayer = createShapeLayer(.lightGray, fillColor: .white, lineWidth: 10)
        self.layer.addSublayer(trackLayer)
        
        shapeLayer = createShapeLayer(.red, fillColor: .clear, lineWidth: 10)
        shapeLayer.strokeEnd = 0
        shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2, 0, 0, 1)
        self.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func createShapeLayer(_ strokeColor: UIColor, fillColor: UIColor, lineWidth: CGFloat) -> CAShapeLayer {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: frame.width / 2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.width / 2)
        return shapeLayer
    }
    
    fileprivate func setupViews() {
        let w = (frame.width - trackWidth) / CGFloat(sqrtf(2)) - 20
        stackView.frame.size = CGSize(width: w, height: w)
        stackView.frame.origin = CGPoint(x: (frame.width - w)/2, y: (frame.width - w)/2)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        addSubview(stackView)
        
        switch style {
        case .label:
            stackView.addArrangedSubview(textLabel)
        case .bilabel:
            stackView.addArrangedSubview(textLabel)
            stackView.addArrangedSubview(subTextLabel)
        case .excutable:
            stackView.addArrangedSubview(textLabel)
            addSubview(playButton)
            buttonSize = CGSize(width: 50, height: 50)
            stackView.isHidden = true
            playButton.isHidden = false
        default:
            break
        }
    }
    
    private func animatePulsing() {
        pulsingLayer.add(pulsingAnimation, forKey: "pulse")
    }
    
    private func removePulsing() {
        pulsingLayer.removeAnimation(forKey: "pulse")
    }

    @objc private func handleTap() {
        if state == .animating && self.pauseAction != nil {
            self.state = .paused
            self.pauseAction!(self.value)
        }else if state == .paused && self.playAction != nil {
            self.state = .animating
            self.playAction!(self.value)
        }
    }
}
