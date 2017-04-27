//
//  UIDialogController.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import SwiftUtilities
import SwiftUIUtilities
import UIKit

/// Dialogs are view controllers that can be presented on top of the current
/// view controller, and usually floats over it.
open class UIDialogController: UIBaseViewController {
    
    /// UIDialogController subclasses must provide their own Presenter
    /// instances, or else this will throw an error.
    var dialogPresenter: DialogPresenter? {
        return presenterInstance as? DialogPresenter
    }
    
    var backgroundButton: UIButton? {
        return view?.subviews.filter({
            $0.accessibilityIdentifier == backgroundButtonId
        }).first as? UIButton
    }
    
    open class DialogPresenter: BaseViewControllerPresenter {
        override open func viewDidLoad(for controller: UIViewController) {
            super.viewDidLoad(for: controller)
            addDismissButton(for: controller)
        }
        
        /// Add a background button that dismisses the current dialog once 
        /// clicked.
        ///
        /// - Parameter controller: The current UIViewController instance.
        open func addDismissButton(for controller: UIViewController) {
            guard let view = controller.view else {
                debugException()
                return
            }
            
            let button = UIButton()
            button.accessibilityIdentifier = backgroundButtonId
            button.backgroundColor = .darkGray
            
            button.rx.controlEvent(.touchDown)
                .asObservable()
                .doOnNext({[weak self, weak controller] in
                    self?.dismiss(dialog: controller)
                })
                .subscribe()
                .addDisposableTo(disposeBag)
            
            view.addSubview(button)
            view.addFitConstraints(for: button)
        }
        
        /// Add a DialogViewType instance as a subview to the main view.
        ///
        /// - Parameters:
        ///   - view: A DialogViewType instance.
        ///   - controller: The current UIViewController instance.
        open func add<V>(view: V, for controller: UIViewController)
            where V: UIView, V: DialogViewType & ViewBuilderType
        {
            controller.view?.populateSubviews(with: view)
        }
        
        /// Add a PaddingDialogViewType instance as a subview to the main view.
        ///
        /// - Parameters:
        ///   - view: A PaddingDialogViewType instance.
        ///   - controller: The current UIViewController instance.
        open func add<V>(view: V, for controller: UIViewController)
            where V: UIView, V: PaddingDialogViewType
        {
            controller.view?.populateSubview(with: view)
        }
        
        /// Add a RatioDialogViewType instance as a subview to the main view.
        ///
        /// - Parameters:
        ///   - view: A RatioDialogViewType instance.
        ///   - controller: The current UIViewController instance.
        open func add<V>(view: V, for controller: UIViewController)
            where V: UIView, V: RatioDialogViewType
        {
            controller.view?.populateSubview(with: view)
        }
        
        /// Add a RatioPaddingDialogViewType instance as a subview to the main
        /// view.
        ///
        /// - Parameters:
        ///   - view: A RatioPaddingDialogViewType instance.
        ///   - controller: The current UIViewController instance.
        open func add<V>(view: V, for controller: UIViewController)
            where V: UIView, V: RatioPaddingDialogViewType
        {
            controller.view?.populateSubview(with: view)
        }
        
        /// Dismiss the currently displayed dialog.
        ///
        /// - Parameter dialog: The current dialog controller.
        func dismiss(dialog: UIViewController?) {
            dialog?.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIDialogController: DialogIdentifierType {}
extension UIDialogController.DialogPresenter: DialogIdentifierType {}

public extension UIDialogController {
    
    /// Add a DialogViewType instance to the master view.
    ///
    /// - Parameter view: A DialogViewType instance.
    public func add<V>(view: V) where V:UIView, V: DialogViewType & ViewBuilderType {
        dialogPresenter?.add(view: view, for: self)
    }
    
    /// Add a PaddingDialogViewType instance to the master view.
    ///
    /// - Parameter view: A PaddingDialogViewType instance.
    public func add<V>(view: V) where V: UIView, V: PaddingDialogViewType {
        dialogPresenter?.add(view: view, for: self)
    }
    
    /// Add a RatioDialogViewType instance to the master view.
    ///
    /// - Parameter view: A RatioDialogViewType instance.
    public func add<V>(view: V) where V: UIView, V: RatioDialogViewType {
        dialogPresenter?.add(view: view, for: self)
    }
    
    /// Add a RatioPaddingDialogViewType instance to the master view.
    ///
    /// - Parameter view: A RatioPaddingDialogViewType instance.
    public func add<V>(view: V) where V: UIView, V: RatioPaddingDialogViewType {
        dialogPresenter?.add(view: view, for: self)
    }
}
