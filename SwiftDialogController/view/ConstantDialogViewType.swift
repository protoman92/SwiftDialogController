//
//  ConstantDialogViewType.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 5/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

public extension BasicOrientation {
    
    /// Get the long side's attribute to be used for creating layout
    /// constraints for constant constraints.
    public var longSideConstantAttribute: NSLayoutAttribute {
        switch self {
        case .landscape: return .width
        case .portrait: return .height
        }
    }
    
    /// Get the short side's attribute to be used for creating layout
    /// constraints for padding constraints.
    public var shortSideConstantAttribute: NSLayoutAttribute {
        return oppositeOrientation.longSideRatioAttribute
    }
}

@objc public protocol LongSideConstantIdentifierType {}

public extension LongSideConstantIdentifierType {
    
    /// Identifier for long-side attribute constraint.
    public var longSideConstantAttribute: String {
        return "longSideConstantAttribute"
    }
}

/// Views that implement this protocol must provide concrete constant value
/// for the long-side constraint, i.e. width in landscape mode and height
/// in portrait mode.
public protocol LongSideConstantDialogViewType:
    DialogViewType,
    LongSideConstantIdentifierType
{
    /// Provide the long-side constant.
    var longSideConstant: CGFloat { get }
}

public extension LongSideConstantDialogViewType {
    
    /// Get an Array of NSLayoutConstraint for a parent/child view pair.
    ///
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func longConstantConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        let longSideConstant = self.longSideConstant
        let orientation = self.orientation
        let attribute = orientation.longSideConstantAttribute
        
        let constraint = NSLayoutConstraint(item: child,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: longSideConstant)
        
        constraint.identifier = longSideConstantAttribute
        
        return [constraint]
    }
}
