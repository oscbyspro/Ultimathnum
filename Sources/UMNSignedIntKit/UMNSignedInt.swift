//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import UMNCoreKit

//*============================================================================*
// MARK: * UMN x Signed Int
//*============================================================================*

@frozen public struct UMNSignedInt<Magnitude>: UMNSignedInteger where Magnitude: UMNBinaryInteger & UMNUnsignedInteger {
    
    public typealias Sign = FloatingPointSign // TODO: custom model
    
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
    
    /// Creates a new instance with the given sign and magnitude.
    @inlinable public init(sign: Sign, magnitude: Magnitude) {
        self.sign = sign; self.magnitude = magnitude
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
    @inlinable consuming public func normalized() -> Self {
        Self(sign: self.sign == Sign.plus || self != (0 as Self) ? self.sign : Sign.plus, magnitude: self.magnitude)
    }
}

//*============================================================================*
// MARK: * UMN x Signed x Aliases
//*============================================================================*

/// A signed integer with a pointer-bit magnitude.
public typealias SX = UMNSignedInt<UX>

/// A signed integer with an 8-bit magnitude.
public typealias S8 = UMNSignedInt<U8>

/// A signed integer with a 16-bit magnitude.
public typealias S16 = UMNSignedInt<U16>

/// A signed integer with a 32-bit magnitude.
public typealias S32 = UMNSignedInt<U32>

/// A signed integer with a 64-bit magnitude.
public typealias S64 = UMNSignedInt<U64>
