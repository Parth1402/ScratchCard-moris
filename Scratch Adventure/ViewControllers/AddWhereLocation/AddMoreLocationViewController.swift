//
//  AddMoreLocationViewController.swift
//  Scratch Adventure
//
//  Created by USER on 22/05/25.
//

import UIKit

class AddMoreLocationViewController: UIViewController {
    
    
    var customNavBarView: CustomNavigationBar?
    private var tableViewHeightConstraint: NSLayoutConstraint!
    
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
    
    var ScrollContainer: UIScrollView = {
        let Scrollview = UIScrollView()
        Scrollview.translatesAutoresizingMaskIntoConstraints = false
        Scrollview.isScrollEnabled = true
        return Scrollview
    }()
    
    var ViewContainer: UIView = {
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
    
    var LocationTextfield: UITextField = {
        let TextField = UITextField()
        TextField.translatesAutoresizingMaskIntoConstraints = false
        
        TextField.attributedPlaceholder = NSAttributedString(
            string: "Type a location name",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.5)
            ]
        )
        
        TextField.font = UIFont.mySystemFont(ofSize: 16)
        TextField.textColor = UIColor.white
        TextField.layer.borderWidth = 0.2
        TextField.layer.borderColor = UIColor.white.cgColor
        TextField.layer.cornerRadius = 20
        TextField.backgroundColor = UIColor(hex: "#9A03D0", alpha: 0.26)
        TextField.autocorrectionType = .no
        TextField.tintColor = UIColor.white
        
        // Add left padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        TextField.leftView = paddingView
        TextField.leftViewMode = .always
        
