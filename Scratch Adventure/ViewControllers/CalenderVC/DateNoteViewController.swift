//
//  DateNoteViewController.swift
//  Scratch Adventure
//
//  Created by USER on 24/04/25.
//

import UIKit

class DateNoteViewController: UIViewController, HorizontalCalendarViewDelegate {
    
    var customNavBarView: CustomNavigationBar?
    var needToShowSalesScreen = true
    
    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let notesData = [
        ("In front of a mirror", "Protection used", "Wed, 12 Feb 2025", "Los Angeles, CA", 5.0, 2, ["Oral", "Anal", "Bottoming","Oral", "Anal", "Bottoming", "+2"]),
        ("Another entry", "No protection", "Thu, 13 Feb 2025", "San Francisco, CA", 4.0, 1, ["Kissing", "+1"]),
        ("Third time", "Protection used", "Fri, 14 Feb 2025", "New York, NY", 4.5, 3, ["Oral", "Top", "+3"])
    ]
    
   private let diaryLabel : UILabel = {
        let label = UILabel()
        label.text = "Diary"
        label.textColor = .white
        label.font = UIFont.myBoldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()



    lazy var notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        return tableView
    }()
    
    var selectedDate = Date()
    
    private lazy var horizontalCalendarView: HorizontalCalendarView = {
        let calendarView = HorizontalCalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.delegate = self
        return calendarView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setUpBackground()
        
        self.view.addSubview(ContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                ContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ContentContainer.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60),
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
        
        setupCalendarView()
        
        setupDiaryView()
        setupaAddDiaryButton()
    }
    
    override func viewDidLayoutSubviews() {
        setupaAddDiaryButton()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "backIcon"),
            titleString: formatDateForNavBar(selectedDate)
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
    
    func setupCalendarView() {
        ContentContainer.addSubview(horizontalCalendarView)

        NSLayoutConstraint.activate([
            horizontalCalendarView.topAnchor.constraint(equalTo: customNavBarView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor, constant: 16),
            horizontalCalendarView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor,constant: 16),
            horizontalCalendarView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor,constant:  -16),
            horizontalCalendarView.heightAnchor.constraint(equalToConstant: 80),
        ])

        // Configure the calendar, centering it around the selected date (initially today)
        horizontalCalendarView.configure(centerDate: selectedDate)
    }
    
    func setupaAddDiaryButton() {
        
        // Title & Image
        addNoteButton.setTitle(" Add Diary Note", for: .normal)
        addNoteButton.setTitleColor(.white, for: .normal)
        addNoteButton.setImage(UIImage(systemName: "plus"), for: .normal) // SF Symbol
        addNoteButton.tintColor = .white

        // Font
        addNoteButton.titleLabel?.font = UIFont.mymediumSystemFont(ofSize: 16)

        // Content Padding
        addNoteButton.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
        addNoteButton.layer.cornerRadius = 16
        addNoteButton.clipsToBounds = true

        // Gradient Background
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor(hexString: "AF0E78")?.withAlphaComponent(0.4).cgColor,  // Pinkish with 40% opacity
            UIColor(hexString: "9A03D0")?.withAlphaComponent(0.4).cgColor   // Purple with 40% opacity
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.cornerRadius = 16

        DispatchQueue.main.async {
            gradientLayer.frame = self.addNoteButton.bounds
            self.addNoteButton.layer.insertSublayer(gradientLayer, at: 0)
        }

        // Keep gradient updated on layout change
        addNoteButton.layoutIfNeeded()
        addNoteButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
    }
    
    private func setupDiaryView() {
        
        ContentContainer.addSubview(diaryLabel)
        ContentContainer.addSubview(addNoteButton)
        ContentContainer.addSubview(notesTableView)

        NSLayoutConstraint.activate([
            
            diaryLabel.topAnchor.constraint(equalTo: horizontalCalendarView.bottomAnchor, constant: DeviceSize.isiPadDevice ? 30 : 20),
            diaryLabel.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: DeviceSize.isiPadDevice ? 40 : 20),
            diaryLabel.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor),
            
            addNoteButton.topAnchor.constraint(equalTo: diaryLabel.bottomAnchor, constant: 20),
            addNoteButton.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: DeviceSize.isiPadDevice ? 40 : 20),
            addNoteButton.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: DeviceSize.isiPadDevice ? -40 : -20),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50),

            notesTableView.topAnchor.constraint(equalTo: addNoteButton.bottomAnchor, constant: DeviceSize.isiPadDevice ? 16 : 8),
            notesTableView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor,constant: DeviceSize.isiPadDevice ? -20 : 0),
            notesTableView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor,constant: DeviceSize.isiPadDevice ? 20 : 0),
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
}

extension DateNoteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier, for: indexPath) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        let note = notesData[indexPath.row]
        cell.configure(title: note.0, subtitle: note.1, date: note.2, location: note.3, rating: note.4, orgasms: note.5, tags: note.6, isHome: false)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
