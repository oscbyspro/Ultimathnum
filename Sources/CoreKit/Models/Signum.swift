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

/// A comparison result represented by `-1` (less), `0` (same) or `1` (more).
@frozen public enum Signum: Comparable, ExpressibleByIntegerLiteral, Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    case less
    case same
    case more
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: Bit) {
        switch Bool(source) {
        case true:  self = Self.more
        case false: self = Self.same
        }
    }
    
    @inlinable public static func one(_ sign: Sign) -> Self {
        switch sign {
        case Sign.plus:  return Self.more
        case Sign.minus: return Self.less
        }
    }
    
    @inlinable public init(integerLiteral: IX.IntegerLiteralType) {
        self = switch integerLiteral {
        case -1: .less
        case  0: .same
        case  1: .more
        default: Swift.preconditionFailure(.overflow())
        }
    }
}
