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
        case .landscape: return .top
        case .portrait: return .left
        }
    }
    
    /// Get the long side's second attribute to be used for creating layout
    /// constraints for padding constraints.
    public var longSidePaddingSecondAttribute: NSLayoutAttribute {
        switch self {
        case .landscape: return .bottom
        case .portrait: return .right
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

/// Preset DialogViewType that requires long-side paddings.
///
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol LongSidePaddingDialogViewType: DialogViewType {
    
    /// Padding against the long size. In portrait mode, this represents
    /// vertical padding, while in landscape mode, horizontal padding.
    var longSidePadding: CGFloat { get }
}

/// Preset DialogViewType that requires short-side paddings.
///
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol ShortSidePaddingDialogViewType: DialogViewType {
    
    /// Padding against the short side. In portrait mode, this represents
    /// horizontal padding, while in landscape mode, vertical padding.
    var shortSidePadding: CGFloat { get }
}

public extension LongSidePaddingDialogViewType where Self: UIView {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func longPaddingConstraints(for parent: UIView)
        -> [NSLayoutConstraint]
    {
        let constant = longSidePadding
        let orientation = self.orientation
        let firstAttribute = orientation.longSidePaddingFirstAttribute
        let secondAttribute = orientation.longSidePaddingSecondAttribute
        
        return [
            NSLayoutConstraint(item: self,
                               attribute: firstAttribute,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: firstAttribute,
                               multiplier: 1,
                               constant: constant),
            NSLayoutConstraint(item: parent,
                               attribute: secondAttribute,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: secondAttribute,
                               multiplier: 1,
                               constant: constant)
        ]
    }
}

public extension ShortSidePaddingDialogViewType where Self: UIView {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func shortPaddingConstraints(for parent: UIView)
        -> [NSLayoutConstraint]
    {
        let constant = shortSidePadding
        let orientation = self.orientation
        let firstAttribute = orientation.shortSidePaddingFirstAttribute
        let secondAttribute = orientation.shortSidePaddingSecondAttribute
        
        return [
            NSLayoutConstraint(item: self,
                               attribute: firstAttribute,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: firstAttribute,
                               multiplier: 1,
                               constant: constant),
            NSLayoutConstraint(item: parent,
                               attribute: secondAttribute,
                               relatedBy: .equal,
                               toItem: self,
                               attribute: secondAttribute,
                               multiplier: 1,
                               constant: constant)
        ]
    }
}

/// Preset DialogViewType that requires long-side and short-side paddings.
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol PaddingDialogViewType:
    LongSidePaddingDialogViewType,
    ShortSidePaddingDialogViewType {}

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
            .add(constraints: view.longPaddingConstraints(for: self))
            .add(constraints: view.shortPaddingConstraints(for: self))
            .build()
        
        self.populateSubviews(from: [component])
    }
}
