//
//  PaddingConstantDialogViewType.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 5/2/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

/// This preset is a mix of long-side constant and short-side padding. This is
/// the most sensible mix because it offers a nicely fitted view against the
/// master view.
public protocol PaddingConstantDialogViewType:
    LongSideConstantDialogViewType,
    ShortSidePaddingDialogViewType {}

public extension PaddingConstantDialogViewType {
    
    /// Get all padding constant constraints. We add centerX and centerY
    /// constraints as well to place this view in the middle of the parent
    /// view.
    ///
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    /// - Returns: An Array of NSLayoutConstraint.
    public func paddingConstantConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        let long = longConstantConstraints(for: parent, for: child)
        let short = shortPaddingConstraints(for: parent, for: child)
        let center = centerConstraints(for: parent, for: child)
        return long + short + center
    }
}
