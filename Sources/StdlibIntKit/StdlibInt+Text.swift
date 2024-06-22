//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit

//*============================================================================*
// MARK: * Stdlib Int x Text
//*============================================================================*

extension StdlibInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Decodes the decimal `description`, if possible.
    ///
    /// - Note: This method uses `TextInt`.
    ///
    @inlinable public init?(_ description: String) {
        if  let base = Base(description) {
            self.init(base)
        }   else {
            return nil
        }
    }
    
    /// Decodes the `format` `description`, if possible.
    ///
    /// - Note: This method uses `TextInt`.
    ///
    @inlinable public init(_ description: some StringProtocol, as format: TextInt) throws {
        try self.init(Base(description, as: format))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the decimal `description` of `self`.
    ///
    /// - Note: This method uses `TextInt`.
    ///
    @inlinable public var description: String {
        self.base.description
    }
    
    /// Returns the `format` `description` of `self`.
    ///
    /// - Note: This method uses `TextInt`.
    ///
    /// - Note: `String.init(_:radix:)` does not use `TextInt`.
    ///
    @inlinable public func description(as format: TextInt) -> String {
        self.base.description(as: format)
    }
}
