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

public extension LongSidePaddingDialogViewType {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    /// - Parameters:
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func longPaddingConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        let constant = longSidePadding
        let orientation = self.orientation
        let firstAttribute = orientation.longSidePaddingFirstAttribute
        let secondAttribute = orientation.longSidePaddingSecondAttribute
        
        let firstConstraint = NSLayoutConstraint(item: child,
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
                                                  toItem: child,
                                                  attribute: secondAttribute,
                                                  multiplier: 1,
                                                  constant: constant)
        
        secondConstraint.identifier = longSidePaddingSecondAttribute
        
        return [firstConstraint, secondConstraint]
    }
}

public extension ShortSidePaddingDialogViewType {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func shortPaddingConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        let constant = shortSidePadding
        let orientation = self.orientation
        let firstAttribute = orientation.shortSidePaddingFirstAttribute
        let secondAttribute = orientation.shortSidePaddingSecondAttribute
        
        let firstConstraint = NSLayoutConstraint(item: child,
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
                                                  toItem: child,
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

public extension PaddingDialogViewType {
    
    /// Get all padding constraints.
    ///
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func paddingConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        let long = longPaddingConstraints(for: parent, for: child)
        let short = shortPaddingConstraints(for: parent, for: child)
        return long + short
    }
}
