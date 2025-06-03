//
//  MonthScrollPicker+Protocols.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-15.
//

import Foundation
import UIKit

 protocol MonthScrollPickerDataSource: class {
    
    /**
     ------------------------------------------------------------------------------------------
     Returns custom attributed string for top label
     ------------------------------------------------------------------------------------------
     - parameter MonthScrollPicker: current MonthScrollPicker
     - parameter date: cell date
     - returns: attributed string
     */
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, topAttributedStringByDate date: Date) -> NSAttributedString?
    
    /**
     ------------------------------------------------------------------------------------------
     Returns custom attributed string for medium label
     ------------------------------------------------------------------------------------------
     - parameter MonthScrollPicker: current MonthScrollPicker
     - parameter date: cell date
     - returns: attributed string
     */
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, mediumAttributedStringByDate date: Date) -> NSAttributedString?
    
    /**
     ------------------------------------------------------------------------------------------
     Returns custom attributed string for bottom label
     ------------------------------------------------------------------------------------------
     - parameter MonthScrollPicker: current MonthScrollPicker
     - parameter date: cell date
     - returns: attributed string
     */
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, bottomAttributedStringByDate date: Date) -> NSAttributedString?
    
    /**
     ------------------------------------------------------------------------------------------
     Returns custom attributed string for separator top label
     ------------------------------------------------------------------------------------------
     - parameter MonthScrollPicker: current MonthScrollPicker
     - parameter date: cell date
     - returns: attributed string
     */
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, separatorTopAttributedStringByDate date: Date) -> NSAttributedString?
    
    /**
     ------------------------------------------------------------------------------------------
     Returns custom attributed string for separator bottom label
     ------------------------------------------------------------------------------------------
     - parameter MonthScrollPicker: current MonthScrollPicker
     - parameter date: cell date
     - returns: attributed string
     */
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, separatorBottomAttributedStringByDate date: Date) -> NSAttributedString?
    
    /**
     ------------------------------------------------------------------------------------------
     Returns custom attributed string for data label
     ------------------------------------------------------------------------------------------
     - parameter MonthScrollPicker: current MonthScrollPicker
     - parameter date: cell date
     - returns: attributed string
     */
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, dataAttributedStringByDate date: Date) -> NSAttributedString?
    
    /**
     ------------------------------------------------------------------------------------------
     Returns custom color for dot view
     ------------------------------------------------------------------------------------------
     - parameter MonthScrollPicker: current MonthScrollPicker
     - parameter date: cell date
     - returns: dot color
     */
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, dotColorByDate date: Date) -> UIColor?
     
     /**
      ------------------------------------------------------------------------------------------
      Returns custom color for border
      ------------------------------------------------------------------------------------------
      - parameter MonthScrollPicker: current MonthScrollPicker
      - parameter date: cell date
      - returns: Border color
      */
     func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, borderColorByDate date: Date) -> UIColor?
}

extension MonthScrollPickerDataSource {
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, topAttributedStringByDate date: Date) -> NSAttributedString? {
        // Optional
        return nil
    }
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, mediumAttributedStringByDate date: Date) -> NSAttributedString? {
        // Optional
        return nil
    }
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, bottomAttributedStringByDate date: Date) -> NSAttributedString? {
        // Optional
        return nil
    }
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, separatorTopAttributedStringByDate date: Date) -> NSAttributedString? {
        // Optional
        return nil
    }
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, separatorBottomAttributedStringByDate date: Date) -> NSAttributedString? {
        // Optional
        return nil
    }
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, dataAttributedStringByDate date: Date) -> NSAttributedString? {
        // Optional
        return nil
    }
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, dotColorByDate date: Date) -> UIColor? {
        // Optional
        return nil
    }
}

public protocol MonthScrollPickerDelegate: class {
    
    /**
    ------------------------------------------------------------------------------------------
    Is called when date is selected
    ------------------------------------------------------------------------------------------
    - parameter MonthScrollPicker: current MonthScrollPicker
    - parameter date: selected date
    */
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, didSelectMonth dateIndexPath: IndexPath)
    
    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, didMonthChange date: Date)
}

//public extension MonthScrollPickerDelegate {
//
//    func MonthScrollPicker(_ MonthScrollPicker: MonthScrollPicker, didSelectDate date: Date) {
//        // Optional
//    }
//}

public protocol MonthScrollPickerInterface {
    
    /**
     ------------------------------------------------------------------------------------------
     Scroll to current date with selection
     ------------------------------------------------------------------------------------------
     - parameter animated: animation enabled
     */
    func selectToday(animated: Bool?)
    
    /**
     ------------------------------------------------------------------------------------------
     Scroll to date with selection
     ------------------------------------------------------------------------------------------
     - parameter date: date to scroll
     - parameter animated: animation enabled
     */
    func selectDate(_ date: Date, animated: Bool?)
    
    /**
     ------------------------------------------------------------------------------------------
     Scroll to date
     ------------------------------------------------------------------------------------------
     - parameter date: date to scroll
     - parameter animated: animation enabled
     */
    func scrollToDate(_ date: Date, animated: Bool?)
}
