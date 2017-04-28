//
//  DialogPresentableType.swift
//  TestApplication
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit

/// Implement this protocol to present dialog controllers. We shall introduce
/// a custom present(viewControllerToPresent:animated:completion:) method in
/// order to simulate dialog appearance.
public protocol DialogPresentableType: class {
    
    /// Present a UIViewController instance.
    ///
    /// - Parameters:
    ///   - viewController: The UIViewController to be presented.
    ///   - animated: A Bool value.
    ///   - completion: Completion closure.
    func present(_ viewController: UIViewController,
                 animated: Bool,
                 completion: (() -> Void)?)
}

public extension DialogPresentableType {
    
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
        present(dialog, animated: animated, completion: completion)
    }
}

extension UIViewController: DialogPresentableType {}
