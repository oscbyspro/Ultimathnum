//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
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
        self.advanced(by: IX(other)).unwrap()
    }
    
    @inlinable public consuming func advanced<Other>(
        by distance: Other
    )   -> Fallible<Self> where Other: SignedInteger {
        
        if  Self.isSigned {
            if  Self.size < Other.size {
                return Other(load: self).plus(distance).map(Self.exactly)
                
            }   else {
                return self.plus(Self(load: distance))
            }
        }   else {
            if  distance.isNegative {
                return self.minus(Self.exactly(Other.Magnitude(raw: distance.complement())))
                
            }   else {
                return self.plus (Self.exactly(Other.Magnitude(raw: distance)))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func distance(to other: Self) -> Swift.Int {
        Int(self.distance(to: other, as: IX.self).unwrap())
    }
    
    @inlinable package consuming func distance<Other>(
        to other: Self,
        as type: Other.Type = Other.self
    )   -> Fallible<Other> where Other: SignedInteger {
        
        if  Self.size < Other.size {
            return Other(load: other).minus(Other(load: self))
        
        }   else if Self.isSigned {
            return other.minus(self).map(Other.exactly)
            
        }   else {
            let distance = Fallible<Signitude>(raw: other.minus(self))
            let superoverflow =  distance.value.isNegative != distance.error
            return Other.exactly(distance.value).invalidated(superoverflow)
        }
    }
}
