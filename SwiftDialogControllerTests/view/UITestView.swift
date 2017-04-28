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
    var shortSidePadding: CGFloat = 0
    var longSidePadding: CGFloat = 0
    
    convenience init(withDetector detector: OrientationDetectorType,
                     withLongSidePadding longSidePadding: CGFloat,
                     withShortSidePadding shortSidePadding: CGFloat) {
        self.init(withDetector: detector)
        self.longSidePadding = longSidePadding
        self.shortSidePadding = shortSidePadding
    }
}

class UIRatioDialogView: UIBaseDialogView {
    var shortSideRatio: CGFloat = 1 / 2
    var longSideRatio: CGFloat = 1 / 2
    
    convenience init(withDetector detector: OrientationDetectorType,
                     withLongSideRatio longSideRatio: CGFloat,
                     withShortSideRatio shortSideRatio: CGFloat) {
        self.init(withDetector: detector)
        self.longSideRatio = longSideRatio
        self.shortSideRatio = shortSideRatio
    }
}

class UIRatioPaddingDialogView: UIBaseDialogView {
    var shortSidePadding: CGFloat = 0
    var longSideRatio: CGFloat = 1 / 2
    
    convenience init(withDetector detector: OrientationDetectorType,
                     withLongSideRatio longSideRatio: CGFloat,
                     withShortSidePadding shortSidePadding: CGFloat) {
        self.init(withDetector: detector)
        self.longSideRatio = longSideRatio
        self.shortSidePadding = shortSidePadding
    }
}

extension UIBaseDialogView: DialogViewType {}
extension UIPaddingDialogView: PaddingDialogViewType {}
extension UIRatioDialogView: RatioDialogViewType {}
extension UIRatioPaddingDialogView: RatioPaddingDialogViewType {}
