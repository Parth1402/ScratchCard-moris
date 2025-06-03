//
//  MapViewController.swift
//  Scratch Adventure
//
//  Created by USER on 01/05/25.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    private var interactionBlockerView: UIView?
    private var blockerHeightConstraint: NSLayoutConstraint?
    private var locationContentView: LocationContentView?
    private var locationSheetHeightConstraint: NSLayoutConstraint?

    let newLocationView = LocationContentView()


    var customNavBarView: CustomNavigationBar?
    var needToShowSalesScreen = true
    
    let locationManager = CLLocationManager()
    var userAnnotation: MKPointAnnotation?
    
    var hasSetInitialRegion = false
    
    var isExpend = false
    
    let collapsedHeight: CGFloat = 250
    let expandedHeight: CGFloat = 500
    
    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setUpBackground()
        
        self.view.addSubview(ContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                ContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ContentContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
                ContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                ContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                ContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                ContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        
        setUpNavigationBar()
        setupMapView()
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupLocationSheet()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Clean up when view is about to disappear
        locationManager.stopUpdatingLocation()
        mapView.delegate = self
        locationManager.delegate = self
        
    }
    
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "City name",
            rightImage: UIImage(named: "ic_search")
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }

            customNavBarView.rightButtonTapped = {
                // Right button action
            }
            
            self.view.addSubview(customNavBarView)
            customNavBarView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBarView.heightAnchor.constraint(equalToConstant: 44),
            ])
        }
    }
    
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10 // Update every 10 meters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupMapView() {
        mapView.delegate = self
        setupLocation()
        
        mapView.mapType = .mutedStandard
        mapView.overrideUserInterfaceStyle = .dark
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        
        mapView.isZoomEnabled = true      // Allow pinch to zoom
            mapView.isScrollEnabled = true    // Allow pan
            mapView.isPitchEnabled = true     // Optional: allow map tilting
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
        
        ContentContainer.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: ContentContainer.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor)
        ])
    }
    
    @objc private func handleMapTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        // Update pin location
        updatePinLocation(to: coordinate)
    }
    
//    private func updatePinLocation(to coordinate: CLLocationCoordinate2D) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            
//            // Remove existing annotations
//            self.mapView.removeAnnotations(self.mapView.annotations)
//            
//            // Create and add new annotation
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            self.mapView.addAnnotation(annotation)
//            
//            // Update the region to center on the new location
//            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
//            self.mapView.setRegion(region, animated: true)
//            
//            // Print the new coordinates
//            print("Pin moved to: \(coordinate.latitude), \(coordinate.longitude)")
//            
//            let location = ExperienceLocation(name:"", address: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
//            
//            LocationManager.shared.saveCurrentLocation(location)
//        }
//    }
    
    private func updatePinLocation(to coordinate: CLLocationCoordinate2D) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            // Remove existing annotations
            self.mapView.removeAnnotations(self.mapView.annotations)

            // Create and add new annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)

            // Update the region to center on the new location
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            self.mapView.setRegion(region, animated: true)

            // Reverse geocode to get address
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Reverse geocoding failed: \(error.localizedDescription)")
                    return
                }

                guard let placemark = placemarks?.first else {
                    print("No address found")
                    return
                }

                let name = placemark.name ?? ""
                let thoroughfare = placemark.thoroughfare ?? ""
                let subThoroughfare = placemark.subThoroughfare ?? ""
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let postalCode = placemark.postalCode ?? ""
                let country = placemark.country ?? ""

                let fullAddress = "\(subThoroughfare) \(thoroughfare), \(locality), \(administrativeArea), \(postalCode), \(country)"
                print("Address: \(fullAddress)")
                
                let locati = ExperienceLocation(name: name, address: fullAddress, latitude: coordinate.latitude, longitude: coordinate.longitude)
              //
                          LocationManager.shared.saveCurrentLocation(locati)
               // self.setupLocationSheet()
                self.newLocationView.locationCard.setupdata(name: name, address: fullAddress)
            }

            // Print the new coordinates
            print("Pin moved to: \(coordinate.latitude), \(coordinate.longitude)")
            
          
            
         
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        let coordinate = currentLocation.coordinate
        
        print("Current Location: \(coordinate.latitude), \(coordinate.longitude)")
        
        // Only update region if it's the first location
//        if !hasSetInitialRegion {
//            hasSetInitialRegion = true
            updatePinLocation(to: coordinate)
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        
        let identifier = "CustomPin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = false
            if let originalImage = UIImage(named: "ic_map-pin") {
                let scale: CGFloat = 2 // Adjust scale as needed
                let newSize = CGSize(width: originalImage.size.width * scale,
                                     height: originalImage.size.height * scale)
                
                UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
                originalImage.draw(in: CGRect(origin: .zero, size: newSize))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                annotationView?.image = resizedImage
                annotationView?.centerOffset = CGPoint(x: 0, y: -newSize.height / 2)
            }
            //    annotationView?.centerOffset = CGPoint(x: 0, y: -annotationView!.image!.size.height / 2)
            annotationView?.isDraggable = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            if let annotation = view.annotation {
                print("Pin dropped at: \(annotation.coordinate.latitude), \(annotation.coordinate.longitude)")
                // You can update your location data here when the pin is dropped
            }
        }
    }
}

// MARK: - Add Trigger Button and Action for Standard Sheet
extension MapViewController : UISheetPresentationControllerDelegate {
    

