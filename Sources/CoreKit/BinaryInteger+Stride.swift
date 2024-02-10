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
            Swift.fatalError(String.overflow())
        }
    }
    
    @inlinable public consuming func distance(to other: Self) -> Swift.Int {
        attempt: do {
            return try Self.distance(self, to: other, as: IX.self).stdlib
        }   catch {
            Swift.fatalError(String.overflow())
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

    @inlinable package static func advanced<T>(_ instance: consuming Self, by distance: T) throws -> Self where T: SignedInteger {
        try Overflow.void {
            
            if  Self.isSigned {
                
                if  ExchangeInt(Self.bitWidth) >= ExchangeInt(T.bitWidth, as: Element.Magnitude.self) {
                    
                    return try instance.plus(Self(truncating: distance))
                    
                }   else {
                    
                    return try Self(exactly: T(truncating: instance).plus(distance))
                    
                }
                
            }   else {
                
                if  distance.isLessThanZero {
                    
                    return try instance.minus(Self(exactly: distance.magnitude))
                    
                }   else {
                    
                    return try instance.plus (Self(exactly: distance.magnitude))
                    
                }
                
            }
        }
    }
    
    @inlinable package static func distance<T>(_ instance: Self, to other: Self, as stride: T.Type) throws -> T where T: SignedInteger {
        try Overflow.void {
            
            if  Self.isSigned {
                
                if  ExchangeInt(Self.bitWidth) <= ExchangeInt(T.bitWidth, as: Element.Magnitude.self) {
                    
                    return try T(truncating: other).minus(T(truncating: instance))
                    
                }   else {
                    
                    return try T(exactly: other.minus(instance))
                    
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
