import UIKit

class AnimatedWaveLayer: CALayer {

    private let shapeLayer = CAShapeLayer()

    override init() {
        super.init()
        addSublayer(shapeLayer)
        shapeLayer.lineWidth = 30.0
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

