//
//  UIDialogController.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import RxSwift
import SwiftBaseViews
import SwiftUtilities
import SwiftUIUtilities
import UIKit

/// Implement this protocol to provide presenter inrerface for dialogs.
public protocol DialogPresenterType {
    init(view: UIDialogController)
}

/// Dialogs are view controllers that can be presented on top of the current
/// view controller, and usually floats over it.
open class UIDialogController: UIBaseViewController {
    override open var presenterInstance: ViewControllerPresenterType? {
        return presenter
    }
    
    /// UIDialogController subclasses can provide their own Presenter types
    /// by overriding this variable. We initialize a presenter here because
    /// this class itself is sufficient to be used for displaying dialogs, so
    /// we don't expect to create subclasses for this purpose.
    ///
    /// In case we do use subclasses, cast the presenter here to the 
    /// appropriate types.
    open var dialogPresenterType: DialogPresenter.Type {
        return DialogPresenter.self
    }
    
    var backgroundButton: UIButton? {
        return view?.subviews.filter({
            $0.accessibilityIdentifier == backgroundButtonId
        }).first as? UIButton
    }
    
    public lazy var presenter: DialogPresenter = self.dialogPresenterType.init(view: self)
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        modalTransitionStyle = .crossDissolve
    }
}

open class DialogPresenter: BaseViewControllerPresenter {
    public override required init<P: UIDialogController>(view: P) {
        super.init(view: view)
    }
    
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
        button.alpha = 0.6
        button.backgroundColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        
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
        where V: UIView, V: DialogViewType
    {
        let builder = DialogViewBuilder(view: view, dialog: view)
        controller.view?.populateSubviews(with: builder)
        
        // When screen size changes, change constraints for this dialog
        // view as well.
        rxScreenOrientation 
            .doOnNext({[weak view] in
                view?.screenOrientationDidChange(to: $0)
            })
            .subscribe()
            .addDisposableTo(disposeBag)
    }
    
    open func add(view: DialogViewType) {}

    /// Dismiss the currently displayed dialog.
    ///
    /// - Parameter dialog: The current dialog controller.
    func dismiss(dialog: UIViewController?) {
        dialog?.dismiss(animated: true, completion: nil)
    }
}

extension UIDialogController: DialogIdentifierType {}
extension DialogPresenter: DialogIdentifierType {}
extension DialogPresenter: DialogPresenterType {}

public extension UIDialogController {
    
    /// Add a DialogViewType instance to the master view.
    ///
    /// - Parameter view: A DialogViewType instance.
    public func add<V>(view: V) where V:UIView, V: DialogViewType {
        presenter.add(view: view, for: self)
    }
}

public extension ControllerPresentableType {
    
    /// Present a UIDialogController subclass instance.
    ///
    /// - Parameters:
    ///   - dialog: A UIDialogController instance.
    ///   - animated: A Bool value.
    ///   - completion: Completion closure.
    public func present<D>(dialog: D, animated: Bool, completion: (() -> Void)?)
        where D: UIDialogController
    {
        // We need to set these values in order for the dialog to have a
        // transparent background.
        dialog.modalPresentationStyle = .overFullScreen
        dialog.modalTransitionStyle = .crossDissolve
        presentController(dialog, animated: animated, completion: completion)
    }
}
