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
    
    /// Get the long side's attribute to be used for creating layout 
    /// constraints for padding constraints.
    public var longSideRatioAttribute: NSLayoutAttribute {
        switch self {
        case .landscape: return .width
        case .portrait: return .height
        }
    }
    
    /// Get the short side's attribute to be used for creating layout
    /// constraints for padding constraints.
    public var shortSideRatioAttribute: NSLayoutAttribute {
        return oppositeOrientation.longSideRatioAttribute
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
        let longSideRatio = self.longSideRatio
        let multiplier = longSideRatio > 0 ? longSideRatio : 1
        let orientation = self.orientation
        let attribute = orientation.longSideRatioAttribute
        
        return [
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: attribute,
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
        let shortSideRatio = self.shortSideRatio
        let multiplier = shortSideRatio > 0 ? shortSideRatio : 1
        let orientation = self.orientation
        let attribute = orientation.shortSideRatioAttribute
        
        return [
            NSLayoutConstraint(item: self,
                               attribute: attribute,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: attribute,
                               multiplier: multiplier,
                               constant: 0)
        ]
    }
}

/// Preset DialogViewType that requires long-side and short-side ratios.
@objc public protocol RatioDialogViewType:
    LongSideRatioDialogViewType,
    ShortSideRatioDialogViewType {}

public extension RatioDialogViewType where Self: UIView {
    
    /// Get all ratio constraints. We add a centerX and centerY constraints
    /// to place this view directly in the middle of the parent UIView.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func ratioConstraints(for parent: UIView) -> [NSLayoutConstraint] {
        let long = longRatioConstraints(for: parent)
        let short = shortRatioConstraints(for: parent)
        var constraints = long + short
        
        constraints.append(
            NSLayoutConstraint(item: self,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0)
        )
        
        constraints.append(
            NSLayoutConstraint(item: self,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .centerY,
                               multiplier: 1,
                               constant: 0)
        )
        
        return constraints
    }
}

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
            .with(constraints: view.ratioConstraints(for: self))
            .build()
        
        self.populateSubviews(from: [component])
    }
}
