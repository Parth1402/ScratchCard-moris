//
//  OvulationCircularCalendarView.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-24.
//

import Foundation
import UIKit

protocol OvulationCircularCalendarDelegate {
    func ovulationCircularCalendar(_ ovulationCircularCalendar: OvulationCircularCalendarView, didSelectDay day: Int)
}

enum ProbabilityOfPregnancy: String, Codable {
    case low = "Low"
    case high = "High"
    case veryHigh = "Very High"
    case highest = "Highest"
}

class OvulationCircularCalendarView: UIView {
    
    private var numberOfDays = 0
    private var redRanges: [(start: Int, end: Int)] = []
    private var blueRanges: [(start: Int, end: Int)] = []
    private var darkBlueRanges: [(start: Int, end: Int)] = []
    private var selectedDay: Int? = 0
    private var selectedDayColor: CGColor = (UIColor(hexString: "51C779") ?? .green).cgColor
    
    private var greenColor = UIColor(hexString: "51C779") ?? .green
    private var orangeColor = UIColor(hexString: "F9CDBF") ?? .orange
    private var redColor = UIColor(hexString: "FAB0BB") ?? .red
    private var blueColor = UIColor(hexString: "73A1F9") ?? .blue
    private var darkBlueColor = UIColor(hexString: "5C7AC7") ?? .brown
    
    private let detailsDayLabel = UILabel()
    private let detailsMonthLabel = UILabel()
    private let detailsDayDescriptionLabel = UILabel()
    private let detailsChanceStaticLabel = UILabel()
    private let detailsProbabilityLabel = UILabel()
    
    public var delegate: OvulationCircularCalendarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        setupLabels()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        setupLabels()
    }
    
    private func commonInit() {
        self.backgroundColor = UIColor.clear
    }
    
    func refreshView(numberOfDays: Int, redRanges: [(start: Int, end: Int)], blueRanges: [(start: Int, end: Int)], darkBlueRanges: [(start: Int, end: Int)]) {
        self.numberOfDays = numberOfDays
        self.redRanges = redRanges
        self.blueRanges = blueRanges
        self.darkBlueRanges = darkBlueRanges
        
        setNeedsDisplay()
    }
    
    func updateDetailsLabels(selectedDay: Int, monthName: String, description: String, probabiility: ProbabilityOfPregnancy) {
        
        self.selectedDay = selectedDay
        if isValueInRangeOrEqual(darkBlueRanges, selectedDay) {
            selectedDayColor = (darkBlueColor).cgColor
        } else if isValueInRangeOrEqual(blueRanges, selectedDay) {
            selectedDayColor = (blueColor).cgColor
        } else if isValueInRangeOrEqual(redRanges, selectedDay) {
            selectedDayColor = UIColor(hexString: "FF7676")!.cgColor
        } else {
            selectedDayColor = (greenColor).cgColor
        }
        detailsDayLabel.text = "\(selectedDay)"
        detailsMonthLabel.text = monthName
        detailsDayDescriptionLabel.text = description
        
        if probabiility == .low {
            detailsProbabilityLabel.text = NSLocalizedString("OvulationCalendarVC.probability.low.text", comment: "")
        } else if probabiility == .high {
            detailsProbabilityLabel.text = NSLocalizedString("OvulationCalendarVC.probability.high.text", comment: "")
        } else if probabiility == .veryHigh {
            detailsProbabilityLabel.text = NSLocalizedString("OvulationCalendarVC.probability.veryHigh.text", comment: "")
        } else if probabiility == .highest {
            detailsProbabilityLabel.text = NSLocalizedString("OvulationCalendarVC.probability.highest.text", comment: "")
        }
        
        let attributedText = NSMutableAttributedString(string: description)
        let regularFont = UIFont.systemFont(ofSize: 24.pulseWithFont(withInt: 4))
        let boldFont = UIFont.boldSystemFont(ofSize: 24.pulseWithFont(withInt: 4))
        let rangePeriod = (description as NSString).range(of: "OvulationCalendarVC.Periodday.headlineLabel.text"~)
        let rangeDays = (description as NSString).range(of: "OvulationCalendarVC.Daysbefore.headlineLabel.text"~)
        attributedText.addAttribute(.font, value: regularFont, range: rangePeriod)
        attributedText.addAttribute(.font, value: regularFont, range: rangeDays)
        detailsDayDescriptionLabel.attributedText = attributedText
        detailsDayDescriptionLabel.textColor = .white
        detailsDayDescriptionLabel.textAlignment = .center
        
        setNeedsDisplay()
        
    }
    
    private func setupLabels() {
        detailsDayLabel.text = "\(selectedDay ?? 0)"
        detailsDayLabel.font = UIFont.systemFont(ofSize: 20.pulseWithFont(withInt: 6))
        detailsDayLabel.textColor = .white
        detailsDayLabel.textAlignment = .center
        
//        detailsMonthLabel.text = "September"
        detailsMonthLabel.font = UIFont.systemFont(ofSize: 16.pulseWithFont(withInt: 4))
        detailsMonthLabel.textColor = .white
        detailsMonthLabel.textAlignment = .center
        
//        detailsDayDescriptionLabel.text = "Period day 1"
        detailsDayDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 24.pulseWithFont(withInt: 4))
        detailsDayDescriptionLabel.textColor = .white
        detailsDayDescriptionLabel.textAlignment = .center
        
        detailsChanceStaticLabel.text = NSLocalizedString("OvulationCalendarVC.detailsChanceStaticLabel.text", comment: "")
        detailsChanceStaticLabel.font = UIFont.systemFont(ofSize: 14.pulseWithFont(withInt: 4))
        detailsChanceStaticLabel.textAlignment = .center
        detailsChanceStaticLabel.textColor = .white
        detailsChanceStaticLabel.numberOfLines = 2
        
