//
//  AddWhereLocationViewController.swift
//  Scratch Adventure
//
//  Created by USER on 21/05/25.
//

import UIKit

struct LocationSection : Codable {
    let title: String
    let subtitle: String?
    let Counttitle: String?
    var items: [LocationItem]
}

struct LocationItem : Codable {
    let name: String
    var isSelected: Bool
}

class WhereLocationListViewController: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    
    var isSearching = false
    
    var Searchbar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        searchBar.searchBarStyle = .minimal
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        return searchBar
    }()
    
    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var SearchbarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cancelButton: UIButton = {
        let cancelButton = UIButton(type: .system)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.mySystemFont(ofSize: 16)
        cancelButton.setTitleColor(.white, for: .normal)
        return cancelButton
    }()
    
    private let WhereTableView: UITableView = {
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        return tableView
    }()
    
    var MarkLocationButton: UIButton = {
        let Button = UIButton()
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.setTitle("Mark Location", for: .normal)
        Button.setTitleColor(.white, for: .normal)
        Button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 22)
        Button.layer.cornerRadius = 15
        Button.backgroundColor = UIColor(named: "Violet") ?? .systemPurple
        Button.clipsToBounds = true
        return Button
    }()
    
    let AddLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "ic_Plus")
        button.setImage(image, for: .normal)
        
        button.setTitle(" Add Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.mymediumSystemFont(ofSize: 17)
        
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .clear
        button.clipsToBounds = true
        
        return button
    }()
    
    var Locationsection: [LocationSection] = [] // populate with your data
    var filteredLocation : [LocationSection] = []
    var selectedItems: [IndexPath] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpSearchBar()
        setupCollectionView()
        setupNextButton()
        self.view.setUpBackground()
        self.view.addSubview(ContentContainer)
        
    

        // Load recent items
        let locationItemdata = LocationManager.shared.RecentlyMarkedloadLocations()

        // If non-empty, prepend the "Recently marked locations" section
        if !locationItemdata.isEmpty {
            let recentSection = LocationSection(
                title: "Recently marked locations",
                subtitle: "We noticed that you recently marked these locations, You can add them to your note if they are related to it.",
                Counttitle: "",
                items: locationItemdata
            )
            
            Locationsection.append(recentSection) // Add first
        }

        // Then append other sections
        Locationsection.append(contentsOf: [
            LocationSection(
                title: "At home",
                subtitle: nil,
                Counttitle: "+ 3 Punkte",
                items: [
                    LocationItem(name: "On the floor", isSelected: false),
                    LocationItem(name: "In a bath tub", isSelected: false),
                    LocationItem(name: "On the floor", isSelected: false)
                ]
            ),
            LocationSection(
                title: "At Office",
                subtitle: nil,
                Counttitle: "+ 3 Punkte",
                items: [
                    LocationItem(name: "On the floor", isSelected: false),
                    LocationItem(name: "In a bath tub", isSelected: false),
                    LocationItem(name: "On the floor", isSelected: false)
                ]
            )
        ])

        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                ContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ContentContainer.widthAnchor.constraint(equalToConstant: 460),
                ContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                ContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                ContentContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                ContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        
        filteredLocation = Locationsection
        
        SearchbarContainer.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setUpSearchBar() {
        view.addSubview(SearchbarContainer)
        SearchbarContainer.addSubview(Searchbar)
        SearchbarContainer.addSubview(cancelButton)
        
        Searchbar.placeholder = "Search"
        Searchbar.delegate = self
        Searchbar.translatesAutoresizingMaskIntoConstraints = false
        Searchbar.backgroundImage = UIImage()
        Searchbar.searchTextField.textColor = UIColor.white
        Searchbar.searchTextField.font = UIFont.mySystemFont(ofSize: 14)
        Searchbar.searchTextField.layer.cornerRadius = 10
        Searchbar.searchTextField.clipsToBounds = true
        
        if let textFieldd = Searchbar.searchTextField as? UITextField,
           let leftIconView = textFieldd.leftView as? UIImageView {
            leftIconView.tintColor = UIColor.white.withAlphaComponent(0.5)  // Change to your desired color
        }
        
        if let textField = Searchbar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor(hex: "#9A03D0", alpha: 0.2)
            textField.borderStyle = .none
            
            
            textField.layer.backgroundColor = UIColor(hex: "#9A03D0", alpha: 0.2).cgColor
            
            // Gradient Background
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [
                UIColor(hexString: "AF0E78")?.withAlphaComponent(0.2).cgColor,  // Pinkish with 40% opacity
                UIColor(hexString: "9A03D0")?.withAlphaComponent(0.2).cgColor   // Purple with 40% opacity
            ]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.cornerRadius = 16
            gradientLayer.borderWidth = 0.2
            gradientLayer.borderColor = UIColor.white.cgColor
            
            DispatchQueue.main.async {
                gradientLayer.frame = textField.bounds
                textField.layer.insertSublayer(gradientLayer, at: 0)
            }
            
            
            // Set placeholder text color
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
            )
        }
        
        Searchbar.delegate = self
        cancelButton.addTarget(self, action: #selector(toggleSearch), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            SearchbarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            SearchbarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            SearchbarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            SearchbarContainer.heightAnchor.constraint(equalToConstant: 44),
            
            Searchbar.leadingAnchor.constraint(equalTo: SearchbarContainer.leadingAnchor, constant: 8),
            Searchbar.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -8),
            Searchbar.centerYAnchor.constraint(equalTo: SearchbarContainer.centerYAnchor),
            
            cancelButton.trailingAnchor.constraint(equalTo: SearchbarContainer.trailingAnchor, constant: -8),
            cancelButton.centerYAnchor.constraint(equalTo: SearchbarContainer.centerYAnchor),
            cancelButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "Where",
            rightImage: UIImage(named: "ic_search")
        )
        
        guard let customNavBarView = customNavBarView else { return }
        
        customNavBarView.leftButtonTapped = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        
        customNavBarView.rightButtonTapped = { [weak self] in
            self?.toggleSearch()
        }
        
        view.addSubview(customNavBarView)
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBarView.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func setupCollectionView() {
        ContentContainer.addSubview(AddLocationButton)
        ContentContainer.addSubview(WhereTableView)
        WhereTableView.delegate = self
        WhereTableView.dataSource = self
        WhereTableView.showsHorizontalScrollIndicator = false
        WhereTableView.showsVerticalScrollIndicator = false
        WhereTableView.separatorStyle = .none
        WhereTableView.backgroundColor = .clear
        
        WhereTableView.register(LocationItemCell.self, forCellReuseIdentifier: LocationItemCell.identifier)
        
        AddLocationButton.addTarget(self, action: #selector(AddLocationButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            
            AddLocationButton.topAnchor.constraint(equalTo: ContentContainer.topAnchor),
            AddLocationButton.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            AddLocationButton.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            AddLocationButton.heightAnchor.constraint(equalToConstant: 50),
            
            WhereTableView.topAnchor.constraint(equalTo: AddLocationButton.bottomAnchor,constant: 16),
            WhereTableView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            WhereTableView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            WhereTableView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: -88),
        ])
    }
    
    func setupNextButton() {
        ContentContainer.addSubview(MarkLocationButton)
        MarkLocationButton.addTarget(self, action: #selector(MarkLocationTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            MarkLocationButton.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: -30),
            MarkLocationButton.heightAnchor.constraint(equalToConstant: 50),
            MarkLocationButton.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            MarkLocationButton.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
        ])
    }
    
    @objc func toggleSearch() {
        isSearching.toggle()
        SearchbarContainer.isHidden = !isSearching
        customNavBarView?.isHidden = isSearching
        if !isSearching {
            Searchbar.text = ""
            Searchbar.resignFirstResponder()
        }
    }
    
    @objc func AddLocationButtonTapped() {
        // Get selected items
        let pickerVC = AddMoreLocationViewController()
        pickerVC.modalPresentationStyle = .fullScreen
        self.present(pickerVC, animated: true)
    }
    
    @objc func MarkLocationTapped() {
       //  Get selected items
        
        let checkCount = self.filteredLocation.flatMap { $0.items }.filter { $0.isSelected }.count
        
        var selectedItems = self.filteredLocation.flatMap { $0.items }.filter { $0.isSelected }
        
                if selectedItems.isEmpty {
                    // Optionally show alert
                    let alert = UIAlertController(title: "No Selection", message: "Please select at least one position.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    present(alert, animated: true)
                } else {
                    print("Selected positions: \(selectedItems)")
        
                  
                    selectedItems = selectedItems.map { item in
                        var newItem = item
                        newItem.isSelected = false
                        return newItem
                    }

                    LocationManager.shared.RecentlyMarkedsaveLocations(selectedItems)
        
                    self.dismiss(animated: true)
        
        
                }
    }
}

