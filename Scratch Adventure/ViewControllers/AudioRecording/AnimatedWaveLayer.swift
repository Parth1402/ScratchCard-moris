import UIKit

class AnimatedWaveLayer: CALayer {
    
    private let shapeLayer = CAShapeLayer()
    
    override init() {
        super.init()
        addSublayer(shapeLayer)
        shapeLayer.lineWidth = 2.0
        shapeLayer.strokeColor = UIColor.purple.cgColor // Placeholder color
        shapeLayer.fillColor = UIColor.clear.cgColor // Should be clear to see the gradient through
        shapeLayer.lineCap = .round
        // Ensure shapeLayer's frame is set when bounds change
        needsDisplayOnBoundsChange = true
        // Set initial state
        opacity = 0.0 // Start invisible and fade in
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let other = layer as? AnimatedWaveLayer {
            shapeLayer.lineWidth = other.shapeLayer.lineWidth
            shapeLayer.strokeColor = other.shapeLayer.strokeColor
            shapeLayer.fillColor = other.shapeLayer.fillColor
            shapeLayer.lineCap = other.shapeLayer.lineCap
            // Copy other properties as needed
        }
        // Ensure shapeLayer's frame is set when bounds change for copied layers
        needsDisplayOnBoundsChange = true
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        // Update the shape layer's frame to match the layer's bounds
        shapeLayer.frame = bounds
        // Re-setup gradient when bounds change
        setupGradient(in: bounds)
    }
    
    func setupGradient(in bounds: CGRect) {
        // Remove existing gradient layers to avoid duplicates
        sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor(hex: "#AF0E78", alpha: 0.8).cgColor, // Adjust alpha for visibility
            UIColor(hex: "#9A03D0", alpha: 0.8).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        // Insert gradient below the shape layer
        insertSublayer(gradientLayer, at: 0)
        gradientLayer.mask = shapeLayer // Use shape layer as mask for gradient
    }
    
