//
//  HomeViewController.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-07.
//

import UIKit


protocol ShowReviewScreenProtocol {
    func needToShowReviewScreen()
}

class HomeViewController: UIViewController, UISheetPresentationControllerDelegate {
    
    var customNavBarView: CustomNavigationBar?
    var needToShowSalesScreen = true
    
    var currentDate = Date()

    
    var ValultButton: UIButton = {
        let vaultButton = UIButton()
        vaultButton.translatesAutoresizingMaskIntoConstraints = false
        vaultButton.setTitle("Private vault", for: .normal)
        vaultButton.setTitleColor(.white, for: .normal)
        vaultButton.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 16)
        vaultButton.layer.cornerRadius = 12
        vaultButton.clipsToBounds = true
        return vaultButton // ✅ Required
    }()
    
    var TrackerButton: UIButton = {
        let Button = UIButton()
        Button.translatesAutoresizingMaskIntoConstraints = false
        Button.setTitle("Start sex tracker", for: .normal)
        Button.setTitleColor(.white, for: .normal)
        Button.titleLabel?.font = UIFont.myBoldSystemFont(ofSize: 22)
        Button.layer.cornerRadius = 12
        Button.backgroundColor = UIColor(named: "Violet")
        Button.clipsToBounds = true
        return Button // ✅ Required
    }()
    
    let monthLabel : UILabel = {
        let label = UILabel()
        label.text = "June 2025"
        label.textColor = .white
        label.font = UIFont.myBoldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let leftArrow : UIButton = {
        let leftArrow = UIButton(type: .system)
        leftArrow.setImage(UIImage(named: "leftArrowIcon"), for: .normal)
        leftArrow.tintColor = .white
        leftArrow.translatesAutoresizingMaskIntoConstraints = false
        return leftArrow
    }()

    
    let rightArrow : UIButton = {
        let rightArrow = UIButton(type: .system)
        rightArrow.setImage(UIImage(named: "rightArrowIcon"), for: .normal)
        rightArrow.tintColor = .white
        rightArrow.translatesAutoresizingMaskIntoConstraints = false
        return rightArrow
    }()

    
    let calendarIcon: UIButton = {
        let calendarIcon = UIButton(type: .system)
        calendarIcon.setImage(UIImage(named: "homeCalender"), for: .normal)
        calendarIcon.tintColor = .white
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        return calendarIcon
    }()
    
    var CalendarStack: UIView = {
        let calendarStack = UIView()
        calendarStack.translatesAutoresizingMaskIntoConstraints = false
        return calendarStack
    }()
    

    
    // MARK: - Bottom Sheet Properties
    // var bottomSheetView: UIView!
    // var bottomSheetHeightConstraint: NSLayoutConstraint!
    // var topSegmentedControl: UISegmentedControl!
    // var sheetContentContainer: UIView!
    // var notesVC: NotesViewController!
    // var leaderboardsVC: LeaderboardsViewController!
    var cardsStack: UIStackView!
    
    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        ContentContainer.addSubview(ValultButton)
        ContentContainer.addSubview(TrackerButton)
       
        setUpNavigationBar()
        setupPrivateVaultButton()
        setupCalendarHeader()
        setupStatsCards()
        setupTrackerButton()
        updateMonthLabel()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        ContentContainer.addSubview(ValultButton)
        ContentContainer.addSubview(TrackerButton)
       
        setUpNavigationBar()
        setupPrivateVaultButton()
        setupCalendarHeader()
        setupStatsCards()
        setupTrackerButton()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showStandardSheetTapped()
    }
    
    private func setupPrivateVaultButton() {
        // Add button to the view
        ContentContainer.addSubview(ValultButton)
        ValultButton.translatesAutoresizingMaskIntoConstraints = false

        // Add top constraint depending on the nav bar
        if let customNavBarView = customNavBarView {
            ValultButton.topAnchor.constraint(equalTo: customNavBarView.bottomAnchor, constant: 10).isActive = true
        } else {
            ValultButton.topAnchor.constraint(equalTo: ContentContainer.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        }

        // Common constraints
        NSLayoutConstraint.activate([
            ValultButton.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 20),
            ValultButton.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -20),
            ValultButton.heightAnchor.constraint(equalToConstant: 60),
        ])

        // Configure background image
        ValultButton.setBackgroundImage(UIImage(named: "homescreenvaletButton"), for: .normal)

        // Set icon & title
        ValultButton.setImage(UIImage(named: "homeScreenValet"), for: .normal)
        ValultButton.addTarget(self, action: #selector(VaultButtonTapped), for: .touchUpInside)

        ValultButton.contentHorizontalAlignment = .left

        // Adjust spacing between image and title
        ValultButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        ValultButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0) // spacing between icon and title
        
        // Add right-side arrow image
           let arrowImageView = UIImageView(image: UIImage(named: "rightArrowIcon")) // replace with your arrow image name
           arrowImageView.translatesAutoresizingMaskIntoConstraints = false
           arrowImageView.contentMode = .scaleAspectFit
           ValultButton.addSubview(arrowImageView)

           NSLayoutConstraint.activate([
               arrowImageView.centerYAnchor.constraint(equalTo: ValultButton.centerYAnchor),
               arrowImageView.trailingAnchor.constraint(equalTo: ValultButton.trailingAnchor, constant: -16),
               arrowImageView.widthAnchor.constraint(equalToConstant: 24),
               arrowImageView.heightAnchor.constraint(equalToConstant: 24),
           ])
    }
    
    private func setupTrackerButton() {
        // Add button to the view
        ContentContainer.addSubview(TrackerButton)
        TrackerButton.translatesAutoresizingMaskIntoConstraints = false

        // Common constraints
        NSLayoutConstraint.activate([
            TrackerButton.topAnchor.constraint(equalTo: cardsStack.bottomAnchor, constant: 20),
            TrackerButton.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 20),
            TrackerButton.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -20),
            TrackerButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    
    private func setupCalendarHeader() {
        // Label
       
        leftArrow.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        calendarIcon.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)

        // Stack container
        CalendarStack.translatesAutoresizingMaskIntoConstraints = false
        ContentContainer.addSubview(CalendarStack)

        CalendarStack.addSubview(monthLabel)
        CalendarStack.addSubview(leftArrow)
        CalendarStack.addSubview(rightArrow)
        CalendarStack.addSubview(calendarIcon)

        // Constraints
        NSLayoutConstraint.activate([
            CalendarStack.topAnchor.constraint(equalTo: ValultButton.bottomAnchor, constant: 20),
            CalendarStack.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 20),
            CalendarStack.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -20),
            CalendarStack.heightAnchor.constraint(equalToConstant: 40),
            
            // Month Label
            monthLabel.leadingAnchor.constraint(equalTo: CalendarStack.leadingAnchor),
            monthLabel.centerYAnchor.constraint(equalTo: CalendarStack.centerYAnchor),

            // Left Arrow
            leftArrow.leadingAnchor.constraint(equalTo: monthLabel.trailingAnchor, constant: 8),
            leftArrow.centerYAnchor.constraint(equalTo: CalendarStack.centerYAnchor),
            leftArrow.widthAnchor.constraint(equalToConstant: 30),

            // Right Arrow
            rightArrow.leadingAnchor.constraint(equalTo: leftArrow.trailingAnchor, constant: 8),
            rightArrow.centerYAnchor.constraint(equalTo: CalendarStack.centerYAnchor),
            rightArrow.widthAnchor.constraint(equalToConstant: 30),

            // Calendar Icon on right end
            calendarIcon.trailingAnchor.constraint(equalTo: CalendarStack.trailingAnchor),
            calendarIcon.centerYAnchor.constraint(equalTo: CalendarStack.centerYAnchor),
            calendarIcon.widthAnchor.constraint(equalToConstant: 44),
            calendarIcon.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    func updateMonthLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy" // Example: June 2025
        monthLabel.text = formatter.string(from: currentDate)
    }

      private func setupStatsCards() {
          let sexCountCard = createStatCard(title: "Sex this month", value: "12")
          let orgasmCountCard = createStatCard(title: "Orgasm counter", value: "34 🔥")

          cardsStack = UIStackView(arrangedSubviews: [sexCountCard, orgasmCountCard])
          cardsStack.axis = .horizontal
          cardsStack.spacing = 16
          cardsStack.distribution = .fillEqually
          cardsStack.translatesAutoresizingMaskIntoConstraints = false

          ContentContainer.addSubview(cardsStack)

          NSLayoutConstraint.activate([
              cardsStack.topAnchor.constraint(equalTo: CalendarStack.bottomAnchor, constant: 20),
              cardsStack.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 20),
              cardsStack.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -20),
              cardsStack.heightAnchor.constraint(equalToConstant: 100)
          ])
      }
    
    private func createStatCard(title: String, value: String) -> UIView {
           let card = UIView()
        card.backgroundColor = UIColor.clear
        card.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        card.layer.borderWidth = 1
           card.layer.cornerRadius = 16

           let titleLabel = UILabel()
           titleLabel.text = title
        titleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
           titleLabel.font = UIFont.mymediumSystemFont(ofSize: 14)
           titleLabel.translatesAutoresizingMaskIntoConstraints = false

           let valueLabel = UILabel()
           valueLabel.text = value
           valueLabel.textColor = .white
           valueLabel.font = UIFont.myBoldSystemFont(ofSize: 25)
           valueLabel.translatesAutoresizingMaskIntoConstraints = false

           card.addSubview(titleLabel)
           card.addSubview(valueLabel)

           NSLayoutConstraint.activate([
               titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 16),
               titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),

               valueLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
               valueLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16)
           ])

           return card
       }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
    }
    
    
    func setUpNavigationBar() {
        
        customNavBarView = CustomNavigationBar(
            leftImage: UIImage(named: "homeScreenMenu"),
            titleString: "Sex tracker",
            rightImage: UIImage(named: "homeScreenAvatar"),Font: 22
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                
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

extension HomeViewController {
   

    private func createHeaderView1() -> UIView {
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let headlineLabel = UILabel()
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineLabel.text = "HomeViewController.headlineLabel.text"~
        headlineLabel.font = UIFont.boldSystemFont(ofSize: 24.pulseWithFont(withInt: 4))
        headlineLabel.textColor = appColor
        headlineLabel.setFontScaleWithWidth()
        
        let headlineDescriptionLabel = UILabel()
        headlineDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        headlineDescriptionLabel.text = "HomeViewController.headlineDescriptionLabel.text"~
        headlineDescriptionLabel.textColor = appColor
        headlineDescriptionLabel.font = UIFont.systemFont(ofSize: 15.pulse2Font())
        headlineDescriptionLabel.setFontScaleWithWidth()
        
        headerView.addSubview(headlineLabel)
        headerView.addSubview(headlineDescriptionLabel)
        
        NSLayoutConstraint.activate([
            headlineLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headlineLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headlineLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
            
            headlineDescriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headlineDescriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            headlineDescriptionLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 5)
        ])
        
        return headerView
        
    }
    
    
    private func createHeaderView2() -> UIView {
        
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        let categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "HomeViewController.categories.headlineLabel.text"~
        categoryLabel.textColor = appColor
        categoryLabel.font = UIFont.mymediumSystemFont(ofSize: 14.pulse2Font())
        
        headerView.addSubview(categoryLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            categoryLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
        
        return headerView
        
    }
    
}


extension HomeViewController {
    
    // Actions
    
    @objc func calendarButtonTapped() {
        print("Calendar button tapped")
        
        dismiss(animated: false) {
            let destinationViewController = CalenderViewController()
            destinationViewController.modalPresentationStyle = .fullScreen
            self.present(destinationViewController, animated: false, completion: nil)
        }
     
           
    }
    
    @objc func VaultButtonTapped() {
        dismiss(animated: false) {
            let destinationViewController = VaultPinSetupViewController()
            destinationViewController.modalPresentationStyle = .fullScreen
            self.present(destinationViewController, animated: false, completion: nil)
        }
        
     
           
    }

    @objc func previousButtonTapped() {
        let calendar = Calendar.current
        guard let newDate = calendar.date(byAdding: .month, value: -1, to: currentDate) else { return }

        // Get start of current month (e.g., April 1, 2025)
        let currentMonthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!

        // Only allow going back if the newDate is >= currentMonthStart
        if newDate >= currentMonthStart {
            currentDate = newDate
            updateMonthLabel()
        } else {
            print("Can't go earlier than current month")
        }
    }


    @objc func nextButtonTapped() {
        print("Next button tapped")
        // Show date picker, navigate to calendar screen, etc.
        guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) else { return }
           currentDate = newDate
           updateMonthLabel()
    }

    
    
}

// MARK: - Add Trigger Button and Action for Standard Sheet
extension HomeViewController {
    
    @objc func showStandardSheetTapped() {
        let sheetContentVC = SheetContentViewController()
        // Configure presentation style
        sheetContentVC.modalPresentationStyle = .pageSheet
        sheetContentVC.isModalInPresentation = true
        
        if let sheet = sheetContentVC.sheetPresentationController {
            // Define custom detents with specific identifiers
            let mediumDetentId = UISheetPresentationController.Detent.Identifier("mediumCustom")
            let mediumDetent = UISheetPresentationController.Detent.custom(identifier: mediumDetentId) { context in
                return context.maximumDetentValue * 0.47 // 45% height
            }
            
            let largeDetentId = UISheetPresentationController.Detent.Identifier("largeCustom")
            let largeDetent = UISheetPresentationController.Detent.custom(identifier: largeDetentId) { context in
                return context.maximumDetentValue * 0.95 // 88% height
            }
            
            // Configure sheet presentation
            sheet.detents = [mediumDetent, largeDetent]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.largestUndimmedDetentIdentifier = mediumDetentId
            sheet.delegate = self
            
      
            
            // Present the sheet
            present(sheetContentVC, animated: true) {
                // Ensure proper layout after presentation
                sheetContentVC.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UISheetPresentationControllerDelegate
    
    func sheetPresentationControllerDidChangeDetent(_ sheetPresentationController: UISheetPresentationController) {
        let isMedium = sheetPresentationController.selectedDetentIdentifier == UISheetPresentationController.Detent.Identifier("mediumCustom")
        
        // Update modal presentation state based on current detent
        if let presentingVC = sheetPresentationController.presentingViewController as? HomeViewController {
            presentingVC.isModalInPresentation = isMedium
        }
        
        // Force layout update
        sheetPresentationController.presentedViewController.view.layoutIfNeeded()
    }
}
