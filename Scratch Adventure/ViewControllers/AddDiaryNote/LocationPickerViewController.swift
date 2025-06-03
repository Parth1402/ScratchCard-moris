//
//  LocationPickerDelegate.swift
//  Scratch Adventure
//
//  Created by USER on 29/04/25.
//


import UIKit
import CoreLocation

protocol LocationPickerDelegate: AnyObject {
    func locationPicker(_ picker: UIViewController, didSelectLocation LocationData: ExperienceLocation)
}

//struct ExperienceLocation: Codable, Equatable {
//    let name: String
//    let address: String
//    let latitude: Double
//    let longitude: Double
//}

struct ExperienceLocation: Codable, Equatable {
    var name: String
    var latitude: Double
    var longitude: Double
    let address: String

    // Provide a default initializer if needed
    init(name: String = "", address: String = "", latitude: Double = 0.0, longitude: Double = 0.0) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}


class LocationPickerViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationPickerDelegate?
    private var allLocations: [ExperienceLocation] = []
    private var filteredLocations: [ExperienceLocation] = []
    private var recent: [ExperienceLocation] = []
    
    var customNavBarView: CustomNavigationBar?
    var needToShowSalesScreen = true
    
    var experienceLocation: ExperienceLocation?
    
    var UsemyLocation = false
    
    var isedit = false
    
    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    private lazy var searchBar : UISearchBar = {
//        let search = UISearchBar()
//        search.placeholder = "Search"
//        search.delegate = self
//        search.barStyle = .black
//        search.returnKeyType = .search
//        search.searchTextField.backgroundColor = UIColor(white: 0.15, alpha: 1)
//        search.searchTextField.textColor = .red
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        
//        return search
//    }()
//    
//    
//    private lazy var locationTableView : UITableView = {
//        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.backgroundColor = .red
//        tableView.separatorStyle = .none
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        
//        return tableView
//    }()
    
    private let searchBar = UISearchBar()
    private let locationTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.view.setUpBackground()
        setupSearchBar()
        setupTableView()
        
        filteredLocations = allLocations
        locationManager.delegate = self
        
        // When loading:
        recent = LocationManager.shared.loadRecentLocations()
        view.backgroundColor = UIColor(hexString: "#0E1626")
        self.view.addSubview(ContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                ContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ContentContainer.widthAnchor.constraint(equalToConstant: 460),
                ContentContainer.topAnchor.constraint(equalTo: customNavBarView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 8),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }else{
            NSLayoutConstraint.activate([
                ContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                ContentContainer.topAnchor.constraint(equalTo: customNavBarView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 50),
                ContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        
        setUpNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isedit {
            searchBar.searchTextField.text = "\(experienceLocation?.name ?? "") \(experienceLocation?.address ?? "")"
            geocodeAndAddToResults(query: searchBar.text ?? "")
            searchBar.searchTextField.becomeFirstResponder()
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    private func setupSearchBar() {
            searchBar.placeholder = "Search city or country"
            searchBar.delegate = self
            searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.searchTextField.textColor = UIColor.white
        searchBar.searchTextField.font = UIFont.mySystemFont(ofSize: 14)
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.searchTextField.clipsToBounds = true
        
        if let textFieldd = searchBar.searchTextField as? UITextField,
           let leftIconView = textFieldd.leftView as? UIImageView {
            leftIconView.tintColor = UIColor.white.withAlphaComponent(0.5)  // Change to your desired color
        }
        
        if let textField = searchBar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(hex: "#9A03D0", alpha: 0.2)
            textField.borderStyle = .none
            textField.layer.backgroundColor = UIColor(hex: "#9A03D0", alpha: 0.2).cgColor
            
            // Set placeholder text color
            textField.attributedPlaceholder = NSAttributedString(
                 string: "Search city or country",
                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
             )
        }

        // Optional: remove shadow
        searchBar.layer.shadowOpacity = 0
        searchBar.layer.borderWidth = 0
        
            ContentContainer.addSubview(searchBar)
            
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: ContentContainer.topAnchor),
                searchBar.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor,constant: 16),
                searchBar.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor,constant: -16),
                searchBar.heightAnchor.constraint(equalToConstant: 70)
            ])
        }
        
        private func setupTableView() {
            locationTableView.delegate = self
            locationTableView.dataSource = self
            locationTableView.translatesAutoresizingMaskIntoConstraints = false
            locationTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            locationTableView.rowHeight = UITableView.automaticDimension
            locationTableView.estimatedRowHeight = 60
            locationTableView.backgroundColor = .clear
            locationTableView.register(LocationTableViewCell.self, forCellReuseIdentifier: "LocationCell")
            locationTableView.register(RecentLocationTableViewCell.self, forCellReuseIdentifier: "RecentLocationTableViewCell")
            
            ContentContainer.addSubview(locationTableView)
            
            NSLayoutConstraint.activate([
                locationTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
                locationTableView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor),
                locationTableView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor),
                locationTableView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor)
            ])
        }
    
    
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "Add Location"
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.dismiss(animated: false, completion: nil)
            }
            customNavBarView.rightButtonTapped = {
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
    
}


