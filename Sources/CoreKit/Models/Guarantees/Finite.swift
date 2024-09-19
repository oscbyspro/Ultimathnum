//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Finite
//*============================================================================*

/// A finite value.
///
/// ### Trusted Input
///
/// This is a trusted input type. Validate inputs with these methods:
///
/// ```swift
/// init(_:prune:)   // error: throws
/// init(exactly:)   // error: nil
/// init(_:)         // error: precondition
/// init(unchecked:) // error: assert
/// init(unsafe:)    // error: %%%%%%
/// ```
///
@frozen public struct Finite<Value>: Equatable, Guarantee where Value: BinaryInteger {
        
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: /*borrowing*/ Value) -> Bool {
        !value.isInfinite // await borrowing fix
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(unsafe value: consuming Value) {
        self.value = value
    }
    
    @inlinable public consuming func payload() -> Value {
        self.value
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    /// The `magnitude` of `self`.
    @inlinable public consuming func magnitude() -> Finite<Value.Magnitude> {
        Finite<Value.Magnitude>(unchecked: self.value.magnitude())
    }
}
