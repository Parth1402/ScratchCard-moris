//
//  UIHelper.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-08.
//

import Foundation
import UIKit

class ScreenSize {
    static let bounds = UIScreen.main.bounds
    static let width = bounds.width
    static let height = bounds.height
}

extension Int {
    
    func pulse(_ value: Int = 5) -> CGFloat {
        return CGFloat(DeviceSize.isiPadDevice ? self + value : self)
    }
    
    func pulse2Font() -> CGFloat  {
        return CGFloat(DeviceSize.isiPadDevice ? self + 2 : self)
    }
    
    func pulseWithFont(withInt: Int) -> CGFloat  {
        return CGFloat(DeviceSize.isiPadDevice ? self + withInt : self)
    }
}

class DeviceSize {
    static let isiPadDevice = UIDevice.current.userInterfaceIdiom == .pad
    
    //Constraints
    static let onbordingButtonLeftRightPadding = UIDevice.current.userInterfaceIdiom == .pad ? ScreenSize.width * 0.17 : ScreenSize.width * 0.2
    static let onbordingContentLeftRightPadding = UIDevice.current.userInterfaceIdiom == .pad ? ScreenSize.width * 0.20 : ScreenSize.width * 0.13
    static let onbordingContentTopPadding = UIDevice.current.userInterfaceIdiom == .pad ? ScreenSize.height * 0.08 : ScreenSize.height * 0.05
    static let onbordingTextFieldLeftRightPadding = UIDevice.current.userInterfaceIdiom == .pad ? ScreenSize.width * 0.20 : 20
    
    //Fonts
    static let fontFor26 = UIDevice.current.userInterfaceIdiom == .pad ? 32.0 : 26.0
    static let fontFor16 = UIDevice.current.userInterfaceIdiom == .pad ? 18.0 : 16.0
    static let fontFor15 = UIDevice.current.userInterfaceIdiom == .pad ? 22.0 : 15.0
    static let fontFor14 = UIDevice.current.userInterfaceIdiom == .pad ? 20.0 : 14.0
}

class CommonView {
    
    static func getViewWithShadowAndRadius(cornerRadius: CGFloat = 15) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = cornerRadius
        view.backgroundColor = .white
        view.dropShadow()
        return view
    }
    
    static func getCommonLabel(text: String, textColor: UIColor? = appColor ?? .black, font: UIFont = .systemFont(ofSize: 14.pulse2Font()), lines: Int = 1, alignment: NSTextAlignment = .left) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textColor = textColor
        label.font = font
        label.numberOfLines = lines
        label.textAlignment = alignment
        return label
    }
    
    static func getCommonButton(title: String, font: UIFont = .mymediumSystemFont(ofSize: 16), titleColor: UIColor? = .white, backgroundColor: UIColor = buttonAppLightColor ?? .purple, cornerRadius: CGFloat = 15) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        button.dropShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func getCommonImageView(image: String, cornerRadius: CGFloat = 0) -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: image)
        imageView.layer.cornerRadius = cornerRadius
        return imageView
    }
}

class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = (min(bounds.width, bounds.height) / 2)// + 80
        clipsToBounds = true
    }
}

extension UILabel {
    func setFontScaleWithWidth() {
        self.numberOfLines = 2
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor = 0.2
    }
    
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return index
        
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        
        return ceil(boundingBox.height)
    }
}

extension UIView {
    
    public var widthOfView: CGFloat {
        self.bounds.width
    }
    
    public var heightOfView: CGFloat {
        self.bounds.width
    }
    
    func setUpBackground() {
        let backgroundImage = UIImageView(frame: ScreenSize.bounds)
        backgroundImage.image = UIImage(named: "homeScreenBackground")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        self.addSubview(backgroundImage)
        self.sendSubviewToBack(backgroundImage)
    }
    
    private static let kLayerNameGradientBorder = "GradientBorderLayer"
    
    func gradientBorder(
        width: CGFloat,
        colors: [UIColor],
        startPoint: CGPoint = .init(x: 0.5, y: 0),
        endPoint: CGPoint = .init(x: 0.5, y: 1),
        andRoundCornersWithRadius cornerRadius: CGFloat = 0
    ) {
        let existingBorder = gradientBorderLayer()
        let border = existingBorder ?? .init()
        border.frame = CGRect(
            x: bounds.origin.x,
            y: bounds.origin.y,
            width: bounds.size.width + width,
            height: bounds.size.height + width
        )
        border.colors = colors.map { $0.cgColor }
        border.startPoint = startPoint
        border.endPoint = endPoint
        
        let mask = CAShapeLayer()
        let maskRect = CGRect(
            x: bounds.origin.x + width/2,
            y: bounds.origin.y + width/2,
            width: bounds.size.width - width,
            height: bounds.size.height - width
        )
        mask.path = UIBezierPath(
            roundedRect: maskRect,
            cornerRadius: cornerRadius
        ).cgPath
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = width
        
        border.mask = mask
        
        let isAlreadyAdded = (existingBorder != nil)
        if !isAlreadyAdded {
            layer.addSublayer(border)
        }
    }
    
