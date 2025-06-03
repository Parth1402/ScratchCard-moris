//
//  AddPhotosView.swift
//  Scratch Adventure
//
//  Created by USER on 28/04/25.
//


import UIKit

class AddPhotosView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_camera"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = "Add photos"
        label.textColor = .white
        label.font = UIFont.mySystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    private let stackView = UIStackView()

    var tapAction: (() -> Void)? // Closure for tap handling

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        backgroundColor =  UIColor.purple.withAlphaComponent(0.5)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBorder()
    }

    private func addDashedBorder() {
        layer.sublayers?.filter({ $0.name == "dashedBorder" }).forEach({ $0.removeFromSuperlayer() })

        let dashedBorder = CAShapeLayer()
        dashedBorder.name = "dashedBorder"
        dashedBorder.strokeColor = UIColor.white.withAlphaComponent(0.5).cgColor
        dashedBorder.lineDashPattern = [7, 5]
        dashedBorder.fillColor = nil
        dashedBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12).cgPath
        dashedBorder.frame = bounds

        layer.addSublayer(dashedBorder)
    }

    @objc private func viewTapped() {
        tapAction?()
    }
}
