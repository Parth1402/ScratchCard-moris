//
//  AddDiaryNoteViewController.swift
//  Scratch Adventure
//
//  Created by USER on 25/04/25.
//

import UIKit
import Photos
import CoreLocation
import PhotosUI



class AddDiaryNoteViewController: UIViewController, HorizontalCalendarViewDelegate {
    
    var customNavBarView: CustomNavigationBar?
    var needToShowSalesScreen = true

    var experienceLocation: ExperienceLocation?
    var Selectedimages: [UIImage] = []
    
    var PositionData = [AddPosition]()
    
    var activitiesArray = [String]()
    
    let sexToyArray = [
        "Gag","Butt plug", "Vibrator", "Cock ring", "Sex swing", "Anal beads", "Teledildonics","Dildo","Prostate massager"
    ]
    
    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    lazy var notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(HorizontalCalenderTableCell.self, forCellReuseIdentifier: "HorizontalCalenderTableCell")
        tableView.register(AddDiaryinitiatorTableCell.self, forCellReuseIdentifier: "AddDiaryinitiatorTableCell")
        tableView.register(AddDiaryContraceptionTableCell.self, forCellReuseIdentifier: "AddDiaryContraceptionTableCell")
        tableView.register(PositionTableViewCell.self, forCellReuseIdentifier: "PositionTableViewCell")
        tableView.register(ActivityTableViewCell.self, forCellReuseIdentifier: "ActivityTableViewCell")
        tableView.register(ExperienceNoteTableViewCell.self, forCellReuseIdentifier: "ExperienceNoteTableViewCell")
        
        return tableView
    }()
    
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PositionManager.shared.saveFilteredPositions([])
        self.view.setUpBackground()
        
        self.view.addSubview(ContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                ContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ContentContainer.widthAnchor.constraint(equalToConstant: 460),
                ContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }else{
            NSLayoutConstraint.activate([
                ContentContainer.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                ContentContainer.topAnchor.constraint(equalTo: self.view.topAnchor),
                ContentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                ContentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        }
        
        setUpNavigationBar()
        
        setupDiaryView()
        LocationManager.shared.saveCurrentLocation(experienceLocation ?? ExperienceLocation())
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reload here if viewWillAppear doesn't work as expected
        experienceLocation = LocationManager.shared.loadCurrentLocation()
        
        
        PositionData = PositionManager.shared.loadFilteredPositions()
        activitiesArray = ActivityManager.shared.loadSelectedActivities()
        
        
            self.notesTableView.reloadData()
        notesTableView.beginUpdates()
        notesTableView.endUpdates()
    
    }

    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: "Add diary note"
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
    
    
    private func setupDiaryView() {
        
        ContentContainer.addSubview(notesTableView)
        notesTableView.rowHeight = UITableView.automaticDimension
        notesTableView.estimatedRowHeight = 100 // or any reasonable default

        NSLayoutConstraint.activate([
            notesTableView.topAnchor.constraint(equalTo: customNavBarView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 8),
            notesTableView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor),
            notesTableView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor),
            notesTableView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor)
        ])
    }
    
    @objc private func addNoteTapped() {
        print("Add Diary Note tapped")
    }
    
    func didSelectDate(_ date: Date) {
        self.selectedDate = date
        // customNavBarView?.titleLabel.text = formatDateForNavBar(date)
        
        print("Selected Date: \(date)")
    }
    
    private func formatDateForNavBar(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: date)
    }
    
    func checkPhotoLibraryPermissionAndOpenPicker() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized, .limited:
            // ✅ Access already granted
            openImagePicker()
            
        case .notDetermined:
            // 🕑 Request permission
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.openImagePicker()
                    } else {
                        self.showPermissionAlert()
                    }
                }
            }
            
        case .denied, .restricted:
            // 🚫 Permission denied
            showPermissionAlert()
            
        @unknown default:
            break
        }
    }
    
    func openImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0 // 0 = unlimited selection
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func showPermissionAlert() {
        let alert = UIAlertController(
            title: "Photo Access Needed",
            message: "Please allow photo access from Settings to select pictures.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
    }
    
    
}

