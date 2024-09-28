//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Guarantee
//*============================================================================*

/// Validates values according to its `predicate(_:)` function.
///
/// ### Guarantee
///
/// Validate values with these methods:
///
/// ```swift
/// init(_:prune:)   // error: throws
/// init(exactly:)   // error: nil
/// init(_:)         // error: precondition
/// init(unchecked:) // error: assert
/// init(unsafe:)    // error: %%%%%%
/// ```
///
public protocol Guarantee<Value> {
    
    associatedtype Value
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Indicates whether the given `value` satisfies its requirements.
    @inlinable static func predicate(_ value: borrowing Value) -> Bool
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance without validation.
    ///
    /// - Requires: The given `value` must satisfy the `predicate` of this type.
    ///
    @inlinable init(unsafe value: consuming Value)
    
    /// Consumes `self` and returns its `value`.
    @inlinable consuming func payload() ->  Value
}
