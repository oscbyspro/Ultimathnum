//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Stride
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func advanced(by other: Swift.Int) -> Self {
        attempt: do {
            return try Self.advanced(self, by: IX(other))
        }   catch {
            fatalError(String.overflow())
        }
    }
    
    @inlinable public consuming func distance(to other: Self) -> Swift.Int {
        attempt: do {
            return try Self.distance(self, to: other, as: IX.self).stdlib
        }   catch {
            fatalError(String.overflow())
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable package static func advanced<T>(_ instance: consuming Self, by stride: T) throws -> Self where T: SignedInteger {
        try Overflow.void {
            
            if  Self.isSigned {
                
                if  ExchangeInt(Self.bitWidth, as: Element.Magnitude.self) < 
                    ExchangeInt(   T.bitWidth, as: Element.Magnitude.self) {
                    return try Self(exactly: T(truncating: instance).plus(stride))
                }   else {
                    return try instance.plus(Self(truncating: stride))
                }
                
            }   else {
                
                if  stride.isLessThanZero {
                    return try instance.minus(Self(exactly: stride.magnitude))
                }   else {
                    return try instance.plus (Self(exactly: stride.magnitude))
                }
                
            }
        }
    }
    
    @inlinable package static func distance<T>(_ instance: Self, to other: Self, as stride: T.Type) throws -> T where T: SignedInteger {
        try Overflow.void {
            
            if  Self.isSigned {
                
                let isLessThanZero = instance.isLessThanZero
                if  isLessThanZero == (other).isLessThanZero {
                    
                    return try T(exactly: other - instance)
                    
                }   else {
                    
                    return try T(sign: Sign(bitPattern: !isLessThanZero), magnitude: T.Magnitude(exactly: instance.magnitude + other.magnitude))
                    
                }
                
            }   else {
                
                if  instance < other {
                    
                    return try T(exactly: other - instance)
                                        
                }   else {
                    
                    return try T(sign: Sign.minus, magnitude: T.Magnitude(exactly: instance - other))
                    
                }
            }
        }
    }
}
