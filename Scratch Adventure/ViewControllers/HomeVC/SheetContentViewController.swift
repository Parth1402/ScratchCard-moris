import UIKit

class SheetContentViewController: UIViewController {
    
    var sheetImageView: UIImageView!
    var selectedIndex = 0

    lazy var topSegmentedControl: UISegmentedControl = {
         let control = UISegmentedControl(items: ["Notes", "Leaderboards"])
         control.translatesAutoresizingMaskIntoConstraints = false
         control.selectedSegmentIndex = 0
         control.backgroundColor = .clear
         control.selectedSegmentTintColor = UIColor.purple.withAlphaComponent(0.5)
        
        // Set default (unselected) font style
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.mySystemFont(ofSize: 14)
        ], for: .normal)

        // Set selected font style
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.myBoldSystemFont(ofSize: 14)
        ], for: .selected)
        
         control.setTitleTextAttributes([.foregroundColor: UIColor.lightGray], for: .normal)
         control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
         control.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
         control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
         control.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
         return control
     }()

    lazy var sheetContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    private let dotIndicator: UIView = {
          let view = UIView()
          view.backgroundColor = .white
          view.layer.cornerRadius = 3
          view.frame = CGRect(x: 0, y: 0, width: 6, height: 6)
          return view
      }()
    var notesVC: NotesViewController!
    var leaderboardsVC: LeaderboardsViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Use a dark background to match the desired sheet appearance
     //   view.backgroundColor = UIColor(red: 0.1, green: 0.05, blue: 0.15, alpha: 1.0) // Dark purple/black
        

        setupChildViewControllers()
        setupUI()
        displayCurrentTab(0) // Show initial tab
    }

    private func setupChildViewControllers() {
        notesVC = NotesViewController()
        leaderboardsVC = LeaderboardsViewController()

        // Add them as children
        addChild(notesVC)
        addChild(leaderboardsVC)
        notesVC.didMove(toParent: self)
        leaderboardsVC.didMove(toParent: self)
    }

    private func setupUI() {
       
        view.addSubview(sheetContentContainer)
        
        sheetImageView = UIImageView()
          sheetImageView.translatesAutoresizingMaskIntoConstraints = false
          sheetImageView.image = UIImage(named: "TabBg") // replace with your asset name
          sheetImageView.contentMode = .scaleAspectFill
          sheetImageView.clipsToBounds = true
        sheetContentContainer.addSubview(sheetImageView)
        sheetContentContainer.addSubview(topSegmentedControl)
        sheetContentContainer.addSubview(dotIndicator)

        NSLayoutConstraint.activate([
            // Segmented Control Constraints
            topSegmentedControl.topAnchor.constraint(equalTo: sheetContentContainer.topAnchor, constant: 20),
            topSegmentedControl.leadingAnchor.constraint(equalTo: sheetContentContainer.leadingAnchor, constant: 20),
            topSegmentedControl.trailingAnchor.constraint(equalTo: sheetContentContainer.trailingAnchor, constant: -20),
            topSegmentedControl.heightAnchor.constraint(equalToConstant: 32),

            // Content Container Constraints
            sheetContentContainer.topAnchor.constraint(equalTo: view.topAnchor),
            sheetContentContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sheetContentContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sheetContentContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
          
                 sheetImageView.topAnchor.constraint(equalTo: sheetContentContainer.topAnchor),
                 sheetImageView.leadingAnchor.constraint(equalTo: sheetContentContainer.leadingAnchor),
                 sheetImageView.trailingAnchor.constraint(equalTo: sheetContentContainer.trailingAnchor),
            sheetImageView.bottomAnchor.constraint(equalTo: sheetContentContainer.bottomAnchor),
            
        ])
    }

    private func updateDotPosition(animated: Bool) {
            selectedIndex = topSegmentedControl.selectedSegmentIndex
            let segmentWidth = topSegmentedControl.bounds.width / CGFloat(topSegmentedControl.numberOfSegments)
            let segmentX = topSegmentedControl.frame.origin.x + (segmentWidth * CGFloat(selectedIndex))
            let centerX = segmentX + segmentWidth / 2
            let dotY = topSegmentedControl.frame.maxY + 1 // You can adjust this

            let newFrame = CGRect(x: centerX - 3, y: dotY, width: 6, height: 6)

            if animated {
                UIView.animate(withDuration: 0.25) {
                    self.dotIndicator.frame = newFrame
                }
            } else {
                self.dotIndicator.frame = newFrame
            }
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            updateDotPosition(animated: true)
        }

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
       displayCurrentTab(sender.selectedSegmentIndex)
        updateDotPosition(animated: true)
    }

    private func displayCurrentTab(_ tabIndex: Int) {
        let vcToShow = (tabIndex == 0) ? notesVC : leaderboardsVC
        let vcToHide = (tabIndex == 0) ? leaderboardsVC : notesVC

        // Remove the previous view controller's view
        vcToHide?.view.removeFromSuperview()

        // Add the new view controller's view
        guard let vcToShow = vcToShow else { return }
        vcToShow.view.translatesAutoresizingMaskIntoConstraints = false
        sheetContentContainer.addSubview(vcToShow.view)

        NSLayoutConstraint.activate([
            vcToShow.view.topAnchor.constraint(equalTo: topSegmentedControl.bottomAnchor,constant: 5),
            vcToShow.view.leadingAnchor.constraint(equalTo: sheetContentContainer.leadingAnchor),
            vcToShow.view.trailingAnchor.constraint(equalTo: sheetContentContainer.trailingAnchor),
            vcToShow.view.bottomAnchor.constraint(equalTo: sheetContentContainer.bottomAnchor),
        ])
    }
} 