extension AddDiaryNoteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalCalenderTableCell", for: indexPath) as! HorizontalCalenderTableCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            // cell.setupCell()
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryinitiatorTableCell", for: indexPath) as! AddDiaryinitiatorTableCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddDiaryContraceptionTableCell", for: indexPath) as! AddDiaryContraceptionTableCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.configure(withTitle: "Contraception type", Array: ["Not protected","Condom","Pill","IUD","Ring","Withdraw","Used","Sterilization","Other", "+"], isfilledNote: false)
            cell.isAddContraception = {
                // Navigate to location screen or open location picker
                print("Add Contraception.")
                
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PositionTableViewCell", for: indexPath) as! PositionTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.Positiondata = PositionData
            
            cell.configure(withTitle: "Positions", Array: [], isfilledNote: false)
            cell.isAddPositionClick = {
                // Navigate to location screen or open location picker
                print("Add Positions.")
                
                let pickerVC = AddPositionViewController()
                    pickerVC.modalPresentationStyle = .fullScreen
                pickerVC.selectedPositions = self.PositionData
                    self.present(pickerVC, animated: true)
                
            }
            
            cell.iswhereClick = {
                
                let pickerVC = WhereLocationListViewController()
                    pickerVC.modalPresentationStyle = .fullScreen
                    self.present(pickerVC, animated: true)
                
            }
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.configure(withTitle: "Activities", Array: activitiesArray, isNotefilled: false, index: 0)
            
            cell.isAddActivity = {
                // Navigate to location screen or open location picker
                print("Add Activities.")
                let pickerVC = AddActivityViewController()
                    pickerVC.modalPresentationStyle = .fullScreen
                    self.present(pickerVC, animated: true)
            }
            
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell", for: indexPath) as! ActivityTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.configure(withTitle: "Sex toy", Array: sexToyArray, isNotefilled: false, index: 1)
            
            cell.isAddActivity = {
                // Navigate to location screen or open location picker
                print("Add Sex toy.")
                
            }
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ExperienceNoteTableViewCell", for: indexPath) as! ExperienceNoteTableViewCell
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            cell.locationLatlong = experienceLocation
            cell.Selectedimages = Selectedimages
            cell.configure(with: experienceLocation ?? ExperienceLocation(name: experienceLocation?.name ?? "", address: experienceLocation?.address ?? "", latitude: experienceLocation?.latitude ?? 0.0, longitude: experienceLocation?.longitude ?? 0.0))

            cell.locationButtonAction = {
                // Navigate to location screen or open location picker
                print("Open location picker here.")
                let pickerVC = LocationPickerViewController()
                    pickerVC.delegate = self
                pickerVC.isedit = false
                    pickerVC.modalPresentationStyle = .fullScreen
                    self.present(pickerVC, animated: true)
                
            }
            
            cell.locationView.tapAction = {
                print("Adjust tapped!")
                
                let pickerVC = LocationPickerViewController()
                    pickerVC.delegate = self
                pickerVC.isedit = true
                pickerVC.experienceLocation = self.experienceLocation
                
                    pickerVC.modalPresentationStyle = .fullScreen
                    self.present(pickerVC, animated: true)
            }
            
            cell.addPhotosView.tapAction = {
                print("Add Photos tapped!")
                // Present UIImagePickerController here
                self.checkPhotoLibraryPermissionAndOpenPicker()
            }
            return cell
            
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AddDiaryNoteViewController :  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.editedImage] as? UIImage {
            // do something with selectedImage
            print("Selected edited image")
        } else if let selectedImage = info[.originalImage] as? UIImage {
            // do something with selectedImage
            print("Selected original image")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddDiaryNoteViewController: LocationPickerDelegate {
    func locationPicker(_ picker: UIViewController, didSelectLocation LocationData: ExperienceLocation) {
        print("Selected location: \(LocationData.address)")
        self.dismiss(animated: true)
        
        experienceLocation = LocationData
        
       // notesTableView.performBatchUpdates {
          //  notesTableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic)
      //  }


        notesTableView.reloadData()
        // Update your UI or model with the selected location
    }
}

extension AddDiaryNoteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        let itemProviders = results.map { $0.itemProvider }

        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self, let uiImage = image as? UIImage else { return }

                    DispatchQueue.main.async {
                        // Save or use your image here
                        self.Selectedimages.append(uiImage)
                        self.notesTableView.reloadData()
                      
                    }
                }
            }
        }
    }
}

