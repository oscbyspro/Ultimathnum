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
            return instance << Magnitude(bitPattern: distance)
        }
    }
    
    @inlinable public static func &<<(instance: consuming Self, distance: Self) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        instance &<< Shift(unchecked: Self(low: Base.Magnitude(bitPattern: distance.low) & (Base.size &<< 1 &- 1)))
    }
    
    @inlinable public static func &<<(instance: consuming Self, distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        if  distance.value.low.load(as: UX.self) >= UX(size: Base.self) {
            let distance  = Shift(unchecked: distance.value.low.minus(Base.size).assert())
            instance.high = Base(bitPattern: instance.low &<< distance)
            instance.low  = Base.Magnitude(repeating: Bit(false))
        }   else {
            instance.storage = Base.upshift(instance.storage, by: Shift(unchecked: Base(bitPattern: distance.value.low)))
        }

        return instance as Self as Self as Self as Self
    }
    
    @inlinable public static func >>(instance: consuming Self, distance: Self) -> Self {
        if  distance.isNegative {
            return instance << distance.magnitude()
        }   else {
            return instance >> Magnitude(bitPattern: distance)
        }
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Self) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        instance &>> Shift(unchecked: Self(low: Base.Magnitude(bitPattern: distance.low) & (Base.size &<< 1 &- 1)))
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        // note: even a 2-bit shift fits in 1 bit
        //=--------------------------------------=
        if  distance.value.low.load(as: UX.self) >= UX(size: Base.self) {
            let distance  = Shift(unchecked: Base(bitPattern: distance.value.low.minus(Base.size).assert()))
            instance.low  = Base.Magnitude(bitPattern: instance.high &>> distance)
            instance.high = Base(repeating: Bit(instance.isNegative))
        }   else {
            instance.storage = Base.downshift(instance.storage, by: Shift(unchecked: Base(bitPattern: distance.value.low)))
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
            return instance &<< Self(bitPattern: distance)
        }
    }
    
    @inlinable internal static func >>(instance: consuming Self, distance: Magnitude) -> Self {
        if  distance >= Self.size {
            return Self(repeating: instance.appendix)
        }   else {
            return instance &>> Self(bitPattern: distance)
        }
    }
}
