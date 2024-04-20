//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int x Shift
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func <<(instance: consuming Self, distance: Self) -> Self {
        if  distance.isLessThanZero {
            return instance >> -distance // TODO: no trap on min
        }   else if Magnitude(bitPattern: distance) >= Self.size {
            return Self(repeating: Bit(false))
        }   else {
            return instance &<< distance
        }
    }
    
    @inlinable public static func >>(instance: consuming Self, distance: Self) -> Self {
        if  distance.isLessThanZero {
            return instance << -distance // TODO: no trap on min
        }   else if Magnitude(bitPattern: distance) >= Self.size {
            return Self(repeating: Bit(instance.isLessThanZero))
        }   else {
            return instance &>> distance
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<(instance: consuming Self, distance: Self) -> Self {
        Self(instance.storage &<< distance.storage)
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Self) -> Self {
        Self(instance.storage &>> distance.storage)
    }
}
