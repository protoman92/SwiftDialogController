//
//  UITestDialogController.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import SwiftUIUtilitiesTests
import SwiftUtilitiesTests
import UIKit
@testable import SwiftDialogController

class Presenter: UIDialogController.DialogPresenter {
    let fake_dismiss = FakeDetails.builder().build()
    
    required init<P: UIDialogController>(view: P) {
        super.init(view: view)
    }
    
    override func dismiss(dialog: UIViewController?) {
        fake_dismiss.onMethodCalled(withParameters: dialog)
        super.dismiss(dialog: dialog)
    }
}

/// Superficial implementation to allow calls to viewWillTransition(to:with:).
extension UIDialogController.DialogPresenter: UIViewControllerTransitionCoordinator {
    @available(iOS 8.0, *)
    public var targetTransform: CGAffineTransform {
        return CGAffineTransform()
    }

    @available(iOS 2.0, *)
    public var containerView: UIView {
        return UIView()
    }
    
    @available(iOS 8.0, *)
    public func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return nil
    }

    @available(iOS 2.0, *)
    public func viewController(
        forKey key: UITransitionContextViewControllerKey
    ) -> UIViewController? {
        return nil
    }

    public var completionCurve: UIViewAnimationCurve {
        return .easeIn
    }

    public var completionVelocity: CGFloat {
        return 0
    }

    public var percentComplete: CGFloat {
        return 0
    }

    public var transitionDuration: TimeInterval {
        return 0
    }

    public var isCancelled: Bool {
        return true
    }

    public var isInteractive: Bool {
        return true
    }

    public var initiallyInteractive: Bool {
        return true
    }

    public var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    public var isAnimated: Bool { return true }
    
    @available(iOS 10.0, *)
    public var isInterruptible: Bool {
        return true
    }

    public func animate(
        alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
        completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil
    ) -> Bool {
        return true
    }
    
    public func animateAlongsideTransition(
        in view: UIView?,
        animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
        completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil
    ) -> Bool {
        return true
    }
    
    @available(iOS,
    introduced: 7.0,
    deprecated: 10.0,
    message: "Use notifyWhenInteractionChangesUsingBlock")
    public func notifyWhenInteractionEnds(
        _ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void
    ) {}
    
    @available(iOS 10.0, *)
    public func notifyWhenInteractionChanges(
        _ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void
    ) {}
}
