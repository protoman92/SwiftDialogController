//
//  RatioConstantDialogViewType.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 5/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

/// This preset is a mix of long-side constant and short-side ratio. This is
/// the most sensible mix because it offers a nicely fitted view against the
/// master view.
public protocol RatioConstantDialogViewType:
    LongSideConstantDialogViewType,
    ShortSideRatioDialogViewType {}

public extension RatioConstantDialogViewType {
    
    /// Get all padding constant constraints. We add centerX and centerY
    /// constraints as well to place this view in the middle of the parent
    /// view.
    ///
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func ratioConstantConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        let long = longConstantConstraints(for: parent, for: child)
        let short = shortRatioConstraints(for: parent, for: child)
        let center = centerConstraints(for: parent, for: child)
        return long + short + center
    }
}