    private func setupLocationSheet() {
        // Remove old location sheet if it exists
     //   locationContentView?.removeFromSuperview()

        // Create new instance
      //  let newLocationView = LocationContentView()
        newLocationView.translatesAutoresizingMaskIntoConstraints = false
        self.locationContentView = newLocationView

        mapView.addSubview(newLocationView)

        // Create and store height constraint
        let heightConstraint = newLocationView.heightAnchor.constraint(equalToConstant: isExpend ? self.expandedHeight : self.collapsedHeight)
        heightConstraint.isActive = true // ✅ This ensures the constraint is active
        self.locationSheetHeightConstraint = heightConstraint
        newLocationView.isExpanded = isExpend

        NSLayoutConstraint.activate([
            newLocationView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            newLocationView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor),
            newLocationView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            heightConstraint
        ])

        newLocationView.updownButtonAction = { [weak self] isExpanded in
            guard let self = self else { return }
            let newHeight = isExpanded ? self.expandedHeight : self.collapsedHeight
            isExpend = isExpanded
            self.locationSheetHeightConstraint?.constant = newHeight
           // self.blockerHeightConstraint?.constant = newHeight

            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }


     // MARK: - Setup Blocker
//     private func setupInteractionBlocker() {
//         let blockerView = UIView()
//         blockerView.translatesAutoresizingMaskIntoConstraints = false
//         blockerView.backgroundColor = .clear
//         view.addSubview(blockerView)
//
//         interactionBlockerView = blockerView
//
//         blockerHeightConstraint = blockerView.heightAnchor.constraint(equalToConstant: collapsedHeight)
//
//         NSLayoutConstraint.activate([
//             blockerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//             blockerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//             blockerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//             blockerHeightConstraint!
//         ])
//     }
 }



import UIKit

class LocationContentView: UIView {

    let collapsedHeight: CGFloat = 250
    let expandedHeight: CGFloat = 500
    var isExpanded = false {
        didSet {
            animateSheet()
        }
    }

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private var containerViewTopConstraint: NSLayoutConstraint!

    let notesData = [
        ("In front of a mirror", "Protection used", "Wed, 12 Feb 2025", "Los Angeles, CA", 5.0, 2, ["Oral", "Anal", "Bottoming","Oral", "Anal", "Bottoming", "+2"]),
        ("Another entry", "No protection", "Thu, 13 Feb 2025", "San Francisco, CA", 4.0, 1, ["Kissing", "+1"]),
        ("Third time", "Protection used", "Fri, 14 Feb 2025", "New York, NY", 4.5, 3, ["Oral", "Top", "+3"])
    ]

    var updownButtonAction: ((Bool) -> Void)?

    lazy var myLocationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My location"
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.white
        return label
    }()

    lazy var upDownButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.black
        button.setImage(UIImage(named: "upArrowIcon"), for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(upDownButtonTapped), for: .touchUpInside)
        return button
    }()

    lazy var notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(LocationContainTableViewCell.self, forCellReuseIdentifier: LocationContainTableViewCell.identifier)
        return tableView
    }()

    let locationCard = LocationDetailCardView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerViewTopConstraint = containerView.topAnchor.constraint(equalTo: bottomAnchor, constant: -collapsedHeight)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: DeviceSize.isiPadDevice ? 30 : 0),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: DeviceSize.isiPadDevice ? -30 : 0),
            containerViewTopConstraint,
            containerView.heightAnchor.constraint(equalToConstant: expandedHeight)
        ])

        containerView.addSubview(upDownButton)
        containerView.addSubview(locationCard)

        NSLayoutConstraint.activate([
            upDownButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            upDownButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            upDownButton.widthAnchor.constraint(equalToConstant: 44),
            upDownButton.heightAnchor.constraint(equalToConstant: 44),

            locationCard.topAnchor.constraint(equalTo: upDownButton.bottomAnchor, constant: 8),
            locationCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            locationCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
    }

    private func animateSheet() {
        containerViewTopConstraint.constant = isExpanded ? -expandedHeight : -collapsedHeight

        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
            self.layoutIfNeeded()
        }

        upDownButton.setImage(
            UIImage(named: isExpanded ? "downArrowIcon" : "upArrowIcon"),
            for: .normal
        )

        containerView.subviews.forEach { $0.removeFromSuperview() }

        containerView.addSubview(upDownButton)
        NSLayoutConstraint.activate([
            upDownButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            upDownButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            upDownButton.widthAnchor.constraint(equalToConstant: 44),
            upDownButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        if isExpanded {
            containerView.addSubview(myLocationLabel)
            containerView.addSubview(notesTableView)

            NSLayoutConstraint.activate([
                myLocationLabel.centerYAnchor.constraint(equalTo: upDownButton.centerYAnchor),
                myLocationLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),

                notesTableView.topAnchor.constraint(equalTo: upDownButton.bottomAnchor, constant: 8),
                notesTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                notesTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
                notesTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ])
        } else {
            containerView.addSubview(locationCard)
            NSLayoutConstraint.activate([
                locationCard.topAnchor.constraint(equalTo: upDownButton.bottomAnchor, constant: 8),
                locationCard.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
                locationCard.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
                locationCard.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -20)
            ])
        }

        updownButtonAction?(isExpanded)
    }

    @objc private func upDownButtonTapped() {
        isExpanded.toggle()
    }
}

extension LocationContentView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LocationContainTableViewCell.identifier,
            for: indexPath
        ) as? LocationContainTableViewCell else {
            return UITableViewCell()
        }

        let note = notesData[indexPath.row]
        cell.configure(
            title: note.0, subtitle: note.1, date: note.2,
            location: note.3, rating: note.4, orgasms: note.5,
            tags: note.6, isHome: true
        )

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
