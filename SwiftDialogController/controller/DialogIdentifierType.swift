//
//  DialogIdentifierType.swift
//  SwiftUIUtilities
//
//  Created by Hai Pham on 4/27/17.
//  Copyright © 2017 Swiften. All rights reserved.
//

/// Implement this protocol to provide view identifiers for dialog controllers.
public protocol DialogIdentifierType {}

public extension DialogIdentifierType {
    
    /// Get id for background button.
    public var backgroundButtonId: String { return "backgroundButton" }
}
