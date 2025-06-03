//
//  MonthScrollPicker.swift
//  Ovulio Baby
//
//  Created by Jash on 2023-11-15.
//

import Foundation
import UIKit

public class MonthScrollPicker: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    /// Date scroll manager
    private var manager = DateScrollManager()
    
    /// Selected item
    private var selectedIndexPath: IndexPath?
    
    public var selectedDate: Date?
    
    /// Collection items
    private var dateItems = [DateScrollItem]()
    
    /////////////////////////////////////////////////////////////////////////////
    /// The object that provides the data for the field view
    /// - Note: The data source must adopt the `AnimatedFieldDataSource` protocol.
    weak var dataSource: MonthScrollPickerDataSource?
    
    /// //////////////////////////////////////////////////////////////////////////
    /// The object that acts as the delegate of the date scroll picker view. The delegate
    /// object is responsible for managing selection behavior and interactions with
    /// individual items.
    /// - Note: The delegate must adopt the `DateScrollPickerDelegate` protocol.
     weak var delegate: MonthScrollPickerDelegate?
    
    /// //////////////////////////////////////////////////////////////////////////
    /// Object that configure `DateScrollPicker` view. You can setup `DateScrollPicker` with
    /// your own parameters. See also `DateScrollPickerFormat` implementation.
    var format = DateScrollPickerFormat() {
        didSet {
            if !format.separatorEnabled {
                dateItems = dateItems.filter({ $0.separator == false })
                collectionView.reloadData()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func draw(_ rect: CGRect) {
         selectToday(animated: false)
    }
    
    private func commonInit() {
        _ = fromNib()
        setupView()
        setupCollection()
    }
    
    private func setupView() {
        var format = DateScrollPickerFormat()
        
        /// Number of days
        format.days = 7
        
        /// Top label date format
        format.topDateFormat = "EEE"
        
        /// Top label font
        format.topFont = UIFont.systemFont(ofSize: 12.pulse2Font(), weight: .regular)
        
        /// Top label text color
        format.topTextColor = UIColor.black
        
        /// Top label selected text color
        format.topTextSelectedColor = UIColor.black
        
        /// Medium label date format
        format.mediumDateFormat = "dd"
        
        /// Medium label font
        //        format.mediumFont = UIFont.systemFont(ofSize: 20, weight: .regular)
        
        format.mediumFont = UIFont().poppinsMedium(20.pulse2Font())
        
        /// Medium label text color
        format.mediumTextColor = UIColor.black
        
        /// Medium label selected text color
        format.mediumTextSelectedColor = UIColor.black
        
        /// Bottom label date format
        format.bottomDateFormat = "MMMM"
        /// Bottom label font
        format.bottomFont = UIFont.systemFont(ofSize: 10.pulse2Font(), weight: .regular)
        
        /// Bottom label text color
        format.bottomTextColor = UIColor.black
        
        /// Bottom label selected text color
        format.bottomTextSelectedColor = UIColor.black
        
        /// Day radius
        format.dayRadius = 5
        
        /// Day background color
        format.dayBackgroundColor = UIColor.white
        
        /// Day background selected color
        format.dayBackgroundSelectedColor = UIColor.white
        
        /// Selection animation
        format.animatedSelection = true
        
        /// Separator enabled
        format.separatorEnabled = false
        
        /// Separator top label date format
        format.separatorTopDateFormat = "MMM"
        /// Separator top label font
        format.separatorTopFont = UIFont.systemFont(ofSize: 10.pulse2Font(), weight: .bold)
        
        /// Separator top label text color
        format.separatorTopTextColor = UIColor.black
        
        /// Separator bottom label date format
        format.separatorBottomDateFormat = "yyyy"
        
        /// Separator bottom label font
        format.separatorBottomFont = UIFont.systemFont(ofSize: 10.pulse2Font(), weight: .regular)
        
        /// Separator bottom label text color
        format.separatorBottomTextColor = UIColor.black
        
        /// Separator background color
        format.separatorBackgroundColor = .white
        
        /// Fade enabled
        format.fadeEnabled = false
        
        /// Animation scale factor
        format.animationScaleFactor = 1.1
        
        /// Animation scale factor
        format.dayPadding = 5
        
        /// Top margin data label
        format.topMarginData = 10
        
        /// Dot view size
        format.dotWidth = 10
        self.format = format
        
        backgroundColor = .clear
        manager.format = self.format
    }
    
    func setupInitialDays(dateItems: [DateScrollItem]) {
        self.dateItems = dateItems
        self.collectionView.reloadData()
    }
    
    private func setupCollection() {
        let bundle = Bundle(for: self.classForCoder)
      
       // collectionView.register(UINib(nibName: "MonthScrollPicker", bundle: nil), forCellWithReuseIdentifier: "MonthScrollPicker")
        collectionView.register(UINib(nibName: "SeparatorViewCell", bundle: bundle), forCellWithReuseIdentifier: "SeparatorViewCell")
        
        collectionView.register(UINib(nibName: "MonthCalendarViewCell", bundle: bundle), forCellWithReuseIdentifier: "MonthCalendarViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: PUBLIC

extension MonthScrollPicker: DateScrollPickerInterface {
    
    public func selectToday(animated: Bool? = nil) {
        selectDate(Date().firstDateOfMonth(), animated: animated)
    }
    
    public func selectDate(_ date: Date, animated: Bool? = nil) {
        self.updateMonthLabelAppearance()
        guard let indexPath = indexPath(date: date.plain()) else { return }
        if dateItems[indexPath.item].isUserInteractionEnabled {
            selectItemAt(indexPath)
            scrollToDate(dateItems[indexPath.item].date, animated: animated)
        }else{
            selectItemAt(selectedIndexPath ?? IndexPath(item: 1, section: 0))
            scrollToDate(dateItems[selectedIndexPath?.item ?? 1].date, animated: animated)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.updateMonthLabelAppearance()
        }
    }
    
    public func scrollToDate(_ date: Date, animated: Bool? = nil) {
        guard let indexPath = indexPath(date: date.plain()) else { return }
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated ?? true)
        delegate?.MonthScrollPicker(self, didSelectMonth: indexPath)
    }
}

// MARK: ACTIONS

extension MonthScrollPicker {
    
    private func indexPath(date: Date) -> IndexPath? {
        guard let index = dateItems.firstIndex(where: {$0.date == date && $0.separator == false }) else { return nil }
        return IndexPath(item: index, section: 0)
    }
    
    private func selectItemAt(_ indexPath: IndexPath) {
        
        guard selectedIndexPath != indexPath else { return }
        
        // Selected cell
        let cell = collectionView.cellForItem(at: indexPath) as? MonthCalendarViewCell
        
        // Animate selection
        if format.animatedSelection {
            cell?.animateSelection(completion: nil)
        }
        
        // Make item selected
        dateItems.indices.forEach({ dateItems[$0].selected = false })
        dateItems[indexPath.item].selected = true
        
        // Select new indexPath
        var items = [indexPath]
        if let selectedIndexPath = selectedIndexPath { items.append(selectedIndexPath) }
        collectionView.reloadItems(at: items)
        // collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        
        //DO NOT CHANGE ORDER OF BELOW CODE
        if selectedDate?.firstDateOfMonth() != dateItems[indexPath.item].date.firstDateOfMonth(){
            delegate?.MonthScrollPicker(self, didMonthChange: dateItems[indexPath.item].date)
        }
        selectedIndexPath = indexPath
        selectedDate = dateItems[indexPath.item].date
    }
    
//    private func insertNewItems(_ insert: DateInsertType) {
//        guard let collectionView = collectionView, !manager.loadingMore else { return }
//        manager.loadingMore = true
//
//        var newDays = [DateScrollItem]()
//        switch insert {
//        case .previous:
//            newDays = manager.insertPreviousMonthDays(current: dateItems)
//            dateItems.insert(contentsOf: newDays, at: 0)
//        case .next:
//            newDays = manager.insertNextMonthDays(current: dateItems)
//            dateItems.append(contentsOf: newDays)
//        }
//
//        manager.insert(insert, count: newDays.count, inCollectionView: collectionView)
//    }
}

// MARK: COLLECTION DELEGATES

extension MonthScrollPicker: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if dateItems[indexPath.item].separator {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeparatorViewCell", for: indexPath) as! SeparatorViewCell
            cell.format = format
            cell.date = dateItems[indexPath.item].date
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCalendarViewCell", for: indexPath) as? MonthCalendarViewCell else { return UICollectionViewCell() }
            cell.isUserInteractionEnabled = dateItems[indexPath.item].isUserInteractionEnabled
            cell.contentView.alpha = dateItems[indexPath.item].isUserInteractionEnabled ? 1 : 0.7
            cell.dataSource = self
            cell.date = dateItems[indexPath.item].date
//            cell.format = format
//            cell.date = dateItems[indexPath.item].date
//            cell.isOn = dateItems[indexPath.item].selected
//            cell.containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
//            cell.containerView.layer.shadowRadius = 3
//            cell.containerView.layer.shadowOpacity = 5
//            cell.containerView.layer.shadowColor = UIColor.gray.cgColor
            return cell
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !dateItems[indexPath.item].separator && indexPath != selectedIndexPath {
            selectDate(dateItems[indexPath.item].date)
            // selectItemAt(indexPath)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if collectionView.contentOffset.x < 10 {
//            insertNewItems(.previous)
//        }
//        if collectionView.contentOffset.x > collectionView!.contentSize.width - collectionView.frame.size.width {
//            insertNewItems(.next)
//        }
        if format.fadeEnabled {
            collectionView.updateFadeCells()
        }
        self.updateMonthLabelAppearance()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Get the center point of the collection view
        let center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)

        // Get the index path of the cell at the center point
        if let indexPath = collectionView.indexPathForItem(at: center) {
            selectDate(dateItems[indexPath.item].date)
            // selectItemAt(indexPath)
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Get the center point of the collection view
        let center = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)

        // Get the index path of the cell at the center point
        if let indexPath = collectionView.indexPathForItem(at: center) {
            selectDate(dateItems[indexPath.item].date)
            // selectItemAt(indexPath)
        }
    }
    
    // Function to update the appearance of month labels based on the centered position
        func updateMonthLabelAppearance() {
            let centerPoint = CGPoint(x: collectionView.bounds.midX, y: collectionView.bounds.midY)
            
            if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
                for cell in collectionView.visibleCells {
                    if let cell = cell as? MonthCalendarViewCell {
                        let currentIndex = collectionView.indexPath(for: cell)!.item
                        let textColor: UIColor = (currentIndex == indexPath.item) ? appColor! : appColor!.withAlphaComponent(0.7)
                        cell.monthLabel.textColor = textColor
                    }
                }
            }
        }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if format.fadeEnabled {
            collectionView.updateFadeCells()
        }
    }
}

extension MonthScrollPicker: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: collectionView.frame.size.height)
    }
}

