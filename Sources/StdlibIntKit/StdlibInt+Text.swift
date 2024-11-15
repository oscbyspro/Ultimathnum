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
    /// ### Binary Integer Description
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    /// - Note: Decoding failures throw `TextInt.Error`.
    ///
    /// ### Binary Integer Description (StdlibInt)
    ///
    /// - Note: `String.init(_:radix:)` does not use `TextInt`.
    ///
    @inlinable public init?(_ description: String) {
        if  let base = Base(description) {
            self.init(base)
        }   else {
            return nil
        }
    }
    
    /// Decodes the `description` using the given `format`, if possible.
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    /// - Note: Decoding failures throw `TextInt.Error`.
    ///
    /// ### Binary Integer Description (StdlibInt)
    ///
    /// - Note: `String.init(_:radix:)` does not use `TextInt`.
    ///
    @inlinable public init(_ description: some StringProtocol, as format: TextInt) throws {
        try self.init(Base(description, using: format))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `description` of `self`.
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    /// - Note: Decoding failures throw `TextInt.Error`.
    ///
    /// ### Binary Integer Description (StdlibInt)
    ///
    /// - Note: `String.init(_:radix:)` does not use `TextInt`.
    ///
    @inlinable public var description: String {
        self.base.description
    }
    
    /// Returns the `description` of `self` using the given `format`.
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    /// - Note: Decoding failures throw `TextInt.Error`.
    ///
    /// ### Binary Integer Description (StdlibInt)
    ///
    /// - Note: `String.init(_:radix:)` does not use `TextInt`.
    ///
    @inlinable public func description(using format: TextInt) -> String {
        self.base.description(using: format)
    }
}
