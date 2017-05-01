//
//  RatioPaddingDialogViewType.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 5/1/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUtilities
import UIKit

/// Use this class to build views for RatioPaddingDialogViewType.
open class RatioPaddingDialogViewBuilder: DialogViewBuilder {
    
    /// Get an Array of NSLayoutConstraint to be added to a UIView.
    ///
    /// - Parameter view: The parent UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    override open func constraints(for view: UIView) -> [NSLayoutConstraint] {
        var constraints = super.constraints(for: view)
        
        guard let dialog = dialog as? RatioPaddingDialogViewType else {
            debugException()
            return constraints
        }
        
        let rpc = dialog.ratioPaddingConstraints(for: view, for: dialogView)
        constraints.append(contentsOf: rpc)
        return constraints
    }
}
