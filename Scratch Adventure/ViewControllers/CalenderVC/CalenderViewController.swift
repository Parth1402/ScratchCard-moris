//
//  CalenderViewController.swift
//  Scratch Adventure
//
//  Created by USER on 21/04/25.
//

import UIKit

class CalenderViewController: UIViewController {
    
    var customNavBarView: CustomNavigationBar?
    var needToShowSalesScreen = true
    
    var ContentContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var collectionView: UICollectionView!
    private let calendar = Calendar.current
    private var baseDate = Date()
    private let daysPerWeek = 7
    private var monthData: [(month: Date, days: [Date?])] = []
    private let purpleColor = UIColor(red: 148/255, green: 116/255, blue: 247/255, alpha: 1.0)
    
    private var selectedDates: Set<DateComponents> = {
        let today = Date()
        let components = Calendar.current.dateComponents([.year, .month, .day], from: today)
        return [components]
    }()


     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setUpBackground()
        
        configureCollectionView()
        generateMonthData()

        self.view.addSubview(ContentContainer)
        if DeviceSize.isiPadDevice {
            NSLayoutConstraint.activate([
                ContentContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                ContentContainer.widthAnchor.constraint(equalToConstant: self.view.layer.bounds.width - 60),
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
        
        // For internal test purposes
        let userDefaults = UserDefaults.standard
        //userDefaults.setValue(true, forKey: "didUnlockAppCompletely")
        
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
            titleString: "Sex Calender"
        )
        
        if let customNavBarView = customNavBarView {
            customNavBarView.leftButtonTapped = {
                self.dismiss(animated: false)
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
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseIdentifier)
        collectionView.register(MonthHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MonthHeaderView.reuseIdentifier)
        
        ContentContainer.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: ContentContainer.safeAreaLayoutGuide.topAnchor, constant: 44), // Keep below custom nav bar
            collectionView.leadingAnchor.constraint(equalTo: ContentContainer.leadingAnchor, constant: 10), // Add some padding
            collectionView.trailingAnchor.constraint(equalTo: ContentContainer.trailingAnchor, constant: -10), // Add some padding
            collectionView.bottomAnchor.constraint(equalTo: ContentContainer.bottomAnchor)
        ])
    }
    
    private func generateMonthData() {
        // TODO: Implement logic to generate data for multiple months
        // For now, let's generate data for the current month + next 2 months as an example
        monthData = []
        let today = Date()
        for i in 0..<12 { // Example: Current month + next 2 months
            if let monthDate = calendar.date(byAdding: .month, value: i, to: today) {
                let daysInMonth = generateDaysInMonth(for: monthDate)
                monthData.append((month: monthDate, days: daysInMonth))
            }
        }
        collectionView.reloadData()
    }
    
    func generateDaysInMonth(for date: Date) -> [Date?] {
        // TODO: Implement detailed logic to get the days array for a month,
        // including leading/trailing empty days to align weeks.
        // Placeholder implementation:
        guard let range = calendar.range(of: .day, in: .month, for: date) else { return [] }
        let numDays = range.count
        
        guard let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else { return [] }
        let firstDayWeekday = calendar.component(.weekday, from: firstOfMonth) // Sunday = 1, Saturday = 7
        
        var days: [Date?] = []
        // Add placeholders for days before the 1st of the month
        for _ in 1..<firstDayWeekday {
            days.append(nil)
        }
        
        // Add actual days
        for day in 1...numDays {
            var components = calendar.dateComponents([.year, .month], from: date)
            components.day = day
            days.append(calendar.date(from: components))
        }
        
        return days
    }
    
}

