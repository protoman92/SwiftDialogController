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
    /// horizontal padding, while in landscape mode, vertical padding.
    var longSidePadding: CGFloat { get }
}

/// Preset DialogViewType that requires short-side paddings.
///
/// UIView instances that implement this protocol will be equally distant
/// from the parent view by the padding values.
@objc public protocol ShortSidePaddingDialogViewType: DialogViewType {
    
    /// Padding against the short side. In portrait mode, this represents
    /// vertical padding, while in landscape mode, horizontal padding.
    var shortSidePadding: CGFloat { get }
}

public extension LongSidePaddingDialogViewType {
    
    /// Get an Array of NSLayoutConstraint to attach to the parent view, based
    /// on the current orientation.
    ///
    /// - Parameters:
    ///   - parent: The parent UIView instance.
    ///   - child: The child UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    public func longSideconstraint(forParent parent: UIView,
                                   andChild child: UIView)
        -> [NSLayoutConstraint]
    {
        let constant = longSidePadding
        let orientation = self.orientation
        let firstAttribute = orientation.longSidePaddingFirstAttribute
        let secondAttribute = orientation.longSidePaddingSecondAttribute
        
        return [
            NSLayoutConstraint(item: child,
                               attribute: firstAttribute,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: firstAttribute,
                               multiplier: 1,
                               constant: constant),
            NSLayoutConstraint(item: parent,
                               attribute: secondAttribute,
                               relatedBy: .equal,
                               toItem: child,
                               attribute: secondAttribute,
                               multiplier: 1,
                               constant: constant)
        ]
    }
}

public extension ShortSidePaddingDialogViewType {
    
    /// Get an Array of NSLayoutConstraint to attach to the parent view, based
    /// on the current orientation.
    ///
    /// - Parameters:
    ///   - parent: The parent UIView instance.
    ///   - child: The child UIView instance.
    /// - Returns: An Array of NSLayoutConstraint.
    public func shortSideconstraint(forParent parent: UIView,
                                    andChild child: UIView)
        -> [NSLayoutConstraint]
    {
        let constant = shortSidePadding
        let orientation = self.orientation
        let firstAttribute = orientation.shortSidePaddingFirstAttribute
        let secondAttribute = orientation.shortSidePaddingSecondAttribute
        
        return [
            NSLayoutConstraint(item: child,
                               attribute: firstAttribute,
                               relatedBy: .equal,
                               toItem: parent,
                               attribute: firstAttribute,
                               multiplier: 1,
                               constant: constant),
            NSLayoutConstraint(item: parent,
                               attribute: secondAttribute,
                               relatedBy: .equal,
                               toItem: child,
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

public extension PaddingDialogViewType where Self: UIView {
    
    /// Get an Array of ViewBuilderComponentType based on long-side and
    /// short-side padding values.
    ///
    /// - Parameter view: The view to be attached to.
    /// - Returns: An Array of ViewBuilderComponentType.
    public func builderComponents(for view: UIView) -> [ViewBuilderComponentType] {
        return []
    }
}

public class UITestView: UIView, PaddingDialogViewType {
    /// Padding against the short side. In portrait mode, this represents
    /// vertical padding, while in landscape mode, horizontal padding.
    public let shortSidePadding: CGFloat = 0
    
    public let longSidePadding: CGFloat = 0
    
    public let orientationDetector: OrientationDetectorType
    
    public required init(withOrientationDetector detector: OrientationDetectorType) {
        self.orientationDetector = detector
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
