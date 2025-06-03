//
//  CustomeDateStackView.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-10-26.
//

import UIKit

class DateStackView: UIStackView, UITextFieldDelegate {
    final var dateTobeShown: Date?
    final var minimumDate: Date?
    final var maximumDate: Date?
    
    init(dateTobeShown: Date?, minimunDate: Date?, maximumDate: Date?) {
        self.dateTobeShown = dateTobeShown
        self.minimumDate = minimunDate
        self.maximumDate = maximumDate
        super.init(frame: .zero)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    private let dayContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 65).isActive = true
        view.backgroundColor = .white
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        view.layer.cornerRadius = 8
        view.dropShadow()
        return view
    }()
    
    private let dayTextField: NoPasteTextField = {
        let textField = NoPasteTextField()
        textField.placeholder = "DD"
        textField.textColor = appColor
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let monthContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 65).isActive = true
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let colonLabel: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let monthTextField: NoPasteTextField = {
        let textField = NoPasteTextField()
        textField.placeholder = "MM"
        textField.textColor = appColor
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        return textField
    }()
    
    private let colonLabel1: UILabel = {
        let label = UILabel()
        label.text = ":"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let yearContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 78).isActive = true
        view.heightAnchor.constraint(equalToConstant: 44).isActive = true
        view.layer.cornerRadius = 8
        view.dropShadow()
        return view
    }()
    
    private let yearTextField: NoPasteTextField = {
        let textField = NoPasteTextField()
        textField.placeholder = "YYYY"
        textField.textColor = appColor
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        return textField
    }()
    let datePicker = UIDatePicker()
    var isFieldChanged: ((_ date: Date) -> Void)?
    
    func setupUI() {
        axis = .horizontal
        distribution = .fillProportionally
        spacing = 8
        
        dayContainerView.addSubview(dayTextField)
        NSLayoutConstraint.activate([
            dayTextField.leadingAnchor.constraint(equalTo: dayContainerView.leadingAnchor),
            dayTextField.topAnchor.constraint(equalTo: dayContainerView.topAnchor),
            dayTextField.trailingAnchor.constraint(equalTo: dayContainerView.trailingAnchor),
            dayTextField.bottomAnchor.constraint(equalTo: dayContainerView.bottomAnchor),
        ])
        
        monthContainerView.addSubview(monthTextField)
        NSLayoutConstraint.activate([
            monthTextField.leadingAnchor.constraint(equalTo: monthContainerView.leadingAnchor),
            monthTextField.topAnchor.constraint(equalTo: monthContainerView.topAnchor),
            monthTextField.trailingAnchor.constraint(equalTo: monthContainerView.trailingAnchor),
            monthTextField.bottomAnchor.constraint(equalTo: monthContainerView.bottomAnchor),
        ])
        
        yearContainerView.addSubview(yearTextField)
        NSLayoutConstraint.activate([
            yearTextField.leadingAnchor.constraint(equalTo: yearContainerView.leadingAnchor),
            yearTextField.topAnchor.constraint(equalTo: yearContainerView.topAnchor),
            yearTextField.trailingAnchor.constraint(equalTo: yearContainerView.trailingAnchor),
            yearTextField.bottomAnchor.constraint(equalTo: yearContainerView.bottomAnchor),
        ])
        
        addArrangedSubview(dayContainerView)
        addArrangedSubview(colonLabel)
        addArrangedSubview(monthContainerView)
        addArrangedSubview(colonLabel1)
        addArrangedSubview(yearContainerView)
        
        
        datePicker.date = dateTobeShown ?? Date()
        datePicker.minimumDate = self.minimumDate
        datePicker.maximumDate = self.maximumDate
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "en_US")
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .allEvents)
        datePicker.setDate(Date(), animated: true)
        dayTextField.delegate = self
        monthTextField.delegate = self
        yearTextField.delegate = self
        dayTextField.tintColor = .clear
        monthTextField.tintColor = .clear
        yearTextField.tintColor = .clear
        dayTextField.inputView = datePicker
        monthTextField.inputView = datePicker
        yearTextField.inputView = datePicker
        setUpDateAndCycleValue()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dayTextField.showAnimation {}
        monthTextField.showAnimation {}
        yearTextField.showAnimation {}
        if dayTextField.text == nil || dayTextField.text == "" {
            func createDate(year: Int, month: Int, day: Int) -> Date? {
                let calendar = Calendar.current
                var components = DateComponents()
                components.year = year
                components.month = month
                components.day = day
//                components.hour = 18
//                components.minute = 30
//                components.second = 0
//                components.timeZone = TimeZone(secondsFromGMT: 0)

                return calendar.date(from: components)
            }

            func formattedDateString(year: Int, month: Int, day: Int) -> String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
//                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                if let date = createDate(year: year, month: month, day: day) {
                    return dateFormatter.string(from: date)
                } else {
                    return "Invalid date components"
                }
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            dayTextField.text = dateFormatter.string(from: (maximumDate ?? Date()))

            dateFormatter.dateFormat = "MM"
            monthTextField.text = dateFormatter.string(from: (maximumDate ?? Date()))

            dateFormatter.dateFormat = "yyyy"
            yearTextField.text = dateFormatter.string(from: (maximumDate ?? Date()))

            if let action = isFieldChanged {
                // Example usage:
                let formattedDate = formattedDateString(year: Int(yearTextField.text ?? "") ?? 0, month: Int(monthTextField.text ?? "") ?? 0, day: Int(dayTextField.text ?? "") ?? 0)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                action(dateFormatter.date(from: formattedDate) ?? Date())
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        dayTextField.text = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "MM"
        monthTextField.text = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "yyyy"
        yearTextField.text = dateFormatter.string(from: sender.date)
        
        if let action = isFieldChanged {
                action(sender.date)
        }
    }
    
    func setUpDateAndCycleValue() {
        
        if let date = dateTobeShown {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd"
            dayTextField.text = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "MM"
            monthTextField.text = dateFormatter.string(from: date)
            
            dateFormatter.dateFormat = "yyyy"
            yearTextField.text = dateFormatter.string(from: date)
        }
    }
}
