//
//  RatioPaddingDialogViewType.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

/// This preset is a mix of long-side ratio and short-side padding. This is
/// the most sensible mix because it offers a nicely fitted view against the
/// master view.
public protocol RatioPaddingDialogViewType:
    LongSideRatioDialogViewType,
    ShortSidePaddingDialogViewType {}

public extension RatioPaddingDialogViewType {
    
    /// Get all ratio padding constraints. We add centerX and centerY
    /// constraints as well to place this view in the middle of the parent
    /// view.
    ///
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func ratioPaddingConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        let long = longRatioConstraints(for: parent, for: child)
        let short = shortPaddingConstraints(for: parent, for: child)
        var constraints = long + short
        
        constraints.append(
            NSLayoutConstraint(item: child,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: .centerX,
                               multiplier: 1,
                               constant: 0)
        )
        
        constraints.append(
            NSLayoutConstraint(item: child,
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

public extension RatioPaddingDialogViewType where Self: UIView {

    /// Change constraints on screen orientation changes.
    ///
    /// - Parameter orientation: The new screen orientation.
    public func screenOrientationDidChange(to orientation: BasicOrientation) {
        guard let superview = self.superview else {
            return
        }
        
        let allConstraints = superview.constraints
        let newConstraints = ratioPaddingConstraints(for: superview, for: self)
        let identifiers = newConstraints.flatMap({$0.identifier})
        
        let oldConstraints = identifiers.flatMap({identifier in
            allConstraints.filter({$0.identifier == identifier}).first
        })
        
        superview.removeConstraints(oldConstraints)
        superview.addConstraints(newConstraints)
    }
}

public extension UIView {
    
    /// Convenient method to add a DialogViewType to another view, since
    /// we cannot extend RatioPaddingDialogViewType to automatically implement
    /// builderComponents(for:).
    ///
    /// - Parameter view: A RatioPaddingDialogViewType instance.
    public func populateSubview<P>(with view: P)
        where P: UIView, P: RatioPaddingDialogViewType
    {
        let builder = RatioPaddingDialogViewBuilder(view: view, dialog: view)
        populateSubviews(with: builder)
    }
}
