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
        instance &<< Shift(unchecked: Self(low: Base.Magnitude(bitPattern: distance.low) & (Base.size &<< 1 &- 1)))
    }
    
    @inlinable public static func &<<(instance: consuming Self, distance: Shift<Self>) -> Self {
        Self.init(instance.storage.upshift(unchecked: distance.value.storage))
    }
    
    @inlinable public static func >>(instance: consuming Self, distance: Self) -> Self {
        if  distance.isNegative {
            return instance << distance.magnitude()
        }   else {
            return instance >> Magnitude(bitPattern: distance)
        }
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Self) -> Self {
        instance &>> Shift(unchecked: Self(low: Base.Magnitude(bitPattern: distance.low) & (Base.size &<< 1 &- 1)))
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Shift<Self>) -> Self {
        Self.init(instance.storage.downshift(unchecked: distance.value.storage))
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
