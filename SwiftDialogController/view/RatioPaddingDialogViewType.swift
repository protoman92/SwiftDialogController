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
            .add(constraints: view.longRatioConstraints(for: self))
            .add(constraints: view.shortPaddingConstraints(for: self))
            .build()
        
        self.populateSubviews(from: [component])
    }
}
