//
//  RatioDialogViewType.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

public extension BasicOrientation {
    
    /// Get the long side's first attribute to be used for creating layout
    /// constraints for padding constraints.
    public var longSideRatioFirstAttribute: NSLayoutAttribute {
        switch self {
        case .landscape: return .width
        case .portrait: return .height
        }
    }
    
    /// Get the long side's second attribute to be used for creating layout
    /// constraints for padding constraints.
    public var longSideRatioSecondAttribute: NSLayoutAttribute {
        switch self {
        case .landscape: return .height
        case .portrait: return .width
        }
    }
    
    /// Get the short side's first attribute to be used for creating layout
    /// constraints for padding constraints.
    public var shortSideRatioFirstAttribute: NSLayoutAttribute {
        return oppositeOrientation.longSidePaddingFirstAttribute
    }
    
    /// Get the short side's second attribute to be used for creating layout
    /// constraints for padding constraints.
    public var shortSideRatioSecondAttribute: NSLayoutAttribute {
        return oppositeOrientation.longSidePaddingSecondAttribute
    }
}

/// Preset DialogViewType that requires long-side ratio.
///
/// UIView instances that implement this protocol will be have its long side
/// be a proportion of the parent view's long side.
@objc public protocol LongSideRatioDialogViewType: DialogViewType {
    
    /// Ratio against the long size. In portrait mode, this represents
    /// vertical ratio, while in landscape mode, horizontal ratio.
    var longSideRatio: CGFloat { get }
}

/// Preset DialogViewType that requires short-side ratio.
///
/// UIView instances that implement this protocol will be have its short side
/// be a proportion of the parent view's long side.
@objc public protocol ShortSideRatioDialogViewType: DialogViewType {
    
    /// Ratio against the short size. In portrait mode, this represents
    /// horizontal ratio, while in landscape mode, vertical ratio.
    var shortSideRatio: CGFloat { get }
}

public extension LongSideRatioDialogViewType where Self: UIView {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func longRatioConstraints(for parent: UIView)
        -> [NSLayoutConstraint]
    {
        let multiplier = longSideRatio
        let orientation = self.orientation
        let firstAttribute = orientation.longSideRatioFirstAttribute
        let secondAttribute = orientation.longSideRatioSecondAttribute
        
        return [
            NSLayoutConstraint(item: self,
                               attribute: firstAttribute,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: firstAttribute,
                               multiplier: multiplier,
                               constant: 0),
            NSLayoutConstraint(item: parent,
                               attribute: secondAttribute,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: secondAttribute,
                               multiplier: multiplier,
                               constant: 0)
        ]
    }
}

public extension ShortSideRatioDialogViewType where Self: UIView {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func shortRatioConstraints(for parent: UIView)
        -> [NSLayoutConstraint]
    {
        let multiplier = shortSideRatio
        let orientation = self.orientation
        let firstAttribute = orientation.shortSideRatioFirstAttribute
        let secondAttribute = orientation.shortSideRatioSecondAttribute
        
        return [
            NSLayoutConstraint(item: self,
                               attribute: firstAttribute,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: firstAttribute,
                               multiplier: multiplier,
                               constant: 0),
            NSLayoutConstraint(item: parent,
                               attribute: secondAttribute,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: secondAttribute,
                               multiplier: multiplier,
                               constant: 0)
        ]
    }
}

/// Preset DialogViewType that requires long-side and short-side ratios.
@objc public protocol RatioDialogViewType:
    LongSideRatioDialogViewType,
    ShortSideRatioDialogViewType {}

public extension UIView {
    
    /// Convenient method to add a DialogViewType to another view, since
    /// we cannot extend RatioDialogViewType to automatically implement
    /// builderComponents(for:).
    ///
    /// - Parameter view: A RatioDialogViewType instance.
    public func populateSubview<P>(with view: P)
        where P: UIView, P: RatioDialogViewType
    {
        let component = ViewBuilderComponent.builder()
            .with(view: view)
            .add(constraints: view.longRatioConstraints(for: self))
            .add(constraints: view.shortRatioConstraints(for: self))
            .build()
        
        self.populateSubviews(from: [component])
    }
}