extension WhereLocationListViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationItemCell.identifier, for: indexPath) as? LocationItemCell else {
            return UITableViewCell()
        }
        
        let item = filteredLocation[indexPath.row]
        cell.configure(data: item)
        cell.selectionStyle = .none
        
        
        cell.isSelectLocationClick = { nameIndex , selectedIndices in
            
            self.selectedItems = selectedIndices
            
            self.filteredLocation[indexPath.row].items[nameIndex.row].isSelected.toggle()
            self.Locationsection[indexPath.row].items[nameIndex.row].isSelected.toggle()
            
            let checkCount = self.filteredLocation.flatMap { $0.items }.filter { $0.isSelected }.count

            
            if checkCount != 0 {
                self.MarkLocationButton.setTitle("Mark \(checkCount) Location", for: .normal)
                self.MarkLocationButton.isHidden = false
                
            }else {
              //  self.MarkLocationButton.isHidden = true
                self.MarkLocationButton.setTitle("Mark Location", for: .normal)
            }
          //  tableView.reloadData()
            
            tableView.performBatchUpdates({
                tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: indexPath.section)], with: .automatic)
            }, completion: nil)
            
            
            
            
            //        if let cell = tableView.cellForRow(at: indexPath) as? LocationItemSubCell {
            //            let item = locationArray[indexPath.row]
            //            let isSelected = selectedSubItemIndices.contains(indexPath.row)
            //
            //            cell.configure(with: item)
            //        }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


extension WhereLocationListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredLocation = Locationsection
        } else {
            filteredLocation = Locationsection.compactMap { section in
                // Filter items within the section
                let filteredItems = section.items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                // Return a new section only if there are matching items
                if !filteredItems.isEmpty {
                    return LocationSection(title: section.title, subtitle: section.subtitle, Counttitle: section.Counttitle, items: filteredItems)
                } else {
                    return nil
                }
            }
        }
        WhereTableView.reloadData()
    }
    
}
