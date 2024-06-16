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
// MARK: * Infini Int x Shift
//*============================================================================*

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func << (instance: consuming Self, distance: Self) -> Self {
        if  distance.isNegative {
            return instance >> distance.magnitude()
        }   else {
            return instance << Magnitude(raw: distance)
        }
    }
    
    @inline(never) @inlinable public static func &<<(instance: consuming Self, distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        Swift.assert(!distance.value.isInfinite)
        Swift.assert(!distance.value.isNegative)
        //=--------------------------------------=
        // path: zero would otherwise denormalize
        //=--------------------------------------=
        if  instance.isZero {
            return instance
        }
        //=--------------------------------------=
        let shift = IX.exactly(distance.value).unwrap("BinaryInteger/entropy/0...IX.max")
        let split = shift.division(Divisor(size: Element.self)).unchecked()
        instance.storage.resizeByLenientUpshift(major: split.quotient, minor: split.remainder)
        Swift.assert(instance.storage.isNormal)
        return instance as Self as Self as Self
    }
    
    @inlinable public static func >> (instance: consuming Self, distance: Self) -> Self {
        if  distance.isNegative {
            return instance << distance.magnitude()
        }   else {
            return instance >> Magnitude(raw: distance)
        }
    }
    
    @inline(never) @inlinable public static func &>>(instance: consuming Self, distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        Swift.assert(!distance.value.isInfinite)
        Swift.assert(!distance.value.isNegative)
        //=--------------------------------------=
        let shift = IX.exactly(distance.value)
        //=--------------------------------------=
        // path: distance is >= body per protocol
        //=--------------------------------------=
        if  shift.error {
            return Self(repeating: instance.appendix)
        }
        //=--------------------------------------=
        // path: success
        //=--------------------------------------=
        let split = shift.value.division(Divisor(size: Element.self)).unchecked()
        instance.storage.resizeByLenientDownshift(major: split.quotient, minor: split.remainder)
        Swift.assert(instance.storage.isNormal)
        return instance as Self as Self as Self
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension InfiniInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func <<(instance: consuming Self, distance: Magnitude) -> Self {
        if  distance.isInfinite {
            return Self(repeating: Bit.zero)
        }   else {
            return instance &<< Shift(unchecked: Self(raw: distance))
        }
    }
    
    @inlinable internal static func >>(instance: consuming Self, distance: Magnitude) -> Self {
        if  distance.isInfinite {
            return Self(repeating: instance.appendix)
        }   else {
            return instance &>> Shift(unchecked: Self(raw: distance))
        }
    }
}
