//
//  UITestDialogController.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities
import UIKit
@testable import SwiftDialogController

class UITestDialogController: UIDialogController {
    override var presenterInstance: ViewControllerPresenterType? {
        return presenter
    }
    
    lazy var presenter: Presenter = Presenter(view: self)
    
    public class Presenter: UIDialogController.DialogPresenter {}
}
