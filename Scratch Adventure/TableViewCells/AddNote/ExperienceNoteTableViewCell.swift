//
//  ExperienceNoteTableViewCell.swift
//  Scratch Adventure
//
//  Created by USER on 28/04/25.
//

import UIKit
import CoreLocation


class ExperienceNoteTableViewCell: UITableViewCell {
    
    private let gradientLayer = CAGradientLayer()
    let locationManager = CLLocationManager()

    
    
    let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Note"
        label.textColor = .white
        label.font = UIFont.mySystemFont(ofSize: 16)
        return label
    }()
    
    let noteTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        textView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        textView.layer.cornerRadius = 16
        textView.text = "Type a note about your experience"
        textView.textColor = .lightGray
        textView.font = UIFont.mySystemFont(ofSize: 14)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        textView.isScrollEnabled = false

        return textView
    }()
    
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(" Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setImage(UIImage(named: "ic-location"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.mySystemFont(ofSize: 15)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 5)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -5)
        button.contentHorizontalAlignment = .left
        return button
    }()

    
    let addPhotosView = AddPhotosView()
    let locationView = LocationView()
    
    let photoGridView = PhotoGridView()
    
    var locationLatlong: ExperienceLocation?
    
    var Selectedimages: [UIImage] = []
    
    private let mainStackView = UIStackView()
    var locationButtonAction: (() -> Void)?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //setupGradientBackground()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGradientBackground() {
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor.purple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        
      

        noteTextView.delegate = self
        
        contentView.addSubview(mainStackView)
        
     
        
        if locationLatlong == nil {
            
            if Selectedimages == [] {
                
                mainStackView.addArrangedSubview(noteLabel)
                mainStackView.addArrangedSubview(noteTextView)
                mainStackView.addArrangedSubview(locationButton)
                mainStackView.addArrangedSubview(addPhotosView)
                let NoteTextconstraint = noteTextView.heightAnchor.constraint(equalToConstant: 150)
                NoteTextconstraint.isActive = true
                
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // Keep one only

                    
                    NoteTextconstraint,
                    locationButton.heightAnchor.constraint(equalToConstant: 50),
                    addPhotosView.heightAnchor.constraint(equalToConstant: 130)
                    
                ])
                
                
            }else {
                mainStackView.addArrangedSubview(noteLabel)
                mainStackView.addArrangedSubview(noteTextView)
                mainStackView.addArrangedSubview(locationButton)
                mainStackView.addArrangedSubview(photoGridView)
                photoGridView.setImages(Selectedimages)
                let NoteTextconstraint = noteTextView.heightAnchor.constraint(equalToConstant: 150)
                NoteTextconstraint.isActive = true
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // Keep one only,
                    
                    NoteTextconstraint,
                    locationButton.heightAnchor.constraint(equalToConstant: 50),
                    photoGridView.heightAnchor.constraint(equalToConstant: 150)
                    
                ])
                
            }
            
            
        
        }else {
            
            if Selectedimages == [] {
                
                mainStackView.addArrangedSubview(noteLabel)
                mainStackView.addArrangedSubview(noteTextView)
                mainStackView.addArrangedSubview(locationView)
                mainStackView.addArrangedSubview(addPhotosView)
                locationView.configureMap(latitude: locationLatlong?.latitude ?? 0.0 , longitude: locationLatlong?.longitude ?? 0.0 ,TitleLabel: locationLatlong?.name ?? "" ,DetailLabel: locationLatlong?.address ?? "")
                let constraint = locationView.heightAnchor.constraint(equalToConstant: 200)
                constraint.priority = .defaultLow
                constraint.isActive = true
                
                let NoteTextconstraint = noteTextView.heightAnchor.constraint(equalToConstant: 150)
                NoteTextconstraint.isActive = true

                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // Keep one only
                    
                    NoteTextconstraint,
                    addPhotosView.heightAnchor.constraint(equalToConstant: 130),
                    constraint

                    
                ])
                
            }else {
                mainStackView.addArrangedSubview(noteLabel)
                mainStackView.addArrangedSubview(noteTextView)
                mainStackView.addArrangedSubview(locationView)
                mainStackView.addArrangedSubview(photoGridView)
                locationView.configureMap(latitude: locationLatlong?.latitude ?? 0.0 , longitude: locationLatlong?.longitude ?? 0.0 ,TitleLabel: locationLatlong?.name ?? "" ,DetailLabel: locationLatlong?.address ?? "")
                let constraint = locationView.heightAnchor.constraint(equalToConstant: 200)
                constraint.priority = .defaultLow
                constraint.isActive = true
                photoGridView.setImages(Selectedimages)
                let NoteTextconstraint = noteTextView.heightAnchor.constraint(equalToConstant: 150)
                NoteTextconstraint.isActive = true
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // Keep one only,
                    
                    NoteTextconstraint,
                    photoGridView.heightAnchor.constraint(equalToConstant: 150),
                   constraint
                    
                ])
                
            }
      
        }
    }
    
    func configure(with location: ExperienceLocation) {
        locationLatlong = location
        
        // Remove previous arranged subviews
        mainStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        if let location = locationLatlong, location.name.isEmpty {
            if Selectedimages == [] {
                
                mainStackView.addArrangedSubview(noteLabel)
                mainStackView.addArrangedSubview(noteTextView)
                mainStackView.addArrangedSubview(locationButton)
                mainStackView.addArrangedSubview(addPhotosView)
                let NoteTextconstraint = noteTextView.heightAnchor.constraint(equalToConstant: 150)
                NoteTextconstraint.isActive = true
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // Keep one only,
                    
                   NoteTextconstraint,
                    locationButton.heightAnchor.constraint(equalToConstant: 50),
                    addPhotosView.heightAnchor.constraint(equalToConstant: 130)
                    
                ])
                
                
            }else {
                mainStackView.addArrangedSubview(noteLabel)
                mainStackView.addArrangedSubview(noteTextView)
                mainStackView.addArrangedSubview(locationButton)
                mainStackView.addArrangedSubview(photoGridView)
                photoGridView.setImages(Selectedimages)
                let NoteTextconstraint = noteTextView.heightAnchor.constraint(equalToConstant: 150)
                NoteTextconstraint.isActive = true
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // Keep one only
                    
                    NoteTextconstraint,
                    locationButton.heightAnchor.constraint(equalToConstant: 50),
                    photoGridView.heightAnchor.constraint(equalToConstant: 150)
                    
                ])
                
            }
            
            
            
        }else {
            
            if Selectedimages == [] {
                
                mainStackView.addArrangedSubview(noteLabel)
                mainStackView.addArrangedSubview(noteTextView)
                mainStackView.addArrangedSubview(locationView)
                mainStackView.addArrangedSubview(addPhotosView)
                locationView.configureMap(latitude: locationLatlong?.latitude ?? 0.0 , longitude: locationLatlong?.longitude ?? 0.0 ,TitleLabel: locationLatlong?.name ?? "" ,DetailLabel: locationLatlong?.address ?? "")
                let constraint = locationView.heightAnchor.constraint(equalToConstant: 200)
                constraint.priority = .defaultLow
                constraint.isActive = true
                let NoteTextconstraint = noteTextView.heightAnchor.constraint(equalToConstant: 150)
                NoteTextconstraint.isActive = true
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // Keep one only
                  
                    
                    NoteTextconstraint,
                    addPhotosView.heightAnchor.constraint(equalToConstant: 130),
               constraint
                    
                ])
                
            }else {
                mainStackView.addArrangedSubview(noteLabel)
                mainStackView.addArrangedSubview(noteTextView)
                mainStackView.addArrangedSubview(locationView)
                mainStackView.addArrangedSubview(photoGridView)
                photoGridView.setImages(Selectedimages)
                locationView.configureMap(latitude: locationLatlong?.latitude ?? 0.0 , longitude: locationLatlong?.longitude ?? 0.0 ,TitleLabel: locationLatlong?.name ?? "" ,DetailLabel: locationLatlong?.address ?? "")
                let constraint = locationView.heightAnchor.constraint(equalToConstant: 200)
                constraint.priority = .defaultLow
                constraint.isActive = true
                let NoteTextconstraint = noteTextView.heightAnchor.constraint(equalToConstant: 150)
                NoteTextconstraint.isActive = true
                NSLayoutConstraint.activate([
                    mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
                    mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20), // Keep one only,
                    
                    NoteTextconstraint,
                    photoGridView.heightAnchor.constraint(equalToConstant: 150),
                    constraint
                    
                ])
                
            }
            
        }
    }
    
    func getlocation(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = contentView.bounds
    }
    
    @objc private func locationButtonTapped() {
        print("📍 Location Button Tapped!")

        // Or call back to your ViewController:
        locationButtonAction?()
    }
}


extension ExperienceNoteTableViewCell: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type a note about your experience" {
            textView.text = ""
            textView.textColor = .white // or whatever your active text color
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Type a note about your experience"
            textView.textColor = .lightGray
        }
    }
}

extension ExperienceNoteTableViewCell: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude

        print("Current Location: \(latitude), \(longitude)")

        // Optional: Stop updates for battery
        manager.stopUpdatingLocation()

        locationView.configureMap(latitude: locationLatlong?.latitude ?? 0.0 , longitude: locationLatlong?.longitude ?? 0.0 ,TitleLabel: locationLatlong?.name ?? "" ,DetailLabel: locationLatlong?.address ?? "")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}



extension CLLocationCoordinate2D {
    var isEmpty: Bool {
        return !CLLocationCoordinate2DIsValid(self) || (latitude == 0.0 && longitude == 0.0)
    }
}
