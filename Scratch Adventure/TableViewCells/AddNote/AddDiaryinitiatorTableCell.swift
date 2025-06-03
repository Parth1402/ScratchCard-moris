//
//  AddDiaryinitiatorTableCell.swift
//  Scratch Adventure
//
//  Created by USER on 06/05/25.
//


import UIKit
import AlignedCollectionViewFlowLayout

class AddDiaryinitiatorTableCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private let initiatorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Initiator"
        label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
        label.textColor = .white
        return label
    }()
    
    private let sarahButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sarah", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "Pink")?.cgColor
        button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
        button.clipsToBounds = true
        button.tag = 0
        return button
    }()
    
    private let peterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Peter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.backgroundColor = UIColor.clear
        button.clipsToBounds = true
        button.tag = 1
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sarahButton, peterButton])
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [initiatorTitleLabel, buttonsStackView])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    
    
    var isFieldChanged: (() -> Void)?
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        setupInitiatorView()
    }
    
    private func setupInitiatorView() {
        contentView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 20 : 8),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            sarahButton.heightAnchor.constraint(equalToConstant: 50),
            peterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        sarahButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        peterButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        applyGradientToSarahButton()
        applyGradientTopeterButton()
    }
    
    private func applyGradientToSarahButton() {
        // First remove old gradient layers
        sarahButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = sarahButton.bounds
        gradientLayer.cornerRadius = sarahButton.layer.cornerRadius
        
        gradientLayer.colors = [
            UIColor(hex: "#9A03D0", alpha: 0.2).cgColor,
            UIColor(hex: "#AF0E78", alpha: 0.2).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // left middle
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)   // right middle
        
        sarahButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func applyGradientTopeterButton() {
        // First remove old gradient layers
        peterButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = peterButton.bounds
        gradientLayer.cornerRadius = peterButton.layer.cornerRadius
        
        gradientLayer.colors = [
            UIColor(hex: "#9A03D0", alpha: 0.4).cgColor,
            UIColor(hex: "#AF0E78", alpha: 0.4).cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // left middle
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)   // right middle
        
        peterButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            selectButton(sarahButton)
            deselectButton(peterButton)
        } else {
            selectButton(peterButton)
            deselectButton(sarahButton)
        }
    }
    
    private func selectButton(_ button: UIButton) {
        // Set border color
        button.layer.borderColor = UIColor(named: "Pink")?.cgColor
        button.layer.borderWidth = 1
        
        // Remove old gradient layers
        button.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        // Add new gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayer.colors = [
            UIColor(hex: "#9A03D0", alpha: 0.4).cgColor,
            UIColor(hex: "#AF0E78", alpha: 0.4).cgColor
        ]
        
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func deselectButton(_ button: UIButton) {
        // Set border color to light gray or clear
        button.layer.borderColor = UIColor.clear.cgColor
        button.layer.borderWidth = 1
        
        // Remove all gradient layers
        button.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        // Optionally reset background color
        // Add new gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.cornerRadius = button.layer.cornerRadius
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        gradientLayer.colors = [
            UIColor(hex: "#9A03D0", alpha: 0.2).cgColor,
            UIColor(hex: "#AF0E78", alpha: 0.2).cgColor
        ]
        
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