//        detailsProbabilityLabel.text = "< 3%"/
        detailsProbabilityLabel.font = UIFont.boldSystemFont(ofSize: 20.pulseWithFont(withInt: 4))
        detailsProbabilityLabel.textColor = .white
        detailsProbabilityLabel.textAlignment = .center
        
        self.addSubview(detailsDayLabel)
        self.addSubview(detailsMonthLabel)
        self.addSubview(detailsDayDescriptionLabel)
        self.addSubview(detailsChanceStaticLabel)
        self.addSubview(detailsProbabilityLabel)
        
    }
    
    // Function to check if the selected value is within any range
    func isValueInRangeOrEqual(_ ranges: [(start: Int, end: Int)], _ value: Int) -> Bool {
        for range in ranges {
            if value >= range.start && value <= range.end {
                return true
            }
        }
        return false
    }
    
    // Function to check if the selected value is within any range
    func isValueInRange(_ ranges: [(start: Int, end: Int)], _ value: Int) -> Bool {
        for range in ranges {
            if value > range.start && value < range.end {
                return true
            }
        }
        return false
    }
    
    // Function to check if the selected value is a start value for any range
    func isStartValue(_ ranges: [(start: Int, end: Int)], _ value: Int) -> Bool {
        for range in ranges {
            if value == range.start {
                return true
            }
        }
        return false
    }
    
    // Function to check if the selected value is an end value for any range
    func isEndValue(_ ranges: [(start: Int, end: Int)], _ value: Int) -> Bool {
        for range in ranges {
            if value == range.end {
                return true
            }
        }
        return false
    }
    
    // Function to check if the selected value is the only value in a range
    func isOnlyValueInARange(_ ranges: [(start: Int, end: Int)], _ value: Int) -> Bool {
        for range in ranges {
            if value == range.start && value == range.end {
                return true
            }
        }
        return false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Center and radius
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let outerRadius = min(rect.width, rect.height) / 2
        let innerRadius = outerRadius * 0.74
        
        
        
        
        //MARK: Inner detail circle
        let space: CGFloat = 10
        let newInnerRadius = innerRadius - space
        
        // Set the fill color for the new inner circle
        context.setFillColor((selectedDayColor))
        
        // Create a new circle path for the inner circle
        let innerCirclePath = UIBezierPath(arcCenter: center, radius: newInnerRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        context.addPath(innerCirclePath.cgPath)
        context.fillPath()
        let greenCircleDiameter = (innerRadius - space) * 2
        
        let firstLabelY = center.y - greenCircleDiameter / 3
        let labelHeight: CGFloat = DeviceSize.isiPadDevice ? 30 : 20
        let labelSpacing = (greenCircleDiameter - CGFloat(labelHeight * 5)) / 9
        
        let labelWidth = greenCircleDiameter
        let labelX = center.x - labelWidth / 2
        
        detailsDayLabel.frame = CGRect(x: labelX, y: firstLabelY - greenCircleDiameter / 13, width: labelWidth, height: labelHeight)
        detailsMonthLabel.frame = CGRect(x: labelX, y: (firstLabelY + labelHeight + labelSpacing) - greenCircleDiameter / 9, width: labelWidth, height: labelHeight)
        detailsDayDescriptionLabel.frame = CGRect(x: labelX, y: (firstLabelY + (labelHeight + labelSpacing) * 1.6), width: labelWidth, height: labelHeight * 1.5)
        detailsChanceStaticLabel.frame = CGRect(x: labelX, y: firstLabelY + (labelHeight + labelSpacing) * 3.2, width: labelWidth, height: labelHeight * 2) // because it's 2 lines
        detailsProbabilityLabel.frame = CGRect(x: labelX, y: firstLabelY + (labelHeight + labelSpacing) * 4.5, width: labelWidth, height: labelHeight + 5)
        
        
        

        //MARK: Draw orange ring
        let cornerRoundFactor: CGFloat = 0.3
        let angleIncrement = 2 * .pi / CGFloat(numberOfDays)
        if !(numberOfDays > 1) {
            return
        }
        for day in 1...numberOfDays {
            var startAngle = angleIncrement * CGFloat(day - 1) - .pi / 2  // Subtracting .pi/2 to shift starting point
            var endAngle = angleIncrement * CGFloat(day) - .pi / 2
            
            // Adjust angles for rounding off corners
            if isStartValue(redRanges, day) || isStartValue(blueRanges, day) || isStartValue(darkBlueRanges, day) {
                startAngle += cornerRoundFactor
            }
            if isEndValue(redRanges, day) || isEndValue(blueRanges, day) || isEndValue(darkBlueRanges, day) {
                endAngle -= cornerRoundFactor
            }
            
            context.addArc(center: center, radius: (innerRadius + outerRadius) / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
            let colorWithAlpa = orangeColor
            context.setStrokeColor(colorWithAlpa.cgColor)
            context.setLineWidth(outerRadius - innerRadius)
            context.strokePath()
        }

        
        
        //MARK: Draw Red days
        for day in 1...numberOfDays {
            if isValueInRangeOrEqual(redRanges, day) {
                let angleMidpoint = angleIncrement * CGFloat(day - 1) + (angleIncrement / 2) - .pi / 2
                var redStartAngle = angleMidpoint - (angleIncrement * 1)
                var redEndAngle = angleMidpoint + (angleIncrement * 1)
                // Adjust angles for rounding off corners
                if isStartValue(redRanges, day) {
                    redStartAngle += cornerRoundFactor
                }
                if isEndValue(redRanges, day) {
                    redEndAngle -= cornerRoundFactor
                }
                let textRadius = (innerRadius + outerRadius) / 2
                if isValueInRange(redRanges, day) {
                    
                    let path = UIBezierPath()
                    path.addArc(withCenter: center, radius: innerRadius, startAngle: redEndAngle, endAngle: redStartAngle, clockwise: false)
                    path.addArc(withCenter: center, radius: outerRadius, startAngle: redStartAngle, endAngle: redEndAngle, clockwise: true)
                    context.addPath(path.cgPath)
                    context.setFillColor((redColor).cgColor)
                    context.fillPath()
                }
                
                if isStartValue(redRanges, day) {
                    if !isOnlyValueInARange(redRanges, day) {
                        context.addArc(center: center, radius: (innerRadius + outerRadius) / 2, startAngle: angleMidpoint, endAngle: redEndAngle, clockwise: false)
                        let colorWithAlpa = (redColor)
                        context.setStrokeColor(colorWithAlpa.cgColor)
                        context.setLineWidth(outerRadius - innerRadius)
                        context.strokePath()
                    }
                    let circleRadius: CGFloat = outerRadius - innerRadius
                    let adjustedRadius = textRadius - ((outerRadius - innerRadius) / 2) + circleRadius / 2
                    let circlePoint = CGPoint(x: center.x + (adjustedRadius * cos(angleMidpoint)) - circleRadius / 2, y: center.y + (adjustedRadius * sin(angleMidpoint)) - circleRadius / 2)
                    let circlePath = UIBezierPath(ovalIn: CGRect(origin: circlePoint, size: CGSize(width: circleRadius, height: circleRadius)))
                    (redColor).setFill()
                    circlePath.fill()
                }
                
                if isEndValue(redRanges, day) {
                     let circleRadius: CGFloat = outerRadius - innerRadius
                    let adjustedRadius = textRadius - ((outerRadius - innerRadius) / 2) + circleRadius / 2
                    let circlePoint = CGPoint(x: center.x + (adjustedRadius * cos(angleMidpoint)) - circleRadius / 2, y: center.y + (adjustedRadius * sin(angleMidpoint)) - circleRadius / 2)
                    let circlePath = UIBezierPath(ovalIn: CGRect(origin: circlePoint, size: CGSize(width: circleRadius, height: circleRadius)))
                    (redColor).setFill()
                    circlePath.fill()
                }
            }
        }
        
        
        
        //MARK: Draw Blue days
        for day in 1...numberOfDays {
            if isValueInRangeOrEqual(blueRanges, day) {
                let angleMidpoint = angleIncrement * CGFloat(day - 1) + (angleIncrement / 2) - .pi / 2
                var blueStartAngle = angleMidpoint - (angleIncrement * 1)
                var blueEndAngle = angleMidpoint + (angleIncrement * 1)
                // Adjust angles for rounding off corners
                if isStartValue(blueRanges, day){
                    blueStartAngle += cornerRoundFactor
                }
                if isEndValue(blueRanges, day) {
                    blueEndAngle -= cornerRoundFactor
                }
                let textRadius = (innerRadius + outerRadius) / 2
                if isValueInRange(blueRanges, day) {
                    let path = UIBezierPath()
                    path.addArc(withCenter: center, radius: innerRadius, startAngle: blueEndAngle, endAngle: blueStartAngle, clockwise: false)
                    path.addArc(withCenter: center, radius: outerRadius, startAngle: blueStartAngle, endAngle: blueEndAngle, clockwise: true)
                    context.addPath(path.cgPath)
                    context.setFillColor((blueColor).cgColor)
                    context.fillPath()
                }
                
                if isStartValue(blueRanges, day) {
                    if !isOnlyValueInARange(blueRanges, day) {
                        context.addArc(center: center, radius: (innerRadius + outerRadius) / 2, startAngle: angleMidpoint, endAngle: blueEndAngle, clockwise: false)
                        let colorWithAlpa = (blueColor)
                        context.setStrokeColor(colorWithAlpa.cgColor)
                        context.setLineWidth(outerRadius - innerRadius)
                        context.strokePath()
                    }
                    let circleRadius: CGFloat = outerRadius - innerRadius
                    let adjustedRadius = textRadius - ((outerRadius - innerRadius) / 2) + circleRadius / 2
                    let circlePoint = CGPoint(x: center.x + (adjustedRadius * cos(angleMidpoint)) - circleRadius / 2, y: center.y + (adjustedRadius * sin(angleMidpoint)) - circleRadius / 2)
                    let circlePath = UIBezierPath(ovalIn: CGRect(origin: circlePoint, size: CGSize(width: circleRadius, height: circleRadius)))
                    (blueColor).setFill()
                    circlePath.fill()
                }
                
                if isEndValue(blueRanges, day) {
                    let circleRadius: CGFloat = outerRadius - innerRadius
                    let adjustedRadius = textRadius - ((outerRadius - innerRadius) / 2) + circleRadius / 2
                    let circlePoint = CGPoint(x: center.x + (adjustedRadius * cos(angleMidpoint)) - circleRadius / 2, y: center.y + (adjustedRadius * sin(angleMidpoint)) - circleRadius / 2)
                    let circlePath = UIBezierPath(ovalIn: CGRect(origin: circlePoint, size: CGSize(width: circleRadius, height: circleRadius)))
                    (blueColor).setFill()
                    circlePath.fill()
                }
            }
        }
        
        
        
        //MARK: Draw DarkBlue days
        for day in 1...numberOfDays {
            if isValueInRangeOrEqual(darkBlueRanges, day) {
                let angleMidpoint = angleIncrement * CGFloat(day - 1) + (angleIncrement / 2) - .pi / 2
                var blueStartAngle = angleMidpoint - (angleIncrement * 1)
                var blueEndAngle = angleMidpoint + (angleIncrement * 1)
                // Adjust angles for rounding off corners
                if isStartValue(darkBlueRanges, day){
                    blueStartAngle += cornerRoundFactor
                }
                if isEndValue(darkBlueRanges, day) {
                    blueEndAngle -= cornerRoundFactor
                }
                let textRadius = (innerRadius + outerRadius) / 2
                if isValueInRange(darkBlueRanges, day) {
                    let path = UIBezierPath()
                    path.addArc(withCenter: center, radius: innerRadius, startAngle: blueEndAngle, endAngle: blueStartAngle, clockwise: false)
                    path.addArc(withCenter: center, radius: outerRadius, startAngle: blueStartAngle, endAngle: blueEndAngle, clockwise: true)
                    context.addPath(path.cgPath)
                    context.setFillColor((darkBlueColor).cgColor)
                    context.fillPath()
                }
                
                if isStartValue(darkBlueRanges, day) {
                    if !isOnlyValueInARange(darkBlueRanges, day) {
                        context.addArc(center: center, radius: (innerRadius + outerRadius) / 2, startAngle: angleMidpoint, endAngle: blueEndAngle, clockwise: false)
                        let colorWithAlpa = darkBlueColor
                        context.setStrokeColor(colorWithAlpa.cgColor)
                        context.setLineWidth(outerRadius - innerRadius)
                        context.strokePath()
                    }
                    let circleRadius: CGFloat = outerRadius - innerRadius
                    let adjustedRadius = textRadius - ((outerRadius - innerRadius) / 2) + circleRadius / 2
                    let circlePoint = CGPoint(x: center.x + (adjustedRadius * cos(angleMidpoint)) - circleRadius / 2, y: center.y + (adjustedRadius * sin(angleMidpoint)) - circleRadius / 2)
                    let circlePath = UIBezierPath(ovalIn: CGRect(origin: circlePoint, size: CGSize(width: circleRadius, height: circleRadius)))
                    (darkBlueColor).setFill()
                    circlePath.fill()
                }
                
                if isEndValue(darkBlueRanges, day) {
                    let circleRadius: CGFloat = outerRadius - innerRadius
                    let adjustedRadius = textRadius - ((outerRadius - innerRadius) / 2) + circleRadius / 2
                    let circlePoint = CGPoint(x: center.x + (adjustedRadius * cos(angleMidpoint)) - circleRadius / 2, y: center.y + (adjustedRadius * sin(angleMidpoint)) - circleRadius / 2)
                    let circlePath = UIBezierPath(ovalIn: CGRect(origin: circlePoint, size: CGSize(width: circleRadius, height: circleRadius)))
                    (darkBlueColor).setFill()
                    circlePath.fill()
                }
            }
        }
        
        
        
        //MARK: Draw days Text
        for day in 1...numberOfDays {
            var startAngle = angleIncrement * CGFloat(day - 1) - .pi / 2
            var endAngle = angleIncrement * CGFloat(day) - .pi / 2
            
            
            if isStartValue(redRanges, day) || isStartValue(blueRanges, day) || isStartValue(darkBlueRanges, day) {
                startAngle += cornerRoundFactor
            }
            if isEndValue(redRanges, day) || isEndValue(blueRanges, day) || isEndValue(darkBlueRanges, day) {
                endAngle -= cornerRoundFactor
            }
            
            if isValueInRangeOrEqual(redRanges, day) {
//                let angleMidpoint = angleIncrement * CGFloat(day - 1) + (angleIncrement / 2)
                drawDayText(day: day, angleIncrement: angleIncrement, center: center, innerRadius: innerRadius, outerRadius: outerRadius)
            } else if isValueInRangeOrEqual(blueRanges, day) {
                drawDayText(day: day, angleIncrement: angleIncrement, center: center, innerRadius: innerRadius, outerRadius: outerRadius)
            } else if isValueInRangeOrEqual(darkBlueRanges, day) {
                drawDayText(day: day, angleIncrement: angleIncrement, center: center, innerRadius: innerRadius, outerRadius: outerRadius)
            }else {
                context.addArc(center: center, radius: (innerRadius + outerRadius) / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                let angleMidpoint = angleIncrement * CGFloat(day - 1) + (angleIncrement / 2) - .pi / 2
                let textRadius = (innerRadius + outerRadius) / 2
                let textPoint = CGPoint(x: center.x + (textRadius * cos(angleMidpoint)) - 6, y: center.y + (textRadius * sin(angleMidpoint)) - 6)
                let dayText = "*" as NSString
                dayText.draw(at: textPoint, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.pulseWithFont(withInt: 4)), NSAttributedString.Key.foregroundColor: UIColor.white])
            }
            
//            let angleMidpoint = angleIncrement * CGFloat(day - 1) + (angleIncrement / 2) - .pi / 2
//            let textRadius = (innerRadius + outerRadius) / 2
//            let textPoint = CGPoint(
//                x: center.x + textRadius * cos(angleMidpoint),
//                y: center.y + textRadius * sin(angleMidpoint)
//            )
            
            
            
            //MARK: Draw Selected days on Tap
            if let selectedDay = selectedDay, day == selectedDay {
                drawSelectedDay(day: day, angleIncrement: angleIncrement, center: center, innerRadius: innerRadius, outerRadius: outerRadius, context: UIGraphicsGetCurrentContext()!)
            }
        }
    }
    
    private func drawDayText(day: Int, angleIncrement: CGFloat, center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat) {
        let angleMidpoint = angleIncrement * CGFloat(day - 1) + (angleIncrement / 2) - .pi / 2
        let textRadius = (innerRadius + outerRadius) / 2
        let textPoint = CGPoint(x: center.x + (textRadius * cos(angleMidpoint)) - 6, y: center.y + (textRadius * sin(angleMidpoint)) - 6)
//        if day == 12 {
//            let circleRadius: CGFloat = outerRadius - innerRadius  // or whatever size you want
//            let circleOrigin = CGPoint(x: textPoint.x - circleRadius/2, y: textPoint.y - circleRadius/2)
//            let circlePath = UIBezierPath(ovalIn: CGRect(origin: circleOrigin, size: CGSize(width: circleRadius, height: circleRadius)))
//            UIColor.green.setFill()  // Set the fill color to green
//            circlePath.fill()
//        }
        let dayText = "\(day)" as NSString
        dayText.draw(at: textPoint, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.pulseWithFont(withInt: 4)), NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    private func drawSelectedDay(day: Int, angleIncrement: CGFloat, center: CGPoint, innerRadius: CGFloat, outerRadius: CGFloat, context: CGContext) {
        let angleMidpoint = angleIncrement * CGFloat(day - 1) + (angleIncrement / 2) - .pi / 2
        let textRadius = (innerRadius + outerRadius) / 2
        let blockHeight = outerRadius - innerRadius
        let circleDiameter = blockHeight - 2.5
        let textPoint = CGPoint(
            x: center.x + textRadius * cos(angleMidpoint) - circleDiameter / 2,
            y: center.y + textRadius * sin(angleMidpoint) - circleDiameter / 2
        )
        let circleRect = CGRect(x: textPoint.x, y: textPoint.y, width: circleDiameter, height: circleDiameter)
        
        // Draw the green filled circle
        context.setFillColor(selectedDayColor)
        context.fillEllipse(in: circleRect)
        
        //draw the white border around the circle
        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(2.5)
        context.strokeEllipse(in: circleRect)
        
        // Draw the day text
        let dayText = "\(day)" as NSString
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 13.pulseWithFont(withInt: 4)),
            .foregroundColor: UIColor.white
        ]
        
        let textSize = dayText.size(withAttributes: attributes)
        let textRect = CGRect(
            x: textPoint.x + (circleDiameter - textSize.width) / 2,
            y: textPoint.y + (circleDiameter - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        dayText.draw(in: textRect, withAttributes: attributes)
    }
    
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let touchPoint = gesture.location(in: self)
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let touchVector = CGVector(dx: touchPoint.x - center.x, dy: touchPoint.y - center.y)
        
        let angle = atan2(touchVector.dy, touchVector.dx) + .pi / 2
        let distanceFromCenter = sqrt(pow(touchVector.dx, 2) + pow(touchVector.dy, 2))
        
        let outerRadius = min(bounds.width, bounds.height) / 2
        let innerRadius = outerRadius * 0.8
        
        if distanceFromCenter >= innerRadius && distanceFromCenter <= outerRadius {
            let normalizedAngle = (angle < 0) ? angle + 2 * .pi : angle
            let day = Int(normalizedAngle / (2 * .pi) * CGFloat(numberOfDays)) + 1
            dayTapped(day: day)
        }
    }
    
    private func dayTapped(day: Int) {
        delegate?.ovulationCircularCalendar(self, didSelectDay: day)
    }
}
