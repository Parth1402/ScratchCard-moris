//
//  MonthCalendarViewCell.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-15.
//

import UIKit

protocol MonthCalendarViewCellDataSource {
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, topAttributedStringByDate date: Date) -> NSAttributedString?
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, mediumAttributedStringByDate date: Date) -> NSAttributedString?
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, bottomAttributedStringByDate date: Date) -> NSAttributedString?
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, dataAttributedStringByDate date: Date) -> NSAttributedString?
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, dotColorByDate date: Date) -> UIColor?
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, borderColorByDate date: Date) -> UIColor?
}

class MonthCalendarViewCell: UICollectionViewCell {

    @IBOutlet weak var monthLabel: UILabel!
    
    var dataSource: MonthCalendarViewCellDataSource?
    
    /// Cell date
    var date: Date = Date() {
        didSet {
            monthLabel.attributedText = dataSource?.MonthCalendarViewCell(self, bottomAttributedStringByDate: date)
        }
    }
    
    override func prepareForReuse() {
        monthLabel.textColor = appColor!.withAlphaComponent(0.7)
        self.contentView.alpha = 1
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        monthLabel.font = UIFont(name: "Poppins-Medium", size: 16)!
        monthLabel.adjustsFontSizeToFitWidth = true
        monthLabel.minimumScaleFactor = 0.2
        monthLabel.textColor = appColor!.withAlphaComponent(0.7)
    }

}

extension MonthCalendarViewCell {
    
    /// Selection animation with damping
    func animateSelection(completion: ((Bool) -> Void)?) {
//        containerView.transform = CGAffineTransform(scaleX: format.animationScaleFactor, y: format.animationScaleFactor)
//        isOn = true
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: .curveEaseIn, animations: {
//            self.containerView.transform = CGAffineTransform.identity
//        }, completion: completion)
    }
}