    func createWavyPath(in bounds: CGRect, amplitude: CGFloat, frequency: CGFloat, phase: CGFloat = 0) -> UIBezierPath {
        let path = UIBezierPath()
        // Use the center of the bounds for the circle
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2.0
        
        // Number of points to use for the path (more points = smoother wave)
        let numberOfPoints = 360 // One point per degree
        
        for i in 0..<numberOfPoints {
            let angle = CGFloat(i) * (2.0 * .pi / CGFloat(numberOfPoints))
            let displacement = sin(angle * frequency + phase) * amplitude
            let currentRadius = radius + displacement
            
            let x = center.x + currentRadius * cos(angle)
            let y = center.y + currentRadius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.close()
        return path
    }
    
    // Method to create and animate the wavy path
    func startAnimation(in bounds: CGRect) {
        // Ensure the shape layer's frame is up-to-date
        shapeLayer.frame = bounds
        
        // Remove existing animations by key
        shapeLayer.removeAnimation(forKey: "wavyPathAnimation")
        removeAnimation(forKey: "waveAnimationGroup")
        removeAnimation(forKey: "fadeInAnimation")
        
        let initialRadius = min(bounds.width, bounds.height) / 2.0
        let maxAmplitude = initialRadius * 0.1 // Example: Max amplitude is 10% of radius
        let baseFrequency: CGFloat = 3 // Base number of waves
        
        let animationDuration: CFTimeInterval = 2.0 // Duration of one cycle
        
        // Set the initial path explicitly
        shapeLayer.path = createWavyPath(in: bounds, amplitude: 0, frequency: baseFrequency).cgPath
        
        // Path Animation
        let pathAnimation = CAKeyframeAnimation(keyPath: "path")
        pathAnimation.duration = animationDuration
        pathAnimation.repeatCount = .infinity
        pathAnimation.autoreverses = false
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        pathAnimation.fillMode = .forwards
        pathAnimation.isRemovedOnCompletion = false
        
        // Define key times for the animation (e.g., start, middle, end)
        pathAnimation.keyTimes = [0.0, 0.5, 1.0]
        
        // Define the paths at key times - ensure bounds are passed correctly
        let path1 = createWavyPath(in: bounds, amplitude: 0, frequency: baseFrequency)
        let path2 = createWavyPath(in: bounds, amplitude: maxAmplitude * 0.8, frequency: baseFrequency * 1.5) // Slightly reduced amplitude
        let path3 = createWavyPath(in: bounds, amplitude: 0, frequency: baseFrequency * 2)
        
        pathAnimation.values = [path1.cgPath, path2.cgPath, path3.cgPath]
        
        // Scale Animation (to make it expand)
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 1.3 // Scale up to 130% (slightly less)
        scaleAnimation.duration = animationDuration
        scaleAnimation.repeatCount = .infinity
        scaleAnimation.autoreverses = false
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnimation.fillMode = .forwards
        scaleAnimation.isRemovedOnCompletion = false
        
        // Opacity Animation (to make it fade out)
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.duration = animationDuration
        opacityAnimation.repeatCount = .infinity
        opacityAnimation.autoreverses = false
        opacityAnimation.keyTimes = [0.0, 0.5, 1.0]
        opacityAnimation.values = [1.0, 0.6, 0.0] // Start fully visible, fade out (slightly faster fade)
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        opacityAnimation.fillMode = .forwards
        opacityAnimation.isRemovedOnCompletion = false
        
        // Group animations for scale and opacity on the AnimatedWaveLayer itself
        let group = CAAnimationGroup()
        group.duration = animationDuration
        group.repeatCount = .infinity
        group.animations = [scaleAnimation, opacityAnimation]
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        group.fillMode = .forwards
        group.isRemovedOnCompletion = false
        
        // Add the path animation to the shape layer
        shapeLayer.add(pathAnimation, forKey: "wavyPathAnimation")
        // Add the group animation to the AnimatedWaveLayer
        add(group, forKey: "waveAnimationGroup")
        
        // Add a basic fade-in animation for the layer itself
        let fadeInAnimation = CABasicAnimation(keyPath: "opacity")
        fadeInAnimation.fromValue = 0.0
        fadeInAnimation.toValue = 1.0
        fadeInAnimation.duration = 0.5
        fadeInAnimation.fillMode = .forwards
        fadeInAnimation.isRemovedOnCompletion = false
        add(fadeInAnimation, forKey: "fadeInAnimation")
        
        // Temporary debugging animation: Animate stroke color
        let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
        colorAnimation.fromValue = UIColor.purple.cgColor
        colorAnimation.toValue = UIColor.orange.cgColor
        colorAnimation.duration = 1.0 // Shorter duration to be more visible
        colorAnimation.repeatCount = .infinity
        colorAnimation.autoreverses = true // Make it reverse for easier observation
        shapeLayer.add(colorAnimation, forKey: "debugColorAnimation")
    }
    
    func stopAnimation() {
        // Remove animations by key
        shapeLayer.removeAnimation(forKey: "wavyPathAnimation")
        removeAnimation(forKey: "waveAnimationGroup")
        removeAnimation(forKey: "fadeInAnimation")
        shapeLayer.removeAnimation(forKey: "debugColorAnimation") // Remove debug animation
        
        // Optionally reset layer properties to their initial state
        // This is important to prevent the layer from staying in the final state of the animation
        CATransaction.begin()
        CATransaction.setDisableActions(true) // Disable implicit animations for the reset
        transform = CATransform3DIdentity
        opacity = 0.0 // Reset opacity to invisible
        shapeLayer.path = createWavyPath(in: bounds, amplitude: 0, frequency: 0).cgPath // Reset path to a circle
        shapeLayer.strokeColor = UIColor.purple.cgColor // Reset stroke color
        CATransaction.commit()
    }
}


class WaveAnimationView: UIView {
    
    private let pulseCount = 3
    private let pulseInterval: CFTimeInterval = 0.5
    private let pulseDuration: CFTimeInterval = 3.0
    private let pulseColor: UIColor
    private let iconColor: UIColor
    private let iconSize: CGFloat = 60
    
    private var hasStarted = false
    
    private let iconView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.contentMode = .center
        imageView.tintColor = .white
        return imageView
    }()
    
