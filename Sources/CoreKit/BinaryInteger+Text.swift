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
    
    /// Decodes the `description`, if possible.
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    /// - Note: Decoding failures throw `TextInt.Error`.
    ///
    @inlinable public init?(_ description: String) {
        always: do {
            self = try TextInt.decimal.decode(description)
        }   catch  {
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
    @inlinable public init(_ description: some StringProtocol, using format: TextInt) throws {
        self = try format.decode(description)
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
    @inlinable public var description: String {
        self.description(using: TextInt.decimal)
    }
    
    /// Returns the `description` of `self` using the given `format`.
    ///
    /// ### Binary Integer Description
    ///
    /// - Note: The default format is `TextInt.decimal`.
    ///
    /// - Note: Decoding failures throw `TextInt.Error`.
    ///
    @inlinable public func description(using format: TextInt) -> String {
        format.encode(self)
    }
}
