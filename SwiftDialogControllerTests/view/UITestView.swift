//
//  UIPaddingDialogView.swift
//  SwiftDialogController
//
//  Created by Hai Pham on 4/28/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import UIKit
import SwiftUtilities
import SwiftUIUtilities
@testable import SwiftDialogController

class UIBaseDialogView: UIView {
    weak var orientationDetector: OrientationDetectorType?
    
    required init(withDetector detector: OrientationDetectorType) {
        self.orientationDetector = detector
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError() }
}

class UIPaddingDialogView: UIBaseDialogView {
    let shortSidePadding: CGFloat = 0
    let longSidePadding: CGFloat = 0
}

class UIRatioDialogView: UIBaseDialogView {
    let shortSideRatio: CGFloat = 1 / 2
    let longSideRatio: CGFloat = 1 / 2
}

class UIRatioPaddingDialogView: UIBaseDialogView {
    let shortSidePadding: CGFloat = 0
    let longSideRatio: CGFloat = 1 / 2
}

extension UIBaseDialogView: DialogViewType {}
extension UIPaddingDialogView: PaddingDialogViewType {}
extension UIRatioDialogView: RatioDialogViewType {}
extension UIRatioPaddingDialogView: RatioPaddingDialogViewType {}
