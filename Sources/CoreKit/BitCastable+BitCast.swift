//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Castable + Bit Cast
//*============================================================================*

extension BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inline(__always) //  performance: please fold it like a paper airplane
    @inlinable public init(raw source: consuming some BitCastable<BitPattern>) {
        self.init(raw: source.load(as: BitPattern.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Reinterprets this instance as an instance of type `T`.
    ///
    /// ```swift
    /// var value = IX(0)
    /// var error = value[raw: UX.self][{ $0.decremented() }]
    ///
    /// print(value) // -1
    /// print(error) // true
    /// ```
    ///
    @inlinable public subscript<T>(raw type: T.Type) -> T where T: BitCastable<BitPattern> {
        consuming get {
            T(raw: self)
        }
        
        mutating set {
            self = Self(raw: newValue)
        }
    }
}
