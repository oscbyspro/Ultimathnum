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

/// ### Development
///
/// - TODO: Consider non-binary magnitude requirement.
///
@frozen public struct SignedInt<Magnitude>: Integer where Magnitude: Integer, Magnitude.Magnitude == Magnitude {
    
    public typealias Element = Magnitude.Element
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias Components = (sign: Sign, magnitude: Magnitude)
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        true
    }
    
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
    @inlinable public init(sign: Sign, magnitude: consuming Magnitude) throws {
        self.sign = sign
        self.magnitude = magnitude
        
        if  self.magnitude < 0 {
            throw Overflow(self)
        }
    }
    
    @inlinable public init(sign: Sign, magnitude: () throws -> Magnitude) throws {
        let magnitude = Overflow.capture(magnitude)
        try self.init(sign: sign, magnitude: magnitude.value)
        
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
        consuming get {( sign: self.sign, magnitude: self.magnitude )}
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Normalization
    //=------------------------------------------------------------------------=
    
    /// Turns negative zero into positive zero.
    @inlinable public consuming func normalized() -> Self {
        if  self.sign == .minus, self.magnitude == 0 {
            self.sign =   .plus
        };  return consume self
    }
}
