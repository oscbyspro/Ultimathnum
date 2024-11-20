//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Text
//*============================================================================*
//=----------------------------------------------------------------------------=
// TODO: @_unavailableInEmbedded is not a known attribute in Swift 5.9
//=----------------------------------------------------------------------------=

/* @_unavailableInEmbedded */ extension BinaryInteger {
    
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
    /// - Note: The default `format` is `TextInt.decimal`.
    ///
    @inlinable public init?(_ description: consuming String) {
        self.init(description, using: TextInt.decimal)
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
    /// - Note: The default `format` is `TextInt.decimal`.
    ///
    @inlinable public init?(_ description: consuming String, using format: borrowing TextInt) {
        guard let instance: Self = format.decode(description)?.optional() else { return nil }
        self  = ((instance))
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
    @inlinable public var description: String {
        self.description(using: TextInt.decimal)
    }
    
    /// Returns the `description` of `self` using the given `format`.
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    @inlinable public func description(using format: borrowing TextInt) -> String {
        format.encode(self)
    }
}
