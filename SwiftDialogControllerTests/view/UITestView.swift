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
    
    var updateOnOrientationChanged = true
    
    var updateConstraintsOnOrientationChanged: Bool {
        return updateOnOrientationChanged
    }
    
    required init(withDetector detector: OrientationDetectorType) {
        self.orientationDetector = detector
        super.init(frame: CGRect.zero)
    }
    
    convenience init(withDetector detector: OrientationDetectorType,
                     updateOnOrientationChanged: Bool) {
        self.init(withDetector: detector)
        self.updateOnOrientationChanged = updateOnOrientationChanged
    }
    
    required public init?(coder aDecoder: NSCoder) { fatalError() }
    
    func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        return []
    }
}

class UIPaddingDialogView: UIBaseDialogView {
    var shortSidePadding: CGFloat = 0
    var longSidePadding: CGFloat = 0
    
    convenience init(withDetector detector: OrientationDetectorType,
                     withLongSidePadding longSidePadding: CGFloat,
                     withShortSidePadding shortSidePadding: CGFloat,
                     updateOnOrientationChanged update: Bool) {
        self.init(withDetector: detector, updateOnOrientationChanged: update)
        self.longSidePadding = longSidePadding
        self.shortSidePadding = shortSidePadding
    }
    
    override func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        return paddingConstraints(for: parent, for: child)
    }
}

class UIRatioDialogView: UIBaseDialogView {
    var shortSideRatio: CGFloat = 1 / 2
    var longSideRatio: CGFloat = 1 / 2
    
    convenience init(withDetector detector: OrientationDetectorType,
                     withLongSideRatio longSideRatio: CGFloat,
                     withShortSideRatio shortSideRatio: CGFloat,
                     updateOnOrientationChanged update: Bool) {
        self.init(withDetector: detector, updateOnOrientationChanged: update)
        self.longSideRatio = longSideRatio
        self.shortSideRatio = shortSideRatio
    }
    
    override func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        return ratioConstraints(for: parent, for: child)
    }
}

class UIRatioPaddingDialogView: UIBaseDialogView {
    var shortSidePadding: CGFloat = 0
    var longSideRatio: CGFloat = 1 / 2
    
    convenience init(withDetector detector: OrientationDetectorType,
                     withLongSideRatio longSideRatio: CGFloat,
                     withShortSidePadding shortSidePadding: CGFloat,
                     updateOnOrientationChanged update: Bool) {
        self.init(withDetector: detector, updateOnOrientationChanged: update)
        self.longSideRatio = longSideRatio
        self.shortSidePadding = shortSidePadding
    }
    
    override func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        return ratioPaddingConstraints(for: parent, for: child)
    }
}

class UIPaddingConstantDialogView: UIBaseDialogView {
    var shortSidePadding: CGFloat = 10
    var longSideConstant: CGFloat = 100
    
    convenience init(withDetector detector: OrientationDetectorType,
                     withLongSideConstant longSideConstant: CGFloat,
                     withShortSidePadding shortSidePadding: CGFloat,
                     updateOnOrientationChanged update: Bool) {
        self.init(withDetector: detector, updateOnOrientationChanged: update)
        self.longSideConstant = longSideConstant
        self.shortSidePadding = shortSidePadding
    }
    
    override func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        return paddingConstantConstraints(for: parent, for: child)
    }
}

class UIRatioConstantDialogView: UIBaseDialogView {
    var shortSideRatio: CGFloat = 1 / 2
    var longSideConstant: CGFloat = 100
    
    convenience init(withDetector detector: OrientationDetectorType,
                     withLongSideConstant longSideConstant: CGFloat,
                     withShortSideRatio shortSideRatio: CGFloat,
                     updateOnOrientationChanged update: Bool) {
        self.init(withDetector: detector, updateOnOrientationChanged: update)
        self.longSideConstant = longSideConstant
        self.shortSideRatio = shortSideRatio
    }
    
    override func dialogConstraints(for parent: UIView, for child: UIView)
        -> [NSLayoutConstraint]
    {
        return ratioConstantConstraints(for: parent, for: child)
    }
}

extension UIBaseDialogView: DialogViewType {}
extension UIPaddingDialogView: PaddingDialogViewType {}
extension UIRatioDialogView: RatioDialogViewType {}
extension UIRatioPaddingDialogView: RatioPaddingDialogViewType {}
extension UIPaddingConstantDialogView: PaddingConstantDialogViewType {}
extension UIRatioConstantDialogView: RatioConstantDialogViewType {}
