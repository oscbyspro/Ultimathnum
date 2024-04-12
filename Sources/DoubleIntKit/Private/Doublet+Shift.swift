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
// MARK: * Double x Shift
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1
    //=------------------------------------------------------------------------=
    
    @inlinable package static func &<<(instance: consuming Self, distance: Base) -> Self {
        let distance = Base.Magnitude(bitPattern: distance) & (Base.size &<< 1 &- 1)
        
        if  distance.load(as: UX.self) >= UX(size: Base.self) {
            instance.high     = Base(bitPattern: instance.low &<< (distance &- Base.size))
            instance.low      = Base.Magnitude(repeating: Bit(false))
        }   else if distance != Base.Magnitude() {
            instance.high  &<<= Base(bitPattern: distance)
            instance.high    |= Base(bitPattern: instance.low &>> (Base.size &- distance))
            instance.low   &<<= distance
        }
        
        return instance as Self as Self as Self
    }
    
    @inlinable package static func &>>(instance: consuming Self, distance: Base) -> Self {
        let distance = Base.Magnitude(bitPattern: distance) & (Base.size &<< 1 &- 1)
        
        if  distance.load(as: UX.self) >= UX(size: Base.self) {
            instance.low      = Base.Magnitude(bitPattern: instance.high &>> Base(bitPattern: distance &- Base.size))
            instance.high     = Base(repeating: Bit(instance.high.isLessThanZero))
        }   else if distance != Base.Magnitude() {
            instance.low   &>>= distance
            instance.low     |= Base.Magnitude(bitPattern: instance.high &<< Base(bitPattern: Base.size &- distance))
            instance.high  &>>= Base(bitPattern: distance)
        }
        
        return instance as Self as Self as Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 2
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<(instance: consuming Self, distance: Self) -> Self {
        instance &<< Base(bitPattern: distance.low)
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Self) -> Self {
        instance &>> Base(bitPattern: distance.low)
    }
}
