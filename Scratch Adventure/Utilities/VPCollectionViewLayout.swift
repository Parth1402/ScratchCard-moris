//
//  VPCollectionViewLayout.swift
//  VPCollectionViewLayoutExample
//  Version 0.1.0
//
//  Created by Varun P M on 05/11/17.
//  Copyright © 2017 Varun P M. All rights reserved.
//
//
//  MIT License
//
//  Copyright (c) 2017 Varun P M
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class VPCollectionViewLayout: UICollectionViewFlowLayout {
    // Enum that contains all possible combination of layout type
    enum CollectionViewLayoutType {
        /// If vertical flow, then the cells will be placed horizontally first until it fits the current collectionView's width. If the cell doesn't fit, then it'll be moved to next row and same flow follows for remaining cells. If there is a new section, then the cell will be forced to the next row forcefully.
        case vertical
        
        /// If horizontal flow, then the cells will be placed vertically first until it fits the current collectionView's height. If the cell doesn't fit, then it'll be moved to next column and same flow follows for remaining cells. If there is a new section, then the cell will be forced to the next column forcefully.
        case horizontal
        
        /// If centralized flow, then the cells will be placed centered and vertically and will be adjusted to accomodate as much as possible.
        /// - Note: The cell's height for all the cell within a section has to be constant for this to look good.
        case centralizedVertical
        
        /// If centralized flow, then the cells will be placed centered and horizontally and will be adjusted to accomodate as much as possible.
        /// - Note: The cell's width for all the cell within a section has to be constant for this to look good.
        case centralizedHorizontal
        
        /// If circular flow, then the cells will be placed circularly and will be adjusted to accomodate as much as possible.
        /// - Note: This will place the cell in round table format and doesn't rotate the cell itself. Also this layout assumes that all the cell's are of same size. Different sized cells are not supported.
        case circular
    }
    
    /// Set the required layout type from the defined set of types. Defaults to vertical
    var layoutType: CollectionViewLayoutType = .circular
    
    /// The radius to be used for circular layout. Defaults to 100
    var circularRadius: CGFloat = 108
    
    // This variable is used if a cell has to be expanded when selecting pushing other nearby cells maintaining the same spacing
    private var selectedIndexPath: IndexPath?
    
    // This variable is used only if `selectedIndexPath` is set. This variable takes values by which the size has to be increased or decreased for the selected cell. The values should be in range between 0 (decrease to 0) to +ve (increase by any value)
    private var selectedCellExpandPercentage: CGSize = CGSize(width: 1, height: 1)
    
    // Stored calculated attributes for caching purpose
    private var layoutAttributes: [UICollectionViewLayoutAttributes] = []
    private var maxContentWidth: CGFloat = 0
    private var maxContentHeight: CGFloat = 0
    
    override func prepare() {
        layoutAttributes.removeAll()
        calculateLayoutAttributes()
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: maxContentWidth, height: maxContentHeight)
    }
    
    /// Call this method when selection of cell should expand the cell with/without animation
    ///
    /// - Parameters:
    ///   - indexPath: the indexpath of the cell whose size has to be increased or decreased. If set to nil, the size will return to default size if there are any previously selected cells.
    ///   - percentageIncrease: the size increase in percentage/100 format for the selected cell. If width and height are 1 & 1, then default size. If greater than 1, then it's increased size and vice-versa. Defaults to 1.25 each (125% of the current size).
    ///   - shouldAnimate: optional bool variable to animate selection if needed. Defaults to `true`.
    func didSelectCell(atIndexPath indexPath: IndexPath?, percentageIncrease: CGSize = CGSize(width: 1.25, height: 1.25), shouldAnimate: Bool = true) {
        selectedIndexPath = indexPath
        selectedCellExpandPercentage = percentageIncrease
        
        if shouldAnimate {
            collectionView?.performBatchUpdates({ [weak self] in
                self?.invalidateLayout()
            }, completion: nil)
        }
        else {
            invalidateLayout()
        }
    }
    
    // Calculate the attributes when invalidating layout
    private func calculateLayoutAttributes() {
        guard let collectionView = collectionView else {
            return
        }
        
        maxContentWidth = 0
        maxContentHeight = 0
        
        var adjustedInsets: CGFloat = 0
        if #available(iOS 11, *) {
            adjustedInsets = collectionView.adjustedContentInset.top
        }
        
        let adjustedCollectionViewHeight = collectionView.bounds.size.height - adjustedInsets
        var startXPosition: CGFloat = 0
        var startYPosition: CGFloat = 0
        var availableWidth: CGFloat = collectionView.bounds.size.width
        var availableHeight: CGFloat = adjustedCollectionViewHeight
        var angle: CGFloat = 0
        
        for sectionIndex in stride(from: 0, to: collectionView.numberOfSections, by: 1) {
            // Fetch the default values for spacing, if set
            var defaultSectionInsets: UIEdgeInsets = sectionInset
            var defaultInterItemSpacing: CGFloat = minimumInteritemSpacing
            var defaultLineSpacing: CGFloat = minimumLineSpacing
            
            if let delagteFlowLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
                // Get the insets from the controller/view if the insets delegate has been implemented
                if delagteFlowLayout.responds(to: #selector(delagteFlowLayout.collectionView(_:layout:insetForSectionAt:))) {
                    defaultSectionInsets = delagteFlowLayout.collectionView!(collectionView, layout: self, insetForSectionAt: sectionIndex)
                }
                
                // Get the inter item spacing from the controller/view if the inter item spacing delegate has been implemented
                if delagteFlowLayout.responds(to: #selector(delagteFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))) {
                    defaultInterItemSpacing = delagteFlowLayout.collectionView!(collectionView, layout: self, minimumInteritemSpacingForSectionAt: sectionIndex)
                }
                
                // Get the line spacing from the controller/view if the line spacing delegate has been implemented
                if delagteFlowLayout.responds(to: #selector(delagteFlowLayout.collectionView(_:layout:minimumLineSpacingForSectionAt:))) {
                    defaultLineSpacing = delagteFlowLayout.collectionView!(collectionView, layout: self, minimumLineSpacingForSectionAt: sectionIndex)
                }
            }
            
            // Update content variables based on layout type
            switch layoutType {
            case .vertical, .centralizedVertical:
                startYPosition += defaultSectionInsets.top
                startXPosition = defaultSectionInsets.left
                maxContentHeight += defaultSectionInsets.top
                availableWidth = (collectionView.bounds.size.width - defaultSectionInsets.left - defaultSectionInsets.right)
            case .horizontal, .centralizedHorizontal:
                startXPosition += defaultSectionInsets.left
                startYPosition = defaultSectionInsets.top
                maxContentWidth += defaultSectionInsets.left
                availableHeight = (adjustedCollectionViewHeight - defaultSectionInsets.top - defaultSectionInsets.bottom)
            case .circular:
                angle = 2 * CGFloat.pi / CGFloat(collectionView.numberOfItems(inSection: sectionIndex))
            }
            
            for itemIndex in stride(from: 0, to: collectionView.numberOfItems(inSection: sectionIndex), by: 1) {
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                let layoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                var itemSize: CGSize = CGSize.zero
                
                // Get the item size from the controller/view if the itemSize delegate has been implemented
                if let delagteFlowLayout = collectionView.delegate as? UICollectionViewDelegateFlowLayout {
                    if delagteFlowLayout.responds(to: #selector(delagteFlowLayout.collectionView(_:layout:sizeForItemAt:))) {
                        itemSize = delagteFlowLayout.collectionView!(collectionView, layout: self, sizeForItemAt: indexPath)
                        
                        if selectedIndexPath == indexPath {
                            layoutAttribute.frame.size = CGSize(width: itemSize.width * selectedCellExpandPercentage.width, height: itemSize.height * selectedCellExpandPercentage.width)
                        }
                        else {
                            layoutAttribute.frame.size = itemSize
                        }
                    }
                }
                
                // Calculate the proper layout for each cases
                switch layoutType {
                case .vertical, .centralizedVertical:
                    if layoutType == .centralizedVertical {
                        // Check if the cell can be placed in the same row. If not, then increase Y position for height related values and update frame
                        availableWidth -= layoutAttribute.frame.size.width
                        
                        // Remove padding only if it's not a first cell
                        if itemIndex != 0 {
                            availableWidth -= defaultInterItemSpacing
                        }
                        
                        if availableWidth >= 0 {
                            // Loop through all attributes in reverse order to identify attribute that is in same row. Then reposition all attributes centered and place the current attribute again
                            for attribute in layoutAttributes.reversed() {
                                if attribute.frame.origin.y != startYPosition {
                                    break
                                }
                                
                                // Adjust the attribute that lie in same line so as to make it center aligned
                                attribute.frame.origin.x -= (defaultInterItemSpacing + layoutAttribute.frame.size.width) / 2
                            }
                            
                            // If not first index, then get X value of last attribute and add spacing to get next X position. Else get X position w.r.t collectionView width
                            if itemIndex != 0 {
                                startXPosition = layoutAttributes.last!.frame.maxX + defaultInterItemSpacing
                            }
                            else {
                                startXPosition = (collectionView.bounds.size.width - layoutAttribute.frame.size.width) / 2
                            }
                        }
                        else {
                            // Move to next row and set necessary values
                            availableWidth = collectionView.bounds.size.width - defaultSectionInsets.left - defaultSectionInsets.right - layoutAttribute.frame.size.width
                            startXPosition = (collectionView.bounds.size.width - layoutAttribute.frame.size.width) / 2
                            startYPosition = maxContentHeight + defaultLineSpacing
                        }
                    }
                    else {
                        if (startXPosition + defaultInterItemSpacing + layoutAttribute.frame.size.width + defaultSectionInsets.right) <= collectionView.bounds.size.width {
                            // Add spacing only if it's not a first cell
                            if itemIndex != 0 {
                                startXPosition += defaultInterItemSpacing
                            }
                        }
                        else {
                            startXPosition = defaultSectionInsets.left
                            startYPosition = maxContentHeight + defaultLineSpacing
                        }
                    }
                    
                    // Update frame origin using the value methods
                    layoutAttribute.frame.origin = CGPoint(x: startXPosition, y: startYPosition)
                    startXPosition = layoutAttribute.frame.maxX
                    
                    // Get max height for collectionView
                    maxContentHeight = max(maxContentHeight, layoutAttribute.frame.maxY)
                    
                    // If the item is the last item, then add the bottom insets for the section
                    if itemIndex == (collectionView.numberOfItems(inSection: sectionIndex) - 1) {
                        maxContentHeight += defaultSectionInsets.bottom
                        startYPosition = maxContentHeight
                    }
                    
                    // Width doesn't increase here
                    maxContentWidth = collectionView.bounds.size.width
                case .horizontal, .centralizedHorizontal:
                    if layoutType == .centralizedHorizontal {
                        // Check if the cell can be placed in the same column. If not, then increase X position for width related values and update frame
                        availableHeight -= layoutAttribute.frame.size.height
                        
                        // Remove padding only if it's not a first cell
                        if itemIndex != 0 {
                            availableHeight -= defaultInterItemSpacing
                        }
                        
                        if availableHeight >= 0 {
                            // Loop through all attributes in reverse order to identify attribute that is in same column. Then reposition all attributes centered and place the current attribute again
                            for attribute in layoutAttributes.reversed() {
                                if attribute.frame.origin.x != startXPosition {
                                    break
                                }
                                
                                // Adjust the attribute that lie in same line so as to make it center aligned
                                attribute.frame.origin.y -= (defaultInterItemSpacing + layoutAttribute.frame.size.height) / 2
                            }
                            
                            // If not first index, then get Y value of last attribute and add spacing to get next Y position. Else get Y position w.r.t collectionView height
                            if itemIndex != 0 {
                                startYPosition = layoutAttributes.last!.frame.maxY + defaultInterItemSpacing
                            }
                            else {
                                startYPosition = (adjustedCollectionViewHeight - layoutAttribute.frame.size.height) / 2
                            }
                        }
                        else {
                            // Move to next column and set necessary values
                            availableHeight = adjustedCollectionViewHeight - defaultSectionInsets.top - defaultSectionInsets.bottom - layoutAttribute.frame.size.height
                            startYPosition = (adjustedCollectionViewHeight - layoutAttribute.frame.size.height) / 2
                            startXPosition = maxContentWidth + defaultLineSpacing
                        }
                    }
                    else {
                        // Check if the cell can be placed in the same column. If not, then increase X position for width related values and update frame
                        if (startYPosition + defaultInterItemSpacing + layoutAttribute.frame.size.height + defaultSectionInsets.bottom) <= adjustedCollectionViewHeight {
                            // Add spacing only if it's not a first cell
                            if itemIndex != 0 {
                                startYPosition += defaultInterItemSpacing
                            }
                        }
                        else {
                            startYPosition = defaultSectionInsets.top
                            startXPosition = maxContentWidth + defaultLineSpacing
                        }
                    }
                    
                    // Update frame origin
                    layoutAttribute.frame.origin = CGPoint(x: startXPosition, y: startYPosition)
                    startYPosition = layoutAttribute.frame.maxY
                    
                    // Get max width for collectionView
                    maxContentWidth = max(maxContentWidth, layoutAttribute.frame.maxX)
                    
                    // If the item is the last item, then add the bottom insets for the section
                    if itemIndex == (collectionView.numberOfItems(inSection: sectionIndex) - 1) {
                        maxContentWidth += defaultSectionInsets.right
                        startXPosition = maxContentWidth
                    }
                    
                    // Height doesn't increase here
                    maxContentHeight = adjustedCollectionViewHeight
                case .circular:
                    // Since max content width would be diameter of circle + left and right section insets + cell's size (left and right cell will be clipped to half since placed at center)
                    maxContentWidth = 2 * circularRadius + layoutAttribute.frame.size.width + defaultSectionInsets.left + defaultSectionInsets.right
                    
                    // Since max content height would be diameter of circle + top and bottom section insets + cell's size (top and bottom cell will be clipped to half since placed at center)
                    maxContentHeight = 2 * circularRadius + layoutAttribute.frame.size.height + defaultSectionInsets.top + defaultSectionInsets.bottom
                    
                    // If the selected index path is the same as the current index path, then the cell is expanded. So get the increased size to calculate padding
                    let increasedPaddingSize: CGSize = CGSize(width: (layoutAttribute.frame.size.width - itemSize.width) / 2, height: (layoutAttribute.frame.size.height - itemSize.height) / 2)
                    
                    // Calculate the position for the layout attribute
                    let actualAngle = CGFloat(itemIndex) * angle
                    let xPositionPadding = circularRadius + defaultSectionInsets.left - increasedPaddingSize.width
                    let yPositionPadding = circularRadius + defaultSectionInsets.top - increasedPaddingSize.height
                    layoutAttribute.frame.origin = CGPoint(x: xPositionPadding + circularRadius * cos(actualAngle), y: yPositionPadding + circularRadius * sin(actualAngle))
                }
                
                layoutAttributes.append(layoutAttribute)
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var matchingLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in layoutAttributes {
            if attribute.frame.intersects(rect) {
                matchingLayoutAttributes.append(attribute)
            }
        }
        
        return matchingLayoutAttributes
    }
}