extension LocationPickerViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { 2 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? filteredLocations.count + 2 : recent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                cell.textLabel?.textColor = UIColor(named: "Violet")
                cell.selectionStyle = .none
                cell.textLabel?.text = "Use my location"
                cell.textLabel?.font = UIFont.mymediumSystemFont(ofSize: 16)
                cell.imageView?.image = UIImage(named: "ic_Crosshair")
                return cell
            } else if indexPath.row == 1 {
                let cell = UITableViewCell()
                cell.backgroundColor = .clear
                if isedit {
                    cell.textLabel?.textColor = UIColor(hexString: "#EA333E")
                    cell.textLabel?.text = "Remove location"
                    cell.imageView?.image = UIImage(named: "ic_remove")
                } else {
                    cell.textLabel?.textColor = UIColor(named: "Violet")
                    cell.textLabel?.text = "Choose on map"
                    cell.imageView?.image = UIImage(named: "ic_Map")
                }
                cell.selectionStyle = .none
                cell.textLabel?.font = UIFont.mymediumSystemFont(ofSize: 16)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath) as! LocationTableViewCell
                let item = filteredLocations[indexPath.row - 2]
                cell.backgroundColor = .clear
                cell.nameLabel.text = item.name
                cell.addressLabel.text = item.address
                cell.configure(nameLabe: item.name, addressLabe: item.address)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentLocationTableViewCell", for: indexPath) as! RecentLocationTableViewCell
            let item = recent[indexPath.row]
            cell.backgroundColor = .clear
            cell.nameLabel.text = item.name
            cell.configure(nameLabe: item.name, addressLabe: item.address)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Recent" : nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if section == 1, let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.textColor = .white
            header.textLabel?.font = UIFont.mymediumSystemFont(ofSize: 16)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 40 : 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                UsemyLocation = true
                requestLocation()
            } else if indexPath.row == 1 {
                if isedit {
                    
                    isedit = false
                    searchBar.searchTextField.text = ""
                    geocodeAndAddToResults(query: searchBar.text ?? "")
                    
                } else {
                    // Handle choose on map
                    // TODO: Implement map selection
                    
                    let pickerVC = MapViewController()
                        pickerVC.modalPresentationStyle = .overFullScreen
                        self.present(pickerVC, animated: false)
                    
                }
            } else {
                let selected = filteredLocations[indexPath.row - 2]
                if !recent.contains(selected) {
                    recent.insert(selected, at: 0)
                    if recent.count > 5 { recent = Array(recent.prefix(5)) }
                    LocationManager.shared.saveRecentLocations(recent)
                }
              //;  delegate?.locationPicker(self, didSelectLocation: selected)
                LocationManager.shared.saveCurrentLocation(selected)
                dismiss(animated: true)
            }
        } else {
            let selected = recent[indexPath.row]
            LocationManager.shared.saveCurrentLocation(selected)
          //  delegate?.locationPicker(self, didSelectLocation: selected)
            dismiss(animated: true)
        }
    }
}

extension LocationPickerViewController : CLLocationManagerDelegate {
    private func requestLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Disabled", message: "Please enable location services in Settings.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            var address = "Lat: \(latitude), Lon: \(longitude)"
            var name = "Current Location"
            
            if let placemark = placemarks?.first {
                name = placemark.name ?? "Current Location"
                address = [
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.country
                ].compactMap { $0 }.joined(separator: ", ")
            }
            
            if self.UsemyLocation {
                let locationModel = ExperienceLocation(
                    name: name,
                    address: address,
                    latitude: latitude,
                    longitude: longitude
                )
                
                LocationManager.shared.saveCurrentLocation(locationModel)
               
                self.UsemyLocation = false
                dismiss(animated: true)
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: "Failed to get location.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
}

extension LocationPickerViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredLocations = allLocations
            locationTableView.reloadData()
            return
        }
        geocodeAndAddToResults(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        geocodeAndAddToResults(query: query)
        searchBar.resignFirstResponder()
    }
    
    private func geocodeAndAddToResults(query: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(query) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let placemarkArray = placemarks {
                self.filteredLocations.removeAll()
                for placemark in placemarkArray {
                    let name = placemark.name ?? query
                    let address = [
                        placemark.locality,
                        placemark.administrativeArea,
                        placemark.country
                    ].compactMap { $0 }.joined(separator: ", ")
                    
                    if let coordinate = placemark.location?.coordinate {
                        let item = ExperienceLocation(
                            name: name,
                            address: address,
                            latitude: coordinate.latitude,
                            longitude: coordinate.longitude
                        )
                        self.filteredLocations.append(item)
                    }
                }
                self.locationTableView.reloadData()
            } else {
                self.filteredLocations.removeAll()
                self.locationTableView.reloadData()
            }
        }
    }
}

