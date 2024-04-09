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
    
    @inlinable public consuming func advanced<T>(by distance: T) -> Fallible<Self> where T: SignedInteger {
        if  Self.isSigned {
            
            if  compare(Self.bitWidth, to: T.bitWidth) == Signum.less {
                
                return T(truncating: self).plus(distance).map(Self.exactly)
                
            }   else {
                
                return self.plus(Self(truncating: distance))
                
            }
            
        }   else {
            
            if  distance.isLessThanZero {
                
                return self.minus(Self.exactly(T.Magnitude(bitPattern: distance.complement())))
                
            }   else {
                
                return self.plus (Self.exactly(T.Magnitude(bitPattern: distance)))
                
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func distance(to other: Self) -> Swift.Int {
        Int(self.distance(to: other, as: IX.self).unwrap())
    }
    
    @inlinable package consuming func distance<T>(to other: Self, as type: T.Type = T.self) -> Fallible<T> where T: SignedInteger {
        //=--------------------------------------=
        // TODO: better comparison
        //=--------------------------------------=
        if  compare(Self.bitWidth, to: T.bitWidth) == Signum.less {
            
            return T(truncating: other).minus(T(truncating: self))
        
            
        }   else if Self.isSigned {
            
            return other.minus(self).map(T.exactly)
            
        }   else {
            
            let distance = Fallible<Signitude>(bitPattern: other.minus(self))
            let superoverflow = distance.value.isLessThanZero != distance.error
            return T.exactly(distance.value).combine(superoverflow)
        }
    }
}
