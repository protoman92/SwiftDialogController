//
//  DialogViewBuilder.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 5/1/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit

/// Implement this protocol to provide builder for DialogViewType.
@objc public protocol DialogViewBuilderType: ViewBuilderType {
    
    /// Initialize with a DialogViewType instance.
    init(view: UIView, dialog: DialogViewType)
    
    /// Get the UIView that was initialized above.
    var dialogView: UIView { get }
    
    /// Get the DialogViewType that was initialized above.
    var dialog: DialogViewType { get }
}

open class DialogViewBuilder {
    public let dialogView: UIView
    public let dialog: DialogViewType
    
    public required init(view: UIView, dialog: DialogViewType) {
        self.dialogView = view
        self.dialog = dialog
    }
    
    // MARK: ViewBuilderType.
    
    /// Get an Array of UIView subviews to be added to a UIView.
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of ViewBuilderComponentType.
    open func subviews(for view: UIView) -> [UIView] {
        return [dialogView]
    }
    
    /// Get an Array of NSLayoutConstraint to be added to a UIView.
    ///
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    open func constraints(for view: UIView) -> [NSLayoutConstraint] {
        return dialog.dialogConstraints(for: view, for: dialogView)
    }
    
    // MARK: ViewBuilderConfigType.
    
    /// Configure the current UIView, after populating it with a
    /// ViewBuilderType.
    ///
    /// - Parameter view: The UIView to be configured.
    open func configure(for view: UIView) {}
}

extension DialogViewBuilder: DialogViewBuilderType {}
