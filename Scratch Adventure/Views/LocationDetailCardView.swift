//
//  LocationDetailCardView.swift
//  Scratch Adventure
//
//  Created by USER on 06/05/25.
//


import UIKit

class LocationDetailCardView: UIView {

    let titleLabel = UILabel()
    let addressLabel = UILabel()
    let separator = UIView()
    let addNoteButton = UIButton(type: .system)

    var onAddNoteTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCardView()
    }

    private func setupCardView() {
        backgroundColor = UIColor(red: 14/255, green: 21/255, blue: 48/255, alpha: 1)
        layer.cornerRadius = 20
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
   let currentData = LocationManager.shared.loadCurrentLocation()

        // Title Label
        titleLabel.text = currentData.name //"Fabric Emalia"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Address Label
        addressLabel.text = currentData.address//"477 S 14th Street, Gutmannstead 90601"
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        addressLabel.textColor = UIColor(white: 1, alpha: 0.6)
        addressLabel.translatesAutoresizingMaskIntoConstraints = false

        // Separator
        separator.backgroundColor = UIColor(white: 1, alpha: 0.2)
        separator.translatesAutoresizingMaskIntoConstraints = false

        // Add Note Button
 
        addNoteButton.setTitle("Add diary note", for: .normal)
        addNoteButton.setTitleColor(.white, for: .normal)
        addNoteButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

               // Set image
               if let icon = UIImage(named: "ic_Plus")?.withRenderingMode(.alwaysOriginal) {
                   addNoteButton.setImage(icon, for: .normal)
               }

               // Layout and styling
        addNoteButton.tintColor = .white
        addNoteButton.backgroundColor = .systemBlue
        addNoteButton.layer.cornerRadius = 16
        addNoteButton.clipsToBounds = true
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false

               // Padding between image and text
        addNoteButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        addNoteButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        addNoteButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)

     

        addSubview(titleLabel)
        addSubview(addressLabel)
        addSubview(separator)
        addSubview(addNoteButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            addressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            separator.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 12),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            separator.heightAnchor.constraint(equalToConstant: 1),

            addNoteButton.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 12),
            addNoteButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addNoteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addNoteButton.heightAnchor.constraint(equalToConstant: 44),
            addNoteButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        addNoteButton.layer.sublayers?.first?.frame = addNoteButton.bounds // update gradient size
        
        // Gradient background
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemPurple.cgColor, UIColor.systemBlue.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = CGRect(x: 0, y: 0, width: 300, height: 44)
        gradient.cornerRadius = 16
        addNoteButton.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupdata(name:String, address:String){
        titleLabel.text = name
        addressLabel.text = address
        
    }

    @objc private func addNoteTapped() {
        onAddNoteTapped?()
    }
}
