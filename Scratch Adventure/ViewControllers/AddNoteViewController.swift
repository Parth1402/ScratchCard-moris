import UIKit

// Define the delegate protocol for the calendar view itself if it's not already global
protocol HorizontalCalendarViewDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

// Define a delegate protocol for the rating cell to communicate changes back
protocol RatingTableCellDelegate: AnyObject {
    func ratingDidChange(title: String, ratingType: RatingTableCell.RatingType, newValue: Any) // Example signature
}

class AddNoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, HorizontalCalendarViewDelegate, RatingTableCellDelegate {

    // MARK: - Properties

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

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black // Or your desired background
        title = "Add Note" // Example title
        setupTableView()
        setupRatingData()
    }

    // MARK: - Setup

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear // Make table view background clear

        // Register cell types
        tableView.register(HorizontalCalenderTableCell.self, forCellReuseIdentifier: calendarCellIdentifier)
        tableView.register(RatingTableCell.self, forCellReuseIdentifier: ratingCellIdentifier)

        view.addSubview(tableView)

        // Constraints for the table view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupRatingData() {
        // --- Load Emoji Images Safely ---
        // Replace these with your actual asset names!
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

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Section 0: Calendar, Section 1: Ratings
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Calendar section has one row
        } else {
            return ratingData.count // Rating section has one row per item
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // --- Calendar Cell ---
            guard let cell = tableView.dequeueReusableCell(withIdentifier: calendarCellIdentifier, for: indexPath) as? HorizontalCalenderTableCell else {
                fatalError("Could not dequeue HorizontalCalenderTableCell")
            }
            // Configure the cell
            cell.delegate = self // Set the ViewController as the delegate
            cell.configure(centerDate: selectedDate)
            cell.backgroundColor = .clear // Ensure cell background is clear
            cell.contentView.backgroundColor = .clear
            return cell

        } else {
            // --- Rating Cell ---
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ratingCellIdentifier, for: indexPath) as? RatingTableCell else {
                fatalError("Could not dequeue RatingTableCell")
            }
            // Get data for the row
            let item = ratingData[indexPath.row]
            // Configure the cell
            cell.configure(title: item.title, ratingType: item.type)
            cell.delegate = self // Set the ViewController as the delegate
            cell.backgroundColor = .clear // Ensure cell background is clear
            cell.contentView.backgroundColor = .clear
            return cell
        }
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100 // Adjust height for calendar cell as needed
        } else {
            return 60  // Adjust height for rating cells as needed
        }
    }

    // Optional: Add spacing between sections if desired
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 20 : 0 // Add space above the ratings section
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    // MARK: - HorizontalCalendarViewDelegate

    func didSelectDate(_ date: Date) {
        self.selectedDate = date
        print("ViewController received selected date: \(date)")
        // TODO: Add logic here - e.g., fetch/update ratingData for the selected date
        // For now, just reload the table or specific sections if needed
        // self.setupRatingData() // If data depends entirely on date
        // tableView.reloadData()
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
             // Optionally, update just the specific cell if visuals changed internally
             // let indexPath = IndexPath(row: index, section: 1)
             // tableView.reloadRows(at: [indexPath], with: .none)
        }

        // TODO: Add logic to save the updated ratingData
    }
}

// Ensure your cell classes have delegate properties:
// In HorizontalCalenderTableCell.swift:
// weak var delegate: HorizontalCalendarViewDelegate?
// In its internal didSelectDate: self.delegate?.didSelectDate(date)

// In RatingTableCell.swift:
// weak var delegate: RatingTableCellDelegate?
// In your action handlers (@objc funcs):
// Call the delegate method, e.g.:
// self.delegate?.ratingDidChange(title: titleLabel.text ?? "", ratingType: /* determine type */, newValue: /* the new rating value */) 