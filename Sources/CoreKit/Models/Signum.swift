//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Signum
//*============================================================================*

/// A comparison result represented by `-1` (negative), `0` (zero) or `1` (positive).
///
/// ### Development
///
/// - Note: It must not conform to `ExpressibleByIntegerLiteral` (#94).
///
@frozen public enum Signum: Comparable, Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A `negative` value.
    ///
    /// - Note: Its integer value `-1`.
    ///
    /// - Note: This comparison result can be read as: **is less than**.
    ///
    case negative
    
    /// A value of `zero`.
    ///
    /// - Note: Its integer value is  `0`.
    ///
    /// - Note: This comparison result can be read as: **is equal to**.
    ///
    case zero
    
    /// A `positive` value.
    ///
    /// - Note: Its integer value is  `1`.
    ///
    /// - Note: This comparison result can be read as: **is greater than**.
    ///
    case positive
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance equal to `0` or `1`.
    @inlinable public init(_ source: Bit) {
        switch Bool(source) {
        case true:  self = Self.positive
        case false: self = Self.zero
        }
    }
    
    /// Creates a new instance equal to `-1` or `1`.
    @inlinable public init(_ sign: Sign) {
        self = switch sign {
        case Sign.plus:  Self.positive
        case Sign.minus: Self.negative
        }
    }
    
    /// Creates a new instance equal to `-1`, `0` or `1`.
    @inlinable public init(_ sign: Optional<Sign>) {
        if  let sign {
            self.init(sign)
        }   else {
            self = Self.zero
        }
    }
}
