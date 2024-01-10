//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Signed Int
//*============================================================================*

@frozen public struct SignedInt<Magnitude>: SignedInteger where Magnitude: BinaryInteger & UnsignedInteger {
        
    public typealias Components = (sign: Sign, magnitude: Magnitude)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The sign of this value.
    public var sign: Sign
    
    /// The magnitude of this value.
    public var magnitude: Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(magnitude: consuming Magnitude) throws {
        self.sign = Sign.plus
        self.magnitude = magnitude
    }
    
    /// Creates a new instance with the given sign and magnitude.
    @inlinable public init(sign: consuming Sign, magnitude: consuming Magnitude) {
        self.sign = sign
        self.magnitude = magnitude
    }
    
    @inlinable public init(sign: Sign, magnitude: () throws -> Magnitude) throws {
        let magnitude = Overflow.capture(magnitude)
        self.init(sign: sign, magnitude: magnitude.value)
        
        if  magnitude.overflow {
            throw Overflow(consume self)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Components
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `sign` and `magnitude`.
    ///
    /// ### Development
    ///
    /// - TODO: Add `consuming` keyword when compiler issue is fixed.
    ///
    @inlinable public init(components: Components) {
        (self.sign, self.magnitude) =  components
    }
    
    /// The `sign` and `magnitude` of this value.
    @inlinable public var components: Components {
        consuming get { Components(sign: self.sign, magnitude: self.magnitude) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    /// Turns negative zero into positive zero.
    @inlinable public consuming func normalized() -> Self {
        Self(sign: self.sign == Sign.plus || self != (0 as Self) ? self.sign : Sign.plus, magnitude: self.magnitude)
    }
}