    init(color: UIColor, iconColor: UIColor) {
        self.pulseColor = color
        self.iconColor = iconColor
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .clear
        iconView.tintColor = iconColor
        iconView.backgroundColor = pulseColor
        iconView.layer.cornerRadius = iconSize / 2
        iconView.clipsToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: iconSize),
            iconView.heightAnchor.constraint(equalToConstant: iconSize)
        ])
    }
    
    func startAnimation() {
        guard !hasStarted else { return }
        hasStarted = true
        for i in 0..<pulseCount {
            DispatchQueue.main.asyncAfter(deadline: .now() + (pulseInterval * Double(i))) {
                self.createPulseLayer()
            }
        }
    }
    
    private func createPulseLayer() {
        let pulseLayer = CAShapeLayer()
        let radius: CGFloat = iconSize / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        pulseLayer.path = circularPath.cgPath
        pulseLayer.fillColor = pulseColor.cgColor
        pulseLayer.opacity = 0
        layer.insertSublayer(pulseLayer, below: iconView.layer)
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 3
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0.6
        opacityAnimation.toValue = 0
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        animationGroup.duration = pulseDuration
        animationGroup.repeatCount = .infinity
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        pulseLayer.add(animationGroup, forKey: "pulse")
    }
}


// Add the WaveCircleView class definition here
//class WaveCircleView: UIView {
//
//    private let waveLayer = CAShapeLayer()
//    private let backgroundCircleLayer = CAShapeLayer()  // For circle background and border
//    private var displayLink: CADisplayLink?
//    private var isAnimating = false
//    private var phase: CGFloat = 0
//
//    private let waveAmplitude: CGFloat = 10
//    private let waveFrequency: CGFloat = 6
//    private let waveColor: UIColor = UIColor.purple.withAlphaComponent(0.5)
//
//    private let circleBackgroundColor: UIColor = UIColor.clear // Change to any bg color you want
//    private let circleBorderColor: UIColor = UIColor.clear
//    private let circleBorderWidth: CGFloat = 2
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear  // keep clear so only the circle background shows
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        backgroundColor = .clear
//        setup()
//    }
//
//    private func setup() {
//        // Setup circle background layer
//        backgroundCircleLayer.fillColor = circleBackgroundColor.cgColor
//        backgroundCircleLayer.strokeColor = circleBorderColor.cgColor
//        backgroundCircleLayer.lineWidth = circleBorderWidth
//        layer.addSublayer(backgroundCircleLayer)
//
//        // Setup wave layer on top
//        waveLayer.fillColor = waveColor.cgColor
//        layer.addSublayer(waveLayer)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        // Update circle background frame & path
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let radius = min(bounds.width, bounds.height) / 2
//
//        let circlePath = UIBezierPath(arcCenter: center, radius: radius - circleBorderWidth/2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
//        backgroundCircleLayer.path = circlePath.cgPath
//        backgroundCircleLayer.frame = bounds
//
//        waveLayer.frame = bounds
//    }
//
//    public func start() {
//        guard !isAnimating else { return }
//        isAnimating = true
//        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
//        displayLink?.add(to: .main, forMode: .common)
//    }
//
//    public func stop() {
//        guard isAnimating else { return }
//        isAnimating = false
//        displayLink?.invalidate()
//        displayLink = nil
//    }
//
//    @objc private func updateWave() {
//        phase += 0.1
//        waveLayer.path = createWavePath().cgPath
//    }
//
//    private func createWavePath() -> UIBezierPath {
//        let path = UIBezierPath()
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let baseRadius = min(bounds.width, bounds.height) / 2 - waveAmplitude - circleBorderWidth
//        let points = 360
//        var firstPoint = true
//
//        for i in 0..<points {
//            let angle = CGFloat(i) * .pi / 180
//            let modRadius = baseRadius + waveAmplitude * sin(angle * waveFrequency + phase)
//            let x = center.x + modRadius * cos(angle)
//            let y = center.y + modRadius * sin(angle)
//
//            if firstPoint {
//                path.move(to: CGPoint(x: x, y: y))
//                firstPoint = false
//            } else {
//                path.addLine(to: CGPoint(x: x, y: y))
//            }
//        }
//
//        path.close()
//        return path
//    }
//
//    deinit {
//        displayLink?.invalidate()
//    }
//}



// Add the WaveCircleView class definition here
class WaveCircleView: UIView {
    
    private let waveLayer = CAShapeLayer()
    private let backgroundCircleLayer = CAShapeLayer()  // For circle background and border
    private var displayLink: CADisplayLink?
    private var isAnimating = false
    private var phase: CGFloat = 0
    
    private let waveAmplitude: CGFloat = 10
    private let waveFrequency: CGFloat = 6
    private let waveColor: UIColor = UIColor.purple.withAlphaComponent(0.5)
    
