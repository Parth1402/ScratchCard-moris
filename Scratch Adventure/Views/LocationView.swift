//
//  LocationView.swift
//  Scratch Adventure
//
//  Created by USER on 29/04/25.
//


import UIKit
import MapKit
import CoreLocation


class LocationView: UIView {
    
    let locationManager = CLLocationManager()

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Location"
        label.font = UIFont.mymediumSystemFont(ofSize: 16)
        label.textColor = .white
        return label
    }()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.layer.cornerRadius = 20
        
        map.isScrollEnabled = false
//        map.isZoomEnabled = false
//        map.isRotateEnabled = false
//        map.isPitchEnabled = false

        return map
    }()
    
    var ContentContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor(named: "Pink")?.cgColor
        view.backgroundColor = UIColor.purple.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pinImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic_map-pin"))
        imageView.tintColor = .red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addressIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "ic-location"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.mymediumSystemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let addressDetailLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.mySystemFont(ofSize: 12)
        label.textColor = UIColor.white
        return label
    }()
    
    private let adjustButton: UIButton = {
        let button = UIButton()
        button.setTitle("Adjust", for: .normal)
        button.titleLabel?.font = UIFont.mySystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        button.layer.cornerRadius = 12
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12)
        return button
    }()
    
    var tapAction: (() -> Void)? // Closure for tap handling
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(titleLabel)
        addSubview(ContentContainer)
        
        
        ContentContainer.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })

//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = ContentContainer.bounds
//        gradientLayer.cornerRadius = ContentContainer.layer.cornerRadius
//
//        gradientLayer.colors = [
//            UIColor(hex: "#9A03D0", alpha: 0.2).cgColor,
//            UIColor(hex: "#AF0E78", alpha: 0.2).cgColor
//        ]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5) // left middle
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)   // right middle
//
//        ContentContainer.layer.insertSublayer(gradientLayer, at: 0)
        
        NSLayoutConstraint.activate([
            ContentContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            ContentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            ContentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            ContentContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        
        adjustButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        
        ContentContainer.addSubview(mapView)
        

        mapView.addSubview(pinImageView)
        ContentContainer.addSubview(addressIcon)
        ContentContainer.addSubview(addressTitleLabel)
        ContentContainer.addSubview(addressDetailLabel)
        mapView.addSubview(adjustButton)
        
        mapView.delegate = self
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        addressIcon.translatesAutoresizingMaskIntoConstraints = false
        addressTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addressDetailLabel.translatesAutoresizingMaskIntoConstraints = false
        adjustButton.translatesAutoresizingMaskIntoConstraints = false
        
       
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            mapView.topAnchor.constraint(equalTo: ContentContainer.topAnchor, constant: 10),
            mapView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor,constant: 8),
            mapView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor,constant: -8),
            mapView.heightAnchor.constraint(equalToConstant: 120),
            
            pinImageView.centerXAnchor.constraint(equalTo: mapView.centerXAnchor),
            pinImageView.centerYAnchor.constraint(equalTo: mapView.centerYAnchor, constant: -20),
            pinImageView.widthAnchor.constraint(equalToConstant: 24),
            pinImageView.heightAnchor.constraint(equalToConstant: 24),
            
            addressIcon.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 12),
            addressIcon.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 10),
            addressIcon.widthAnchor.constraint(equalToConstant: 16),
            addressIcon.heightAnchor.constraint(equalToConstant: 16),
            
            addressTitleLabel.leadingAnchor.constraint(equalTo: addressIcon.trailingAnchor, constant: 8),
            addressTitleLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8),
            
            addressDetailLabel.leadingAnchor.constraint(equalTo: addressTitleLabel.trailingAnchor, constant: 8),
            addressDetailLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 8),
            
            adjustButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -12),
            adjustButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10)
        ])
        adjustButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
    }
    
    func configureMap(latitude: CLLocationDegrees, longitude: CLLocationDegrees, TitleLabel: String, DetailLabel: String) {
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        mapView.mapType = .mutedStandard
        mapView.overrideUserInterfaceStyle = .dark
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        addressTitleLabel.text = TitleLabel
        addressDetailLabel.text = DetailLabel
    }
    
    @objc private func viewTapped() {
        tapAction?()
    }
}


extension LocationView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation ) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        let identifier = "Pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = false
            view?.pinTintColor = .red
        } else {
            view?.annotation = annotation
        }
        return view
    }
}