    private func gradientBorderLayer() -> CAGradientLayer? {
        let borderLayers = layer.sublayers?.filter {
            $0.name == UIView.kLayerNameGradientBorder
        }
        if borderLayers?.count ?? 0 > 1 {
            fatalError()
        }
        return borderLayers?.first as? CAGradientLayer
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}

class GradientView: UIView {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    private func setupGradient() {
        guard let gradientLayer = self.layer as? CAGradientLayer else {
            return
        }

        // Define the gradient colors
        let topColor = UIColor(hexString: "51006E")
        let bottomColor = UIColor(hexString: "510738")

        gradientLayer.colors = [topColor, bottomColor]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0) // Vertical gradient
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)

//        // Set the gradient direction
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
    }
}


class StarsView: UIView {
    
    var rating: Double = 6.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    func starPath(size: CGFloat, full: Bool) -> UIBezierPath {
        let fullPoints = [CGPoint(x: 0.5, y: 0.03), CGPoint(x: 0.61, y: 0.38), CGPoint(x: 0.99, y: 0.38), CGPoint(x: 0.68, y: 0.61), CGPoint(x: 0.8, y: 0.97), CGPoint(x: 0.5, y: 0.75), CGPoint(x: 0.2, y: 0.97), CGPoint(x: 0.32, y: 0.61), CGPoint(x: 0.01, y: 0.38), CGPoint(x: 0.39, y: 0.38)].map({ CGPoint(x: $0.x * size, y: $0.y * size) })
        let halfPoints = [CGPoint(x: 0.5, y: 0.03), CGPoint(x: 0.5, y: 0.75), CGPoint(x: 0.2, y: 0.97), CGPoint(x: 0.32, y: 0.61), CGPoint(x: 0.01, y: 0.38), CGPoint(x: 0.39, y: 0.38)].map({ CGPoint(x: $0.x * size, y: $0.y * size) })
        let points = full ? fullPoints : halfPoints
        let starPath = UIBezierPath()
        starPath.move(to: points.last!)
        for point in points {
            starPath.addLine(to: point)
        }
        return starPath
    }
    
    func starLayer(full: Bool) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = starPath(size: bounds.size.height - 3, full: full).cgPath
        shapeLayer.fillColor = UIColor(hexString: "FFC42C")?.cgColor ?? UIColor.yellow.cgColor
        return shapeLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let sublayers = layer.sublayers
        for sublayer in sublayers ?? [] {
            sublayer.removeFromSuperlayer()
        }
        for i in 1...6 {
            if rating >= Double(i) - 0.5 {
                let star = starLayer(full: rating >= Double(i))
                star.transform = CATransform3DMakeTranslation(bounds.size.height * CGFloat(i - 1), 0, 0)
                layer.addSublayer(star)
            }
        }
    }
}

class NoPasteTextField: UITextField {

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // Disable the paste action
        if action == #selector(UIResponderStandardEditActions.paste(_:)) || action == #selector(UIResponderStandardEditActions.cut(_:)) || action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return false
        }

        // Call the super implementation for other actions
        return super.canPerformAction(action, withSender: sender)
    }
}


extension UIView {
    
    func createImageTextAttachmentText(imageName: String, text: String, imageSize: CGSize = CGSize(width: 16, height: 16), imageOffsetY: CGFloat = -2.0) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageSize.width, height: imageSize.height)

        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " \(text)")

        let completeText = NSMutableAttributedString()
        completeText.append(attachmentString)
        completeText.append(textString)

        return completeText
    }
    
    func createImageWithTextAttachment(imageName: String, text: String, imageSize: CGSize = CGSize(width: 16, height: 16), imageOffsetY: CGFloat = -2.0) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: imageName)
        attachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageSize.width, height: imageSize.height)

        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " \(text)")

        let completeText = NSMutableAttributedString()
        completeText.append(attachmentString)
        completeText.append(textString)

        return completeText
    }
}


// MARK: - Custom Layout
class OverlappingFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        for (index, attr) in attributes.enumerated() {
            attr.zIndex = index
            attr.frame.origin.x = attr.frame.origin.x - CGFloat(index * 20)
        }
        return attributes
    }
}

import AVFoundation
import UIKit

extension UIImage {
    static func thumbnailFromVideoData(_ data: Data) -> UIImage? {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
        do {
            try data.write(to: tempURL)
            let asset = AVAsset(url: tempURL)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true

            let time = CMTime(seconds: 1.0, preferredTimescale: 600)
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print("❌ Failed to generate thumbnail:", error)
            return nil
        }
    }
}

extension UIViewController {
    // ✅ Helper function to get file URL in the Documents directory
    func getFileURL(for fileName: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return documentsDirectory.appendingPathComponent(fileName)
    }
}