extension MonthScrollPicker: MonthCalendarViewCellDataSource {
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, topAttributedStringByDate date: Date) -> NSAttributedString? {
        return dataSource?.MonthScrollPicker(self, topAttributedStringByDate: date) ?? NSAttributedString(string: date.format(dateFormat: format.topDateFormat).uppercased())
    }
    
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, mediumAttributedStringByDate date: Date) -> NSAttributedString? {
        return dataSource?.MonthScrollPicker(self, mediumAttributedStringByDate: date) ?? NSAttributedString(string: date.format(dateFormat: format.mediumDateFormat).uppercased())
    }
    
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, bottomAttributedStringByDate date: Date) -> NSAttributedString? {
        return dataSource?.MonthScrollPicker(self, bottomAttributedStringByDate: date) ?? NSAttributedString(string: date.format(dateFormat: format.bottomDateFormat))
    }
    
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, dataAttributedStringByDate date: Date) -> NSAttributedString? {
        return dataSource?.MonthScrollPicker(self, dataAttributedStringByDate: date)
    }
    
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, dotColorByDate date: Date) -> UIColor? {
        return dataSource?.MonthScrollPicker(self, dotColorByDate: date)
    }
    
    func MonthCalendarViewCell(_ MonthCalendarViewCell: MonthCalendarViewCell, borderColorByDate date: Date) -> UIColor? {
        return dataSource?.MonthScrollPicker(self, borderColorByDate: date)
    }
}
