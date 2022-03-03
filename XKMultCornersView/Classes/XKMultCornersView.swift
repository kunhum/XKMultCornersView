//
//  CornerRadiusView.swift
//  MessDemo
//
//  Created by kenneth on 2022/3/2.
//

import UIKit

public class XKMultCornersView: UIView {
    
    public enum DrawType {
        case drawRect
        case shapeLayer
    }
    
    public typealias CornerRadiusTuple = (topLeft: CGFloat,
                                          topRight: CGFloat,
                                          bottomLeft: CGFloat,
                                          bottomRight: CGFloat)
    fileprivate typealias DrawInfo = (center: CGPoint,
                                      radius: CGFloat,
                                      startAngle: CGFloat,
                                      endAngle: CGFloat)
    
    ///背景色
    @IBInspectable public var fillColor: UIColor = .orange
    ///圆角
    public var corners: CornerRadiusTuple = (0, 0, 0, 0)
    ///绘制方式
    public var drawType: DrawType = .drawRect
    
    fileprivate var shapeLayer: CAShapeLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initMethod()
    }
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initMethod()
    }
    
}

extension XKMultCornersView {
    
    func initMethod() {
        
        backgroundColor = .clear
        layer.addSublayer(shapeLayer)
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard drawType == .drawRect else { return   }
        drawCorners(rect: rect)
    }
}

public extension XKMultCornersView {
    
    func update() {
        switch drawType {
        case .drawRect:
            setNeedsDisplay()
        case .shapeLayer:
            addCorners()
        }
    }
}

fileprivate extension XKMultCornersView {
    
    func addCorners() {
        
        let path: UIBezierPath = UIBezierPath()
        
        //左上角
        var info: DrawInfo = calculateInfo(corner: .topLeft)
        path.addArc(withCenter: info.center,
                    radius: info.radius,
                    startAngle: info.startAngle,
                    endAngle: info.endAngle,
                    clockwise: true
        )
        
        //右上角
        info = calculateInfo(corner: .topRight)
        path.addArc(withCenter: info.center,
                    radius: info.radius,
                    startAngle: info.startAngle,
                    endAngle: info.endAngle,
                    clockwise: true
        )
        
        //右下角
        info = calculateInfo(corner: .bottomRight)
        path.addArc(withCenter: info.center,
                    radius: info.radius,
                    startAngle: info.startAngle,
                    endAngle: info.endAngle,
                    clockwise: true
        )
        
        //左下角
        info = calculateInfo(corner: .bottomLeft)
        path.addArc(withCenter: info.center,
                    radius: info.radius,
                    startAngle: info.startAngle,
                    endAngle: info.endAngle,
                    clockwise: true
        )
        
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.path      = path.cgPath
    }
    
    func drawCorners(rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        //左上角
        var info: DrawInfo = calculateInfo(corner: .topLeft)
        context.addArc(center: info.center,
                       radius: info.radius,
                       startAngle: info.startAngle,
                       endAngle: info.endAngle,
                       clockwise: false
        )
        
        //右上角
        info = calculateInfo(corner: .topRight)
        context.addArc(center: info.center,
                       radius: info.radius,
                       startAngle: info.startAngle,
                       endAngle: info.endAngle,
                       clockwise: false
        )
        
        //右下角
        info = calculateInfo(corner: .bottomRight)
        context.addArc(center: info.center,
                       radius: info.radius,
                       startAngle: info.startAngle,
                       endAngle: info.endAngle,
                       clockwise: false
        )
        
        //左下角
        info = calculateInfo(corner: .bottomLeft)
        context.addArc(center: info.center,
                       radius: info.radius,
                       startAngle: info.startAngle,
                       endAngle: info.endAngle,
                       clockwise: false
        )
        
        context.closePath()
        context.setFillColor(fillColor.cgColor)
        context.drawPath(using: .fill)
    }
    
    func calculateInfo(corner: UIRectCorner) -> DrawInfo {
        
        let width: CGFloat  = bounds.width
        let height: CGFloat = bounds.height
        var x: CGFloat      = 0.0
        var y: CGFloat      = 0.0
        var radius: CGFloat = 0.0
        
        switch corner {
        case .topLeft:
            x      = corners.topLeft
            y      = x
            radius = corners.topLeft
        case .topRight:
            x      = width - corners.topRight
            y      = corners.topRight
            radius = corners.topRight
        case .bottomRight:
            x      = width - corners.bottomRight
            y      = height - corners.bottomRight
            radius = corners.bottomRight
        case .bottomLeft:
            x      = corners.bottomLeft
            y      = height - corners.bottomLeft
            radius = corners.bottomLeft
        default:
            return (CGPoint.zero, 0.0, 0.0, 0.0)
        }
        
        let center: CGPoint     = CGPoint(x: x, y: y)
        return (center, radius, corner.angle().start, corner.angle().end)
    }
}

extension UIRectCorner {
    
    typealias Angle = (start: CGFloat, end: CGFloat)
    
    func angle() -> Angle {
        return (convert(angleValue() - 45.0),
                convert(angleValue() + 45.0))
    }
    
    private func angleValue() -> CGFloat {
        switch self {
        case .topLeft:
            return 225.0
        case .topRight:
            return 315.0
        case .bottomLeft:
            return 135.0
        case .bottomRight:
            return 45.0
        default:
            return 0.0
        }
    }
    
    private func convert(_ arc: CGFloat) -> CGFloat {
        return CGFloat.pi / 180.0 * arc
    }
}
