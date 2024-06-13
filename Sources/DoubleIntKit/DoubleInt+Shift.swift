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
        if  distance.isNegative {
            return instance >> distance.magnitude()
        }   else {
            return instance << Magnitude(raw: distance)
        }
    }
    
    @inlinable public static func &<<(instance: consuming Self, distance: Self) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        instance &<< Shift(unchecked: Self(low: Base.Magnitude(raw: distance.low) & (Base.size &<< 1 &- 1)))
    }
    
    @inlinable public static func &<<(instance: consuming Self, distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        if  UX(load: distance.value.low) >= UX(size: Base.self) {
            let distance  = Shift(unchecked: distance.value.low.minus(Base.size).unchecked())
            instance.high = Base(raw: instance.low &<< distance)
            instance.low  = Base.Magnitude(repeating: Bit(false))
        }   else {
            instance.storage = Base.upshift(instance.storage, by: Shift(unchecked: Base(raw: distance.value.low)))
        }

        return instance as Self as Self as Self as Self
    }
    
    @inlinable public static func >>(instance: consuming Self, distance: Self) -> Self {
        if  distance.isNegative {
            return instance << distance.magnitude()
        }   else {
            return instance >> Magnitude(raw: distance)
        }
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Self) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        instance &>> Shift(unchecked: Self(low: Base.Magnitude(raw: distance.low) & (Base.size &<< 1 &- 1)))
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        if  UX(load: distance.value.low) >= UX(size: Base.self) {
            let distance  = Shift(unchecked: Base(raw: distance.value.low.minus(Base.size).unchecked()))
            instance.low  = Base.Magnitude(raw: instance.high &>> distance)
            instance.high = Base(repeating: Bit(instance.high.isNegative ))
        }   else {
            instance.storage = Base.downshift(instance.storage, by: Shift(unchecked: Base(raw: distance.value.low)))
        }
        
        return instance as Self as Self as Self
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func <<(instance: consuming Self, distance: Magnitude) -> Self {
        if  distance >= Self.size {
            return Self(repeating: Bit.zero)
        }   else {
            return instance &<< Shift(unchecked: Self(raw: distance))
        }
    }
    
    @inlinable internal static func >>(instance: consuming Self, distance: Magnitude) -> Self {
        if  distance >= Self.size {
            return Self(repeating: instance.appendix)
        }   else {
            return instance &>> Shift(unchecked: Self(raw: distance))
        }
    }
}
