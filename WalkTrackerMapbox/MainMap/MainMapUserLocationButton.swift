import UIKit

class MainMapUserLocationButton: UIButton {
    private var arrow: CAShapeLayer?
    
    let buttonSize: CGFloat
    private let alphaComponent: CGFloat
    private let cornerRadius: CGFloat
    private var isButtonTouched = false
    private var substrateColor: UIColor?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(buttonSize: CGFloat, alphaComponent: CGFloat, cornerRadius: CGFloat) {
        self.buttonSize = buttonSize
        self.alphaComponent = alphaComponent
        self.cornerRadius = cornerRadius
        
        super.init(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        
        setupButton()
    }
    
    private func setupButton() {
        let color = substrateColor ?? .white
        self.backgroundColor = color.withAlphaComponent(alphaComponent)
        self.layer.cornerRadius = cornerRadius
        
        setupArrow()
        layer.addSublayer(self.arrow ?? CAShapeLayer())
    }
    
    private func setupArrow() {
        let arrow = CAShapeLayer()
        arrow.path = arrowPath()
        arrow.lineWidth = 2
        arrow.lineJoin = CAShapeLayerLineJoin.round
        arrow.bounds = CGRect(x: 0, y: 0, width: buttonSize / 2, height: buttonSize / 2)
        arrow.position = CGPoint(x: buttonSize / 2, y: buttonSize / 2)
        arrow.shouldRasterize = true
        arrow.rasterizationScale = UIScreen.main.scale
        arrow.drawsAsynchronously = true
        arrow.fillColor = UIColor.clear.cgColor
        arrow.strokeColor = UIColor.black.cgColor
        
        self.arrow = arrow
    }
    
    private func arrowPath() -> CGPath {
        let bezierPath = UIBezierPath()
        let max: CGFloat = buttonSize / 2
        bezierPath.move(to: CGPoint(x: max * 0.5, y: 0))
        bezierPath.addLine(to: CGPoint(x: max * 0.1, y: max))
        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: max * 0.65))
        bezierPath.addLine(to: CGPoint(x: max * 0.9, y: max))
        bezierPath.addLine(to: CGPoint(x: max * 0.5, y: 0))
        bezierPath.close()
        
        return bezierPath.cgPath
    }
}