// MARK: - UICollectionViewDataSource
extension CalenderViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return monthData.count // One section per month
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthData[section].days.count // Number of days (including placeholders)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCell.reuseIdentifier, for: indexPath) as? DayCell else {
            fatalError("Unable to dequeue DayCell")
        }
        
        let date = monthData[indexPath.section].days[indexPath.item]
        cell.configure(with: date, isSelected: isDateSelected(date), isToday: isDateToday(date), purpleColor: purpleColor)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, 
              let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MonthHeaderView.reuseIdentifier, for: indexPath) as? MonthHeaderView else {
            fatalError("Failed to dequeue MonthHeaderView")
        }
        
        let monthDate = monthData[indexPath.section].month
        headerView.configure(with: monthDate)
        return headerView
    }
    
    private func isDateSelected(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return selectedDates.contains(components)
    }
    
    private func isDateToday(_ date: Date?) -> Bool {
        guard let date = date else { return false }
        return calendar.isDateInToday(date)
    }
}

// MARK: - UICollectionViewDelegate
extension CalenderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let date = monthData[indexPath.section].days[indexPath.item] else { return } // Ignore selection of placeholder cells
        
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        if selectedDates.contains(components) {
            selectedDates.remove(components)
        } else {
            selectedDates.insert(components)
        }
        collectionView.reloadItems(at: [indexPath]) // Reload just the selected cell for visual update
        
        let destinationViewController = DateNoteViewController()
        destinationViewController.modalPresentationStyle = .fullScreen
        destinationViewController.selectedDate = date
        self.present(destinationViewController, animated: false, completion: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalenderViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10 // Leading/Trailing padding of the collection view
        let interItemSpacing: CGFloat = (collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 2
        let availableWidth = collectionView.bounds.width - (padding * 2) - (interItemSpacing * CGFloat(daysPerWeek - 1))
        let itemWidth = availableWidth / CGFloat(daysPerWeek)
        return CGSize(width: itemWidth, height: itemWidth) // Make cells square
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80) // Height for month header + weekday labels
    }
}

// MARK: - Day Cell (Placeholder)
class DayCell: UICollectionViewCell {
    static let reuseIdentifier = "DayCell"
    private let dayLabel = UILabel()
    private let circleView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(circleView)
        contentView.addSubview(dayLabel)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.textAlignment = .center
        
        circleView.layer.cornerRadius = (contentView.bounds.width * 0.8) / 2 // Adjust multiplier as needed
        circleView.layer.borderWidth = 1.0
        circleView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            circleView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            circleView.heightAnchor.constraint(equalTo: circleView.widthAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Ensure corner radius updates if cell size changes
        circleView.layer.cornerRadius = (contentView.bounds.width * 0.8) / 2
    }

    func configure(with date: Date?, isSelected: Bool, isToday: Bool, purpleColor: UIColor) {
        guard let date = date else {
            dayLabel.text = ""
            circleView.layer.borderColor = UIColor.clear.cgColor
            contentView.isHidden = true // Hide placeholder cells
            return
        }
        
        contentView.isHidden = false
        let day = Calendar.current.component(.day, from: date)
        dayLabel.text = "\(day)"
        dayLabel.textColor = .white
        dayLabel.font = isToday ? .systemFont(ofSize: 16, weight: .bold) : .systemFont(ofSize: 16, weight: .medium)
        
        circleView.layer.borderColor = isSelected ? purpleColor.cgColor : UIColor.clear.cgColor
    }
}

// MARK: - Month Header View (Placeholder)
class MonthHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "MonthHeaderView"
    private let monthLabel = UILabel()
    private let weekdayStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(monthLabel)
        addSubview(weekdayStackView)
        
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        weekdayStackView.translatesAutoresizingMaskIntoConstraints = false
        
        monthLabel.textColor = .white
        monthLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        weekdayStackView.axis = .horizontal
        weekdayStackView.distribution = .fillEqually
        
        let weekdays = Calendar.current.shortWeekdaySymbols
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday.uppercased()
            label.textColor = .lightGray // Adjust color as needed
            label.font = .systemFont(ofSize: 12, weight: .medium)
            label.textAlignment = .center
            weekdayStackView.addArrangedSubview(label)
        }
        
        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            monthLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            weekdayStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdayStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdayStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            weekdayStackView.heightAnchor.constraint(equalToConstant: 20) // Adjust height as needed
        ])
    }

    func configure(with monthDate: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = dateFormatter.string(from: monthDate)
    }
}

