//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Natural
//*============================================================================*

/// A finite, nonnegative, value.
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
/// ### How to bit cast a `Natural<Value>`
///
/// You may always bit cast a signed natural value to its unsigned magnitude.
/// The most convenient way is by calling `magnitude()`. Please keep in mind,
/// however, that the inverse case is not as simple. `U8(255)` is natural, 
/// for example, but it becomes negative when you reinterpret it as `I8(-1)`.
///
@frozen public struct Natural<Value>: Equatable, Guarantee where Value: BinaryInteger {
        
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: /*borrowing*/ Value) -> Bool {
        !Bool(value.appendix) // await borrowing fix
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
    ///
    /// - Note: This is a bit cast because `self ∈ ℕ → unsigned`.
    ///
    @inlinable public consuming func magnitude() -> Natural<Value.Magnitude> {
        Natural<Value.Magnitude>(unchecked: Value.Magnitude(raw: self.value))
    }
}
