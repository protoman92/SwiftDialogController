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

public extension RatioPaddingDialogViewType where Self: UIView {
    
    /// Get all ratio padding constraints. We add centerX and centerY
    /// constraints as well to place this view in the middle of the parent
    /// view.
    ///
    /// - Parameter parent: The parent UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func ratioPaddingConstraints(for parent: UIView) -> [NSLayoutConstraint] {
        let long = longRatioConstraints(for: parent)
        let short = shortPaddingConstraints(for: parent)
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
    
    /// Change constraints on screen orientation changes.
    ///
    /// - Parameter orientation: The new screen orientation.
    public func screenOrientationDidChange(to orientation: BasicOrientation) {
        guard let superview = self.superview else {
            return
        }
        
        let allConstraints = superview.constraints
        let rpConstraints = self.ratioPaddingConstraints(for: superview)
        let identifiers = rpConstraints.flatMap({$0.identifier})
        
        let oldConstraints = identifiers.flatMap({identifier in
            allConstraints.filter({$0.identifier == identifier}).first
        })
        
        superview.removeConstraints(oldConstraints)
        superview.addConstraints(rpConstraints)
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
        let component = ViewBuilderComponent.builder()
            .with(view: view)
            .with(constraints: view.ratioPaddingConstraints(for: self))
            .build()
        
        self.populateSubviews(from: [component])
    }
}
