//
//  DialogViewType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities

/// Implement this protocol to provide identifiers for centerX and centerY
/// constraints.
@objc public protocol CenterConstraintsIdentifierType {}

public extension CenterConstraintsIdentifierType {
    
    /// Identifier for center X constraint.
    public var centerXIdentifier: String { return "dialogCenterX" }
    
    /// Identifier for center Y constraint.
    public var centerYIdentifier: String { return "dialogCenterY" }
}

/// UIView subclasses that implement this protocol can be added to
/// UIDialogViewController.
@objc public protocol DialogViewType: class, CenterConstraintsIdentifierType {
    
    /// Should be weakly referenced since this is a class-bound protocol.
    weak var orientationDetector: OrientationDetectorType? { get }
    
    /// Check if the dialog view should update its constraints when app
    /// orientation changes. E.g. long side becomes short side, so long-side
    /// constraints are now applied differently.
    @objc optional var updateConstraintsOnOrientationChanged: Bool { get }
    
    /// This is a small tradeoff - instead of declaring constraints in each
    /// protocol, we can have the views that implement DialogViewType to
    /// declare their own constraints, so that we can use them to add common
    /// methods via extension.
    ///
    
    /// The alternative is having to redeclare methods such as
    /// populateSubviews(with:) and screenOrientationDidChange(to:) in each
    /// sub view type.
    ///
    /// - Parameters:
    ///   - parent: The parent UIView.
    ///   - child: The child UIView.
    func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    
    init(withDetector detector: OrientationDetectorType)
}

public extension DialogViewType {
    
    /// Get the current orientation.
    public var orientation: BasicOrientation {
        return orientationDetector?.orientation ?? .portrait
    }
    
    /// Create centerX and centerY constraints to attach to the parent view.
    ///
    /// - Parameters:
    ///   - parent: The parent UIView instance.
    ///   - child: An Array of NSLayoutConstraint.
    /// - Returns: An Array of NSLayoutConstraint.
    public func centerConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        let x = NSLayoutConstraint(item: child,
                                   attribute: .centerX,
                                   relatedBy: .equal,
                                   toItem: parent,
                                   attribute: .centerX,
                                   multiplier: 1,
                                   constant: 0)
        
        let y = NSLayoutConstraint(item: child,
                                   attribute: .centerY,
                                   relatedBy: .equal,
                                   toItem: parent,
                                   attribute: .centerY,
                                   multiplier: 1,
                                   constant: 0)
        
        x.identifier = centerXIdentifier
        y.identifier = centerYIdentifier
        return [x, y]
    }
}

public extension DialogViewType where Self: UIView {
    
    /// Change constraints on screen orientation changes.
    ///
    /// - Parameter orientation: The new screen orientation.
    public func screenOrientationDidChange(to orientation: BasicOrientation) {
        guard
            updateConstraintsOnOrientationChanged ?? true,
            let superview = self.superview
        else {
            return
        }
        
        let allConstraints = superview.constraints + self.constraints
        let newConstraints = dialogConstraints(for: superview, for: self)
        let identifiers = newConstraints.flatMap({$0.identifier})
        
        let oldConstraints = identifiers.flatMap({identifier in
            allConstraints.filter({$0.identifier == identifier}).first
        })

        superview.removeConstraints(oldConstraints)
        removeConstraints(oldConstraints)
        superview.addConstraints(newConstraints.filter({!$0.isDirectConstraint}))
        addConstraints(newConstraints.filter({$0.isDirectConstraint}))
    }
}
