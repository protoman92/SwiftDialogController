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

class UITestDialogController: UIDialogController {
    override var presenterInstance: ViewControllerPresenterType? {
        return presenter
    }
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    public class Presenter: UIDialogController.DialogPresenter {
        let fake_dismiss = FakeDetails.builder().build()
        
        override func dismiss(dialog: UIViewController?) {
            fake_dismiss.onMethodCalled(withParameters: dialog)
            super.dismiss(dialog: dialog)
        }
    }
}

/// Superficial implementation to allow calls to viewWillTransition(to:with:).
extension UITestDialogController.Presenter: UIViewControllerTransitionCoordinator {
    @available(iOS 8.0, *)
    public var targetTransform: CGAffineTransform {
        return CGAffineTransform()
    }

    @available(iOS 2.0, *)
    public var containerView: UIView {
        return UIView()
    }
    
    @available(iOS 8.0, *)
    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        return nil
    }

    @available(iOS 2.0, *)
    func viewController(
        forKey key: UITransitionContextViewControllerKey
    ) -> UIViewController? {
        return nil
    }

    var completionCurve: UIViewAnimationCurve {
        return .easeIn
    }

    var completionVelocity: CGFloat {
        return 0
    }

    var percentComplete: CGFloat {
        return 0
    }

    var transitionDuration: TimeInterval {
        return 0
    }

    var isCancelled: Bool {
        return true
    }

    var isInteractive: Bool {
        return true
    }

    var initiallyInteractive: Bool {
        return true
    }

    var presentationStyle: UIModalPresentationStyle {
        return .overCurrentContext
    }

    var isAnimated: Bool { return true }
    
    @available(iOS 10.0, *)
    var isInterruptible: Bool {
        return true
    }

    func animate(
        alongsideTransition animation: ((UIViewControllerTransitionCoordinatorContext) -> Void)?,
        completion: ((UIViewControllerTransitionCoordinatorContext) -> Void)? = nil
    ) -> Bool {
        return true
    }
    
    func animateAlongsideTransition(
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
    func notifyWhenInteractionEnds(
        _ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void
    ) {}
    
    @available(iOS 10.0, *)
    func notifyWhenInteractionChanges(
        _ handler: @escaping (UIViewControllerTransitionCoordinatorContext) -> Void
    ) {}
}
