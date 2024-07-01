//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Shift
//*============================================================================*

/// A finite value from zero up to the wrapped type's size.
///
/// ### Trusted Input
///
/// This is a trusted input type. Validate inputs with these methods:
///
/// ```
/// init(_:)         // error: traps
/// init(_:prune:)   // error: throws
/// init(exactly:)   // error: nil
/// init(unchecked:) // error: unchecked
/// ```
///
@frozen public struct Shift<Value>: Equatable where Value: UnsignedInteger {
    
    public typealias Value = Value
        
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: /* borrowing */ Value) -> Bool {
        let valueIsNatural = !Bool(value.appendix)
        
        if  Value.size.isInfinite {
            return valueIsNatural
        }   else {
            return valueIsNatural && value < Value.size
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let value: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance without precondition checks.
    ///
    /// - Requires: `value.appendix == 0 && value < Value.size`
    ///
    /// - Warning: Use this method only when you are 100% sure the input is valid.
    ///
    @_disfavoredOverload // enables: elements.map(Self.init)
    @inlinable public init(unchecked value: consuming Value) {
        Swift.assert(Self.predicate(value), String.brokenInvariant())
        self.value = value
    }
    
    /// Creates a new instance by trapping on failure.
    ///
    /// - Requires: `value.appendix == 0 && value < Value.size`
    ///
    @inlinable public init(_ value: consuming Value) {
        self.init(exactly: value)!
    }
    
    /// Creates a new instance by returning `nil` on failure.
    ///
    /// - Requires: `value.appendix == 0 && value < Value.size`
    ///
    @inlinable public init?(exactly value: consuming Value) {
        guard Self.predicate(value) else { return nil }
        self.value = value
    }
    
    /// Creates a new instance by throwing the `error()` on failure.
    ///
    /// - Requires: `value.appendix == 0 && value < Value.size`
    ///
    @inlinable public init<Failure>(
        _ value: consuming Value,
        prune error: @autoclosure () -> Failure
    )   throws where Failure: Swift.Error {
        guard Self.predicate(value) else { throw error() }
        self.value = value
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conveniences
//=----------------------------------------------------------------------------=

extension Shift where Value: SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the inverse of `self` unless `self` is zero.
    ///
    /// ```swift
    /// Shift(0 as I8).inverse() // nil
    /// Shift(1 as I8).inverse() // 7
    /// Shift(2 as I8).inverse() // 6
    /// Shift(3 as I8).inverse() // 5
    /// Shift(4 as I8).inverse() // 4
    /// Shift(5 as I8).inverse() // 3
    /// Shift(6 as I8).inverse() // 2
    /// Shift(7 as I8).inverse() // 1
    /// ```
    ///
    @inlinable public borrowing func inverse() -> Optional<Self> {
        if  self.value.isZero {
            return nil
            
        }   else {
            let difference = Value.size.minus(self.value)
            return Self(unchecked: difference.unchecked())
        }
    }
}
