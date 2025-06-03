import UIKit

protocol HorizontalCalendarViewDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

class HorizontalCalendarView: UIView {

    weak var delegate: HorizontalCalendarViewDelegate?

    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.showsHorizontalScrollIndicator = false
        return sv
    }()

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 10 // Adjust spacing as needed
        sv.distribution = .fillEqually // Or adjust as needed
        return sv
    }()

    private var dateColumns: [DayColumnStackView] = [] // Store the vertical stacks
    private var currentDate = Date() // Keep track of the current date context
    var selectedDate: Date? = Date() { // Default to today
        didSet {
            updateDateSelection()
        }
    }
    private let todayDate: Date = Calendar.current.startOfDay(for: Date())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        populateCalendar()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        populateCalendar()
    }

    private func setupView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 15), // Add padding
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -15), // Add padding
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
        ])
    }

    func configure(centerDate: Date) {
        self.currentDate = centerDate // Use this to determine the months to show
        self.selectedDate = centerDate // Initially select the center date
        populateCalendar()
        // Scroll to selected or highlighted day if needed
         DispatchQueue.main.async { // Ensure layout is complete before scrolling
            // Use another async dispatch to give layout more time
            DispatchQueue.main.async { 
                 self.scrollToDate(self.currentDate, animated: false) 
            }
         }
    }

    private func populateCalendar() {
        // Ensure the main horizontal stackView is cleared
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        dateColumns.removeAll()

        let calendar = Calendar.current

        // Determine the range: current month, next month, month after next, relative to currentDate
        guard let currentMonthInterval = calendar.dateInterval(of: .month, for: currentDate),
              let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: currentDate),
              let monthAfterNextDate = calendar.date(byAdding: .month, value: 2, to: currentDate),
              let monthAfterNextInterval = calendar.dateInterval(of: .month, for: monthAfterNextDate) else { return }

        let startDate = currentMonthInterval.start // Start from the beginning of the current month
        let endDate = monthAfterNextInterval.end // End at the conclusion of the second month after the current one

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEE" // Short weekday name (e.g., Mon)

        // Ensure scrollView is directly in the HorizontalCalendarView
        if scrollView.superview == nil {
            addSubview(scrollView)
             NSLayoutConstraint.activate([
                 scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
                 scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
                 scrollView.topAnchor.constraint(equalTo: topAnchor),
                 scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
             ])
        }
        if stackView.superview == nil {
             scrollView.addSubview(stackView)
             NSLayoutConstraint.activate([
                 stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 15),
                 stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -15),
                 stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                 stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
                 // Make the horizontal stackView height match the scroll view frame height
                 stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
             ])
         }

        // Loop through each day from the start of the previous month to the end of the next month
        var loopDate = startDate
        while loopDate < endDate {
            let dateForDay = loopDate
            let day = calendar.component(.day, from: dateForDay)
            // Get the weekday string
            let weekdayString = weekdayFormatter.string(from: dateForDay).uppercased()

            // --- Create Weekday Label ---
            let weekdayLabel = UILabel()
            weekdayLabel.text = weekdayString
            weekdayLabel.font = UIFont.mymediumSystemFont(ofSize: 16)
            weekdayLabel.textColor = .white.withAlphaComponent(0.5)
            weekdayLabel.textAlignment = .center
            weekdayLabel.translatesAutoresizingMaskIntoConstraints = false

            // --- Create DateView ---
            let dateView = DateView()
            dateView.dayLabel.text = "\(day)"
            dateView.day = day
            dateView.date = dateForDay // Store the full date
            dateView.isToday = calendar.isDate(dateForDay, inSameDayAs: todayDate)
            // Check selection based on the full date
            if let selDate = selectedDate {
                dateView.isSelectedDate = calendar.isDate(dateForDay, inSameDayAs: selDate)
            } else {
                dateView.isSelectedDate = false
            }

            // Add tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTapped(_:)))
            dateView.addGestureRecognizer(tapGesture)
            dateView.isUserInteractionEnabled = true

            // Ensure DateView has a fixed width and is circular
             dateView.translatesAutoresizingMaskIntoConstraints = false
             NSLayoutConstraint.activate([
                 dateView.widthAnchor.constraint(equalToConstant: 40), // Adjust width as needed
                 dateView.heightAnchor.constraint(equalTo: dateView.widthAnchor) // Keep it circular/square
             ])

            // --- Create Vertical Stack for Day Column ---
            let dayColumnStack = DayColumnStackView(weekdayLabel: weekdayLabel, dateView: dateView)
            dayColumnStack.axis = .vertical
            dayColumnStack.spacing = 16 // Increased vertical spacing
            dayColumnStack.alignment = .center // Center items horizontally
            dayColumnStack.translatesAutoresizingMaskIntoConstraints = false

            // --- Add to Main Horizontal StackView ---
            stackView.addArrangedSubview(dayColumnStack)
            dateColumns.append(dayColumnStack) // Keep track of the columns

            // Move to the next day
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: loopDate) else { break }
            loopDate = nextDay
        }
        updateDateSelection()
    }

    @objc private func dateTapped(_ sender: UITapGestureRecognizer) {
        guard let tappedView = sender.view as? DateView, let tappedDate = tappedView.date else { return }

        self.selectedDate = tappedDate // Update internal state
        updateDateSelection() // Update appearance immediately
        delegate?.didSelectDate(tappedDate) // Notify delegate
    }

    private func updateDateSelection() {
        let calendar = Calendar.current
        for column in dateColumns {
            guard let dateView = column.dateView, let date = dateView.date else { continue }
            // Check selection based on full date
            if let selDate = selectedDate {
                dateView.isSelectedDate = calendar.isDate(date, inSameDayAs: selDate)
            } else {
                dateView.isSelectedDate = false
            }
            // Optionally update 'isToday' if the highlightedDay could change dynamically
            dateView.isToday = calendar.isDate(date, inSameDayAs: todayDate)
        }
    }

    private func scrollToDate(_ date: Date, animated: Bool) {
        let calendar = Calendar.current
        guard let targetIndex = dateColumns.firstIndex(where: { column in
            guard let d = column.dateView?.date else { return false }
            return calendar.isDate(d, inSameDayAs: date)
        }) else {
            print("scrollToDate: Target date \(date) not found in dateColumns.")
            return
        }

        print("--- scrollToDate --- ")
        print("Target Date: \(date)")
        print("Found Index: \(targetIndex)")

        let dateViewWidth: CGFloat = 40 // Should match the constraint
        let spacing: CGFloat = 10 // Should match stackView spacing
        let padding: CGFloat = 15 // Should match stackView leading padding

        // Calculate the x offset to center the target date view
        let targetColumn = dateColumns[targetIndex]
        print("Target Column Frame: \(targetColumn.frame)")
        print("ScrollView Bounds: \(scrollView.bounds)")
        print("ScrollView ContentSize: \(scrollView.contentSize)")
        let targetOffsetX = targetColumn.frame.origin.x + (targetColumn.frame.width / 2) - (scrollView.bounds.width / 2)

        // Ensure offset doesn't go beyond bounds
        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width + padding // Adjust for trailing padding
        let minOffsetX: CGFloat = -padding // Adjust for leading padding
        let clampedOffsetX = max(minOffsetX, min(targetOffsetX, maxOffsetX))

        print("Calculated Target OffsetX: \(targetOffsetX)")
        print("Clamped OffsetX: \(clampedOffsetX)")

        scrollView.setContentOffset(CGPoint(x: clampedOffsetX, y: 0), animated: animated)
    }
}

