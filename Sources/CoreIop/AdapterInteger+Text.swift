//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Adapter Integer x Text
//*============================================================================*

extension AdapterInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the exact `value` of `description`, or `nil`.
    ///
    /// ```swift
    /// format.decode(description)?.optional()
    /// ```
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `description` is `invalid`.
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    /// ### Binary Integer Description (InfiniInt.Stdlib)
    ///
    /// - Note: `String.init(_:radix:)` does not use `TextInt`.
    ///
    @inlinable public init?(_ description: consuming String) {
        if  let base = Base(description) {
            self.init(base)
        }   else {
            return nil
        }
    }
    
    /// Returns the exact `value` of `description`, or `nil`.
    ///
    /// ```swift
    /// format.decode(description)?.optional()
    /// ```
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `description` is `invalid`.
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    /// ### Binary Integer Description (InfiniInt.Stdlib)
    ///
    /// - Note: `String.init(_:radix:)` does not use `TextInt`.
    ///
    @inlinable public init?(_ description: consuming String, using format: borrowing TextInt) {
        guard let base = Base(description, using: format) else { return nil }
        self.init(base)
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
    /// ### Binary Integer Description (InfiniInt.Stdlib)
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
    /// ### Binary Integer Description (InfiniInt.Stdlib)
    ///
    /// - Note: `String.init(_:radix:)` does not use `TextInt`.
    ///
    @inlinable public func description(using format: borrowing TextInt) -> String {
        self.base.description(using: format)
    }
}
