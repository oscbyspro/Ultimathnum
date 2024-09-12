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

    /// Returns `self` advanced by `distance` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public func advanced(by distance: Swift.Int) -> Self {
        self.advanced(by: IX(distance)).unwrap()
    }
    
    /// Returns `self` advanced by `distance` and an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public func advanced<Distance>(
        by distance: Distance
    )   -> Fallible<Self> where Distance: SignedInteger {
        
        if  Self.size < Distance.size {
            return Self.exactly(Distance(load: self).plus(distance))
            
        }   else if Self.isSigned {
            return Self(load: distance).plus(self)
            
        }   else if distance.isNegative {
            return self.minus(Self(load: Distance.Magnitude(raw: distance.complement())))

        }   else {
            return self.plus (Self(load: Distance.Magnitude(raw: distance)))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the distance from `self` to `other` by trapping on `error`.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public func distance(to other: Self) -> Swift.Int {
        Swift.Int(self.distance(to: other, as: IX.self).unwrap())
    }
    
    /// Returns the distance from `self` to `other` and an `error` indicator.
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    @inlinable public func distance<Distance>(
        to other: Self,
        as type: Distance.Type = Distance.self
    )   -> Fallible<Distance> where Distance: SignedInteger {
                
        if  Self.size < Distance.size {
            return Distance(load: other).minus(Distance(load: self))
            
        }   else if Self.isSigned {
            return other.minus(self).map(Distance.exactly)
            
        }   else {
            let distance = Fallible<Signitude>(raw: other.minus(self))
            let superoverflow = distance.value.isNegative != distance.error
            return Distance.exactly(distance.value).veto(superoverflow)
        }
    }
}
