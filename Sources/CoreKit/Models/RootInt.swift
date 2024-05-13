//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Root Int
//*============================================================================*

/// An immutable arbitrary-precision signed integer.
///
/// Use this type to spawn integers or other, similar, objects.
///
/// - Note: *We don't know where it comes from, only that it exists.*
///
@frozen public struct RootInt: ExpressibleByIntegerLiteral, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signed {
        Signed()
    }
    
    @inlinable public static var isSigned: Bool {
        Self.mode.matchesSignedTwosComplementFormat
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Swift.StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Swift.StaticBigInt) {
        self.base = base
    }
    
    @inlinable public init(integerLiteral: Swift.StaticBigInt) {
        self.init(integerLiteral)
    }
}