        return TextField
    }()
    
    
    let AddMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(named: "ic_Plus")
        button.setImage(image, for: .normal)
        
        button.setTitle(" Add more", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.mymediumSystemFont(ofSize: 17)
        
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .clear
        button.clipsToBounds = true
        
        return button
    }()
    
    var AddedLocationData: [LocationItem] = []
    private var selectedSubItemIndices: [IndexPath] = []
    
    deinit {
        WhereTableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpNavigationBar()
        setUpSearchBar()
        setupCollectionView()
        self.view.setUpBackground()
        self.view.addSubview(ScrollContainer)
        
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                ScrollContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ScrollContainer.widthAnchor.constraint(equalToConstant: 460),
                ScrollContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                ScrollContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            ])
        } else {
            NSLayoutConstraint.activate([
                ScrollContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                ScrollContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                ScrollContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ScrollContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            ])
        }
        
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewHeightConstraint.constant = WhereTableView.contentSize.height
    }
    
    
    func setUpNavigationBar() {
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "Add location",
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
        
        // Add contentView inside scrollView
              ViewContainer.translatesAutoresizingMaskIntoConstraints = false
              ScrollContainer.addSubview(ViewContainer)
        
        
        NSLayoutConstraint.activate([
            ViewContainer.leadingAnchor.constraint(equalTo: ScrollContainer.contentLayoutGuide.leadingAnchor),
            ViewContainer.trailingAnchor.constraint(equalTo: ScrollContainer.contentLayoutGuide.trailingAnchor),
            ViewContainer.topAnchor.constraint(equalTo: ScrollContainer.contentLayoutGuide.topAnchor),
            ViewContainer.bottomAnchor.constraint(equalTo: ScrollContainer.contentLayoutGuide.bottomAnchor),

                // Make contentView width equal to scrollView frame width (full width)
            ViewContainer.widthAnchor.constraint(equalTo: ScrollContainer.frameLayoutGuide.widthAnchor),
            ])
        
        ViewContainer.addSubview(WhereTableView)
        ViewContainer.addSubview(LocationTextfield)
        ViewContainer.addSubview(AddMoreButton)
        
        WhereTableView.delegate = self
        WhereTableView.dataSource = self
        WhereTableView.showsHorizontalScrollIndicator = false
        WhereTableView.showsVerticalScrollIndicator = false
        WhereTableView.separatorStyle = .none
        WhereTableView.backgroundColor = .clear
        
        tableViewHeightConstraint = WhereTableView.heightAnchor.constraint(equalToConstant: 1)
        tableViewHeightConstraint.isActive = true
        WhereTableView.isScrollEnabled = false
        
        WhereTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
        AddMoreButton.addTarget(self, action: #selector(AddMoreButtonTapped), for: .touchUpInside)
        
        WhereTableView.register(AddLocationItemCell.self, forCellReuseIdentifier: AddLocationItemCell.identifier)
        
        
        NSLayoutConstraint.activate([
            WhereTableView.topAnchor.constraint(equalTo: ViewContainer.topAnchor),
            WhereTableView.leadingAnchor.constraint(equalTo: ViewContainer.leadingAnchor, constant: 16),
            WhereTableView.trailingAnchor.constraint(equalTo: ViewContainer.trailingAnchor, constant: -16),
            
            LocationTextfield.topAnchor.constraint(equalTo: WhereTableView.bottomAnchor, constant: 16),
            LocationTextfield.leadingAnchor.constraint(equalTo: ViewContainer.leadingAnchor, constant: 16),
            LocationTextfield.trailingAnchor.constraint(equalTo: ViewContainer.trailingAnchor, constant: -16),
            LocationTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            AddMoreButton.topAnchor.constraint(equalTo: LocationTextfield.bottomAnchor, constant: 20),
            AddMoreButton.leadingAnchor.constraint(equalTo: ViewContainer.leadingAnchor, constant: 16),
            AddMoreButton.widthAnchor.constraint(equalToConstant: 130),
            AddMoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            // This bottom constraint tells scroll view how far content goes
            AddMoreButton.bottomAnchor.constraint(equalTo: ViewContainer.bottomAnchor, constant: -20)
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
    
    @objc func AddMoreButtonTapped() {
        // Get selected items
        
        
        guard let activity = LocationTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !activity.isEmpty else {
            let alert = UIAlertController(title: "Empty Loction", message: "Please Type Location Name.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let location = LocationItem(name: activity, isSelected: false)
        AddedLocationData.append(location)
        WhereTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        WhereTableView.reloadData()
        LocationTextfield.text = ""
        scrollToBottomTapped()
        
    }
    
    @objc func scrollToBottomTapped() {
           let bottomOffset = CGPoint(x: 0, y: ScrollContainer.contentSize.height - ScrollContainer.bounds.size.height + ScrollContainer.contentInset.bottom)
           if bottomOffset.y > 0 {
               ScrollContainer.setContentOffset(bottomOffset, animated: true)
           }
       }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize", let tableView = object as? UITableView {
            let height = tableView.contentSize.height
            if tableViewHeightConstraint.constant != height {
                tableViewHeightConstraint.constant = height
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension AddMoreLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddedLocationData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddLocationItemCell.identifier, for: indexPath) as? AddLocationItemCell else {
            return UITableViewCell()
        }
        
        let item = AddedLocationData[indexPath.row]
        cell.configure(with: item)
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let index = selectedSubItemIndices.firstIndex(of: indexPath) {
            selectedSubItemIndices.remove(at: index)
        } else {
            selectedSubItemIndices.append(indexPath)
        }
        
        
        AddedLocationData[indexPath.row].isSelected.toggle()
        if let cell = tableView.cellForRow(at: indexPath) as? AddLocationItemCell {
            let item = AddedLocationData[indexPath.row]
            
            cell.configure(with: item)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


extension AddMoreLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        if searchText.isEmpty {
        //            filteredLocation = Locationsection
        //        } else {
        //            filteredLocation = Locationsection.compactMap { section in
        //                // Filter items within the section
        //                let filteredItems = section.items.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        //                // Return a new section only if there are matching items
        //                if !filteredItems.isEmpty {
        //                    return LocationSection(title: section.title, subtitle: section.subtitle, Counttitle: section.Counttitle, items: filteredItems)
        //                } else {
        //                    return nil
        //                }
        //            }
        //        }
        //        WhereTableView.reloadData()
    }
    
}
