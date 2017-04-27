//
//  DialogViewType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

import SwiftUIUtilities

/// UIView subclasses that implement this protocol can be added to
/// UIDialogViewController.
@objc public protocol DialogViewType: class {
    var orientationDetector: OrientationDetectorType { get }
    
    init(withOrientationDetector detector: OrientationDetectorType)
}

public extension DialogViewType {
    
    /// Get the current orientation.
    var orientation: BasicOrientation {
        return orientationDetector.orientation
    }
}