    private let circleBackgroundColor: UIColor = UIColor.systemGray5 // Change to any bg color you want
    private let circleBorderColor: UIColor = UIColor.purple
    private let circleBorderWidth: CGFloat = 2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear  // keep clear so only the circle background shows
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        setup()
    }
    
    private func setup() {
        // Setup circle background layer
        backgroundCircleLayer.fillColor = circleBackgroundColor.cgColor
        backgroundCircleLayer.strokeColor = circleBorderColor.cgColor
        backgroundCircleLayer.lineWidth = circleBorderWidth
        layer.addSublayer(backgroundCircleLayer)
        
        // Setup wave layer on top
        waveLayer.fillColor = waveColor.cgColor
        layer.addSublayer(waveLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Update circle background frame & path
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2
        
        let circlePath = UIBezierPath(arcCenter: center, radius: radius - circleBorderWidth/2, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        backgroundCircleLayer.path = circlePath.cgPath
        backgroundCircleLayer.frame = bounds
        
        waveLayer.frame = bounds
    }
    
    public func start() {
        guard !isAnimating else { return }
        isAnimating = true
        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    public func stop() {
        guard isAnimating else { return }
        isAnimating = false
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateWave() {
        phase += 0.1
        waveLayer.path = createWavePath().cgPath
    }
    
    private func createWavePath() -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let baseRadius = min(bounds.width, bounds.height) / 2 - waveAmplitude - circleBorderWidth
        let points = 360
        var firstPoint = true
        
        for i in 0..<points {
            let angle = CGFloat(i) * .pi / 180
            let modRadius = baseRadius + waveAmplitude * sin(angle * waveFrequency + phase)
            let x = center.x + modRadius * cos(angle)
            let y = center.y + modRadius * sin(angle)
            
            if firstPoint {
                path.move(to: CGPoint(x: x, y: y))
                firstPoint = false
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.close()
        return path
    }
    
    deinit {
        displayLink?.invalidate()
    }
}


// Add the AudioWaveformView class definition here
class AudioWaveformView: UIView {
    
    private var waveformLayer = CAShapeLayer()
    private var waveformData: [CGFloat] = [] // Array to hold normalized audio power levels
    private let maxDataPoints = 100 // Number of data points to display in the waveform
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        waveformLayer.strokeColor = UIColor.white.cgColor // Waveform color
        waveformLayer.fillColor = nil // No fill
        waveformLayer.lineWidth = 2.0 // Line thickness
        waveformLayer.lineCap = .round // Rounded line caps
        layer.addSublayer(waveformLayer)
        
        backgroundColor = .clear // Keep background clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        waveformLayer.frame = bounds // Update layer frame when view layout changes
        updateWaveformPath() // Redraw the waveform with new bounds
    }
    
    public func update(with normalizedPower: CGFloat) {
        // Add the new power level to the data array
        waveformData.append(normalizedPower)
        
        // Keep the data array size limited
        if waveformData.count > maxDataPoints {
            waveformData.removeFirst()
        }
        
        // Update the waveform path
        updateWaveformPath()
    }
    
    public func reset() {
        // Clear the waveform data and path
        waveformData.removeAll()
        updateWaveformPath()
    }
    
    private func updateWaveformPath() {
        let path = UIBezierPath()
        let width = bounds.width
        let height = bounds.height
        
        guard !waveformData.isEmpty else {
            waveformLayer.path = nil
            return
        }
        
        // Calculate the horizontal spacing between data points
        let spacing = width / CGFloat(maxDataPoints - 1)
        
        // Draw the waveform
        for (index, power) in waveformData.enumerated() {
            let x = CGFloat(index) * spacing
            // Scale the power to the height of the view, centering the waveform vertically
            let y = height / 2 - (power * height / 2)
            
            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        waveformLayer.path = path.cgPath
    }
}


// Extension for CustomNavigationBar (assuming this is defined elsewhere)
// If CustomNavigationBar is not defined, you will need to add its definition.
// extension SexTrackerViewController {
//     func setUpNavigationBar() {
//         // Existing setup code for CustomNavigationBar
//     }
// }

// Extension for setting background (assuming this is defined elsewhere)
// If setUpBackground is not defined, you will need to add its definition.
// extension UIView {
//     func setUpBackground() {
//         // Existing setup code for view background
//     }
// }