// MARK: - DateView (Individual Day Cell)

class DateView: UIView {
    let dayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.mymediumSystemFont(ofSize: 20)
        label.textColor = .white.withAlphaComponent(0.6) // Default text color
        return label
    }()

    var day: Int?
    var date: Date? // Store the full date object

    var isSelectedDate: Bool = false {
        didSet {
            updateAppearance()
        }
    }
     var isToday: Bool = false { // Property for the outline (e.g., blue circle)
         didSet {
             updateAppearance()
         }
     }


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(dayLabel)
        layer.cornerRadius = 20 // Make it circular (half of width/height)
        layer.masksToBounds = true
        layer.borderWidth = 1.5 // For the outline

        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        updateAppearance() // Initial setup
    }

    private func updateAppearance() {
         if isSelectedDate {
             backgroundColor = UIColor(named: "Pink") // Selected background (Pink)
             dayLabel.textColor = .white
             layer.borderColor = UIColor.clear.cgColor // No border when selected
         } else if isToday {
             backgroundColor = .clear // No background fill for today
             dayLabel.textColor = .white.withAlphaComponent(0.6) // Or a different color if needed
             layer.borderColor = UIColor(named: "Violet")?.cgColor // Blue border outline
             layer.borderWidth = 1.5 // Ensure border is visible
         } else {
             backgroundColor = .clear // Default background
             dayLabel.textColor = .white.withAlphaComponent(0.6) // Default text color
             layer.borderColor = UIColor.clear.cgColor
             layer.borderWidth = 0 // Hide border
         }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure corner radius is always half the width for a circle
        layer.cornerRadius = bounds.width / 2
    }
}

// Helper class to group weekday label and date view, simplifying access
class DayColumnStackView: UIStackView {
    var weekdayLabel: UILabel? {
        return arrangedSubviews.first as? UILabel
    }
    var dateView: DateView? {
        return arrangedSubviews.last as? DateView
    }

    convenience init(weekdayLabel: UILabel, dateView: DateView) {
        self.init(arrangedSubviews: [weekdayLabel, dateView])
    }
} 
