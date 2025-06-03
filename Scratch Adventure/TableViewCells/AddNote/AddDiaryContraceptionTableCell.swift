//
//  AddDiaryContraceptionTableCell.swift
//  Scratch Adventure
//
//  Created by USER on 25/04/25.
//

import UIKit
import AlignedCollectionViewFlowLayout

class AddDiaryContraceptionTableCell: UITableViewCell {
    
    // MARK: - UI Elements
    
    private var  stylelengthArray = [String]()
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    var SelectedCell = 0
    
    var isFilledNote = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
        return label
    }()
    
    private let buttonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = AlignedCollectionViewFlowLayout(horizontalAlignment: .left, verticalAlignment: .top)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false // ⛔ Important: Disable scrolling
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
//    private let initiatorTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Initiator"
//        label.font = UIFont.boldSystemFont(ofSize: 16.pulse2Font())
//        label.textColor = .white
//        return label
//    }()
//    
//    private let sarahButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Sarah", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        button.layer.cornerRadius = 16
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor(named: "Pink")?.cgColor
//        button.backgroundColor = UIColor.systemPink.withAlphaComponent(0.2)
//        button.clipsToBounds = true
//        button.tag = 0
//        return button
//    }()
//    
//    private let peterButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Peter", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        button.layer.cornerRadius = 16
//        button.layer.borderWidth = 1
//        button.backgroundColor = UIColor.clear
//        button.clipsToBounds = true
//        button.tag = 1
//        return button
//    }()
//    
//    private lazy var buttonsStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [sarahButton, peterButton])
//        stackView.axis = .horizontal
//        stackView.spacing = 16
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
//    
//    private lazy var mainStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [initiatorTitleLabel, buttonsStackView])
//        stackView.axis = .vertical
//        stackView.spacing = 16
//        return stackView
//    }()
    
    
    
    var isFieldChanged: (() -> Void)?
    private var selectedIndex: IndexPath?
    
    var isAddContraception: (() -> Void)?
    
    
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
      //  setupInitiatorView()
        contentView.addSubview(titleLabel)
        contentView.addSubview(buttonContainerView)
        buttonContainerView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NoteTagesCollectionViewCell.self, forCellWithReuseIdentifier: "NoteTagesCollectionViewCell")
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant:16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            buttonContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            buttonContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            buttonContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            buttonContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: buttonContainerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: buttonContainerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: buttonContainerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: buttonContainerView.bottomAnchor),
            // collectionView.heightAnchor.constraint(equalToConstant: 120)
        ])
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionViewHeightConstraint?.isActive = true
        
        
    }
    
//    private func setupInitiatorView() {
//        contentView.addSubview(mainStackView)
//        mainStackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DeviceSize.isiPadDevice ? 20 : 8),
//            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            sarahButton.heightAnchor.constraint(equalToConstant: 50),
//            peterButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//        
//        sarahButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//        peterButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.layoutIfNeeded()
        collectionViewHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    
    func configure(withTitle title: String, Array array: [String],isfilledNote:Bool) {
        isFilledNote = isfilledNote
        self.titleLabel.text = title
        self.stylelengthArray = array
        collectionView.reloadData()
        
        
        collectionView.performBatchUpdates(nil) { [weak self] _ in
            self?.collectionView.layoutIfNeeded()
            self?.collectionViewHeightConstraint?.constant = self?.collectionView.collectionViewLayout.collectionViewContentSize.height ?? 0.0
            self?.invalidateIntrinsicContentSize()
            
            //            // Important if your cell uses automatic height
            //            self.superview?.setNeedsLayout()
            //            self.superview?.layoutIfNeeded()
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

// MARK: - UICollectionViewDelegate, DataSource

extension AddDiaryContraceptionTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stylelengthArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteTagesCollectionViewCell", for: indexPath) as? NoteTagesCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = stylelengthArray[indexPath.item]
        
        cell.setupUI(headlineTitle: title)
        
        if isFilledNote {
            cell.setSelectedAppearance(true)
        }else {
            cell.setSelectedAppearance(selectedIndex == indexPath)
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let previousIndex = selectedIndex
        selectedIndex = indexPath
        
        
        if !isFilledNote {
            if indexPath.item ==  stylelengthArray.count - 1 {
                isAddContraception?()
                
            } else {
                
                // Reload previous and current cells to update UI
                var indexPathsToReload = [indexPath]
                if let previous = previousIndex, previous != indexPath {
                    indexPathsToReload.append(previous)
                }
                
                let title = stylelengthArray[indexPath.item]
                
                if SelectedCell == 0 {
                    
                    if let action = self.isFieldChanged {
                        action()
                    }
                }else {
                    
                    if let action = self.isFieldChanged {
                        action()
                    }
                    
                }
                collectionView.reloadItems(at: indexPathsToReload)
                
            }
            
        }
    }
}

// MARK: - Helper for hex color
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexFormatted.hasPrefix("#") {
            hexFormatted.remove(at: hexFormatted.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
