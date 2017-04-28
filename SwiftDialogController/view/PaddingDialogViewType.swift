//
//  PaddingDialogViewType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

public extension BasicOrientation {
    
    /// Get the long side's first attribute to be used for creating layout
    /// constraints for padding constraints.
    public var longSidePaddingFirstAttribute: NSLayoutAttribute {
        switch self {
        case .landscape: return .left
        case .portrait: return .top
        }
    }
    
    /// Get the long side's second attribute to be used for creating layout
    /// constraints for padding constraints.
    public var longSidePaddingSecondAttribute: NSLayoutAttribute {
        switch self {
        case .landscape: return .right
        case .portrait: return .bottom
        }
    }
    
    /// Get the short side's first attribute to be used for creating layout
    /// constraints for padding constraints.
    public var shortSidePaddingFirstAttribute: NSLayoutAttribute {
        return oppositeOrientation.longSidePaddingFirstAttribute
    }
    
    /// Get the short side's second attribute to be used for creating layout
    /// constraints for padding constraints.
    public var shortSidePaddingSecondAttribute: NSLayoutAttribute {
        return oppositeOrientation.longSidePaddingSecondAttribute
    }
}

/// Implement this protocol to provide constraint identifier.
@objc public protocol LongSidePaddingIdentifierType {}

public extension LongSidePaddingIdentifierType {
    
    /// Identifier for long-side first attribute constraint.
    public var longSidePaddingFirstAttribute: String {
        return "longSidePaddingFirstAttribute"
    }
    
    /// Identifier for long-side second attribute constraint.
    public var longSidePaddingSecondAttribute: String {
        return "longSidePaddingSecondAttribute"
    }
}

/// Implement this protocol to provide constraint identifier.
@objc public protocol ShortSidePaddingIdentifierType {}

public extension ShortSidePaddingIdentifierType {
    
    /// Identifier for short-side first attribute constraint.
    public var shortSidePaddingFirstAttribute: String {
        return "shortSidePaddingFirstAttribute"
    }
    
    /// Identifier for short-side second attribute constraint.
    public var shortSidePaddingSecondAttribute: String {
        return "shortSidePaddingSecondAttribute"
    }
}

/// Preset DialogViewType that requires long-side paddings.
///
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol LongSidePaddingDialogViewType:
    DialogViewType,
    LongSidePaddingIdentifierType
{
    /// Padding against the long size. In portrait mode, this represents
    /// vertical padding, while in landscape mode, horizontal padding.
    var longSidePadding: CGFloat { get }
}

/// Preset DialogViewType that requires short-side paddings.
///
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol ShortSidePaddingDialogViewType:
    DialogViewType,
    ShortSidePaddingIdentifierType
{
    /// Padding against the short side. In portrait mode, this represents
    /// horizontal padding, while in landscape mode, vertical padding.
    var shortSidePadding: CGFloat { get }
}

public extension LongSidePaddingDialogViewType where Self: UIView {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func longPaddingConstraints(for parent: UIView) -> [NSLayoutConstraint] {
        let constant = longSidePadding
        let orientation = self.orientation
        let firstAttribute = orientation.longSidePaddingFirstAttribute
        let secondAttribute = orientation.longSidePaddingSecondAttribute
        
        let firstConstraint = NSLayoutConstraint(item: self,
                                                 attribute: firstAttribute,
                                                 relatedBy: .equal,
                                                 toItem: parent,
                                                 attribute: firstAttribute,
                                                 multiplier: 1,
                                                 constant: constant)
        
        firstConstraint.identifier = longSidePaddingFirstAttribute
        
        let secondConstraint = NSLayoutConstraint(item: parent,
                                                  attribute: secondAttribute,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: secondAttribute,
                                                  multiplier: 1,
                                                  constant: constant)
        
        secondConstraint.identifier = longSidePaddingSecondAttribute
        
        return [firstConstraint, secondConstraint]
    }
}

public extension ShortSidePaddingDialogViewType where Self: UIView {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func shortPaddingConstraints(for parent: UIView) -> [NSLayoutConstraint] {
        let constant = shortSidePadding
        let orientation = self.orientation
        let firstAttribute = orientation.shortSidePaddingFirstAttribute
        let secondAttribute = orientation.shortSidePaddingSecondAttribute
        
        let firstConstraint = NSLayoutConstraint(item: self,
                                                 attribute: firstAttribute,
                                                 relatedBy: .equal,
                                                 toItem: parent,
                                                 attribute: firstAttribute,
                                                 multiplier: 1,
                                                 constant: constant)
        
        firstConstraint.identifier = shortSidePaddingFirstAttribute
        
        let secondConstraint = NSLayoutConstraint(item: parent,
                                                  attribute: secondAttribute,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: secondAttribute,
                                                  multiplier: 1,
                                                  constant: constant)
        
        secondConstraint.identifier = shortSidePaddingSecondAttribute
        
        return [firstConstraint, secondConstraint]
    }
}

/// Preset DialogViewType that requires long-side and short-side paddings.
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol PaddingDialogViewType:
    LongSidePaddingDialogViewType,
    ShortSidePaddingDialogViewType {}

public extension PaddingDialogViewType where Self: UIView {
    
    /// Get all padding constraints.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func paddingConstraints(for parent: UIView) -> [NSLayoutConstraint] {
        let long = longPaddingConstraints(for: parent)
        let short = shortPaddingConstraints(for: parent)
        return long + short
    }
    
    /// Change constraints on screen orientation changes.
    ///
    /// - Parameter orientation: The new screen orientation.
    public func screenOrientationDidChange(to orientation: BasicOrientation) {
        guard let superview = self.superview else {
            return
        }
        
        let allConstraints = superview.constraints
        let paddingConstraints = self.paddingConstraints(for: superview)
        let identifiers = paddingConstraints.flatMap({$0.identifier})
        
        let oldConstraints = identifiers.flatMap({identifier in
            allConstraints.filter({$0.identifier == identifier}).first
        })
        
        superview.removeConstraints(oldConstraints)
        superview.addConstraints(paddingConstraints)
    }
}

public extension UIView {
    
    /// Convenient method to add a DialogViewType to another view, since
    /// we cannot extend PaddingDialogViewType to automatically implement
    /// builderComponents(for:).
    ///
    /// - Parameter view: A PaddingDialogViewType instance.
    public func populateSubview<P>(with view: P)
        where P: UIView, P: PaddingDialogViewType
    {
        let component = ViewBuilderComponent.builder()
            .with(view: view)
            .with(constraints: view.paddingConstraints(for: self))
            .build()
        
        self.populateSubviews(from: [component])
    }
}
