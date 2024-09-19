//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Nonzero
//*============================================================================*

/// A nonzero value.
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
@frozen public struct Nonzero<Value>: BitCastable, Equatable, Guarantee where Value: BinaryInteger {
        
    public typealias BitPattern = Nonzero<Value.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static func predicate(_ value: /*borrowing*/ Value) -> Bool {
        !value.isZero // await borrowing fix
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
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(unchecked: Value(raw: source.value))
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        BitPattern(unchecked: Value.Magnitude(raw: self.value))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// The `complement` of `self`.
    @inlinable public consuming func complement() -> Nonzero<Value> {
        Self(unchecked: self.value.complement())
    }
    
    /// The `magnitude` of `self`.
    @inlinable public consuming func magnitude() -> Nonzero<Value.Magnitude> {
        Nonzero<Value.Magnitude>(unchecked: self.value.magnitude())
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conveniences
//=----------------------------------------------------------------------------=

extension Nonzero where Value: SystemsInteger<UX.BitPattern> {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance equal to `T.size`.
    ///
    /// - Note: A systems integer's size is never zero.
    ///
    @inlinable public init<T>(size source: T.Type) where T: SystemsInteger {
        self.init(unchecked: Value.init(size: T.self))
    }
}
