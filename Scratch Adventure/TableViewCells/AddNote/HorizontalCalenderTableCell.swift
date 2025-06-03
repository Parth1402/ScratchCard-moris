//
//  HorizontalCalenderTableCell.swift
//  Scratch Adventure
//
//  Created by USER on 25/04/25.
//

import UIKit

class HorizontalCalenderTableCell: UITableViewCell, HorizontalCalendarViewDelegate {
    
    private let tableView = UITableView()

    struct RatingItem {
        let title: String
        var type: RatingTableCell.RatingType // Make type mutable if ratings can change
    }

    var ratingData: [RatingItem] = []
    var selectedDate: Date = Date() // Store the currently selected date

    // Cell Identifiers
    let calendarCellIdentifier = "HorizontalCalenderTableCell"
    let ratingCellIdentifier = RatingTableCell.reuseIdentifier
   
    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var horizontalCalendarView: HorizontalCalendarView = {
        let calendarView = HorizontalCalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.delegate = self
        return calendarView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        // Configure cell appearance
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // Add and configure ContentContainer
        contentView.addSubview(ContentContainer)
        NSLayoutConstraint.activate([
            ContentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            ContentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ContentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ContentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Add and configure calendar view
        ContentContainer.addSubview(horizontalCalendarView)
        NSLayoutConstraint.activate([
            horizontalCalendarView.topAnchor.constraint(equalTo: ContentContainer.topAnchor, constant: 8),
            horizontalCalendarView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            horizontalCalendarView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            horizontalCalendarView.heightAnchor.constraint(equalToConstant: 80),
           // horizontalCalendarView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: -8)
        ])
        
        // Configure the calendar
        horizontalCalendarView.configure(centerDate: selectedDate)
        
        setupTableView()
        setupRatingData()
        
        let emojiNames = ["emoji_angry", "emoji_neutral", "emoji_happy", "emoji_excited", "emoji_devil"]
        let enjoymentEmojis = emojiNames.compactMap { UIImage(named: $0) }

        // Ensure all emojis were loaded (optional, but recommended)
        if enjoymentEmojis.count != emojiNames.count {
             print("Warning: Not all emoji images were loaded. Check asset names.")
             // Handle the error, e.g., use placeholder emojis or return
        }
        // --- ---

        // Initial data - this could be fetched or loaded based on the selectedDate later
        ratingData = [
            RatingItem(title: "Foreplay", type: .stars(value: 5)),
            RatingItem(title: "Sex", type: .stars(value: 2)),
            RatingItem(title: "Riskiness", type: .stars(value: 0)),
            RatingItem(title: "Privacy", type: .stars(value: 0)),
            RatingItem(title: "Enjoyment", type: .emojis(images: enjoymentEmojis)), // Use loaded images
            RatingItem(title: "Orgasms", type: .stepper(value: 1))
        ]

        tableView.reloadData() // Reload data after setup
    }
    
    // MARK: - Setup

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear // Make table view background clear

        // Register cell types
        tableView.register(RatingTableCell.self, forCellReuseIdentifier: ratingCellIdentifier)

        ContentContainer.addSubview(tableView)

        // Constraints for the table view
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: horizontalCalendarView.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 310),
            tableView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor, constant: -8)
        ])
    }

    private func setupRatingData() {
        // --- Load Emoji Images Safely ---
        // Replace these with your actual asset names!

    }
    
    func didSelectDate(_ date: Date) {
        self.selectedDate = date
        print("Cell selected date: \(date)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset any cell-specific state here if needed
    }
}

protocol RatingTableCellDelegate: AnyObject {
    func ratingDidChange(title: String, ratingType: RatingTableCell.RatingType, newValue: Any) // Example signature
}

extension HorizontalCalenderTableCell:  UITableViewDataSource, UITableViewDelegate, RatingTableCellDelegate {




    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 // Section 0: Calendar, Section 1: Ratings
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
            return ratingData.count // Rating section has one row per item
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
            // --- Rating Cell ---
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ratingCellIdentifier, for: indexPath) as? RatingTableCell else {
                fatalError("Could not dequeue RatingTableCell")
            }
            // Get data for the row
            let item = ratingData[indexPath.row]
            // Configure the cell
            cell.configure(title: item.title, ratingType: item.type)
        cell.selectionStyle = .none
         //   cell.delegate = self // Set the ViewController as the delegate
            cell.backgroundColor = .clear // Ensure cell background is clear
            cell.contentView.backgroundColor = .clear
            return cell
        }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if ratingData.count - 1 == indexPath.row {
          return 65
        }else {
            return 50  // Adjust height for rating cells as needed
        }
            
    }


    // MARK: - RatingTableCellDelegate

    func ratingDidChange(title: String, ratingType: RatingTableCell.RatingType, newValue: Any) {
        print("Rating changed in ViewController: \(title) - New Value: \(newValue)")

        // Find the index of the item that changed
        if let index = ratingData.firstIndex(where: { $0.title == title }) {
            // Update the data source based on the type
            switch ratingType {
            case .stars:
                if let newRating = newValue as? Int {
                    ratingData[index].type = .stars(value: newRating)
                }
            case .emojis:
                 // Assuming newValue is the index of the selected emoji
                 if let selectedIndex = newValue as? Int {
                     // You might store the selected index or update the 'type' differently
                     print("Selected Emoji Index: \(selectedIndex)")
                     // Example: Update the type if needed, though emojis might just be visual state
                     // ratingData[index].type = .emojis(images: [...], selectedIndex: selectedIndex)
                 }
            case .stepper:
                if let newStepValue = newValue as? Int {
                    ratingData[index].type = .stepper(value: newStepValue)
                }
            }
        }
    }
}

