import UIKit

class CustomContainerView: UIView {
    
    // MARK: - Properties
    private let cornerRadius: CGFloat
    private let backgroundColorAlpha: CGFloat
    
    // MARK: - Initialization
    init(cornerRadius: CGFloat = 16, backgroundColorAlpha: CGFloat = 0.1) {
        self.cornerRadius = cornerRadius
        self.backgroundColorAlpha = backgroundColorAlpha
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        self.cornerRadius = 16
        self.backgroundColorAlpha = 0.1
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white.withAlphaComponent(backgroundColorAlpha)
        layer.cornerRadius = cornerRadius
    }
    
    // MARK: - Public Methods
    func updateBackgroundAlpha(_ alpha: CGFloat) {
        backgroundColor = UIColor.white.withAlphaComponent(alpha)
    }
    
    func updateCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
} 