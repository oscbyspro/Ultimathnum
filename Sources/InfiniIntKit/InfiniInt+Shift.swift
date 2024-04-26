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
            return instance << Magnitude(bitPattern: distance)
        }
    }
    
    @inlinable public static func &<<(instance: consuming Self, distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        Swift.assert(!distance.value.isInfinite)
        Swift.assert(!distance.value.isNegative)
        //=--------------------------------------=
        // path: trivial (0)
        //=--------------------------------------=
        if  instance.storage.isZero {
            return instance
        }
        //=--------------------------------------=
        // path: distance is >= body per protocol
        //=--------------------------------------=
        let shift = IX.exactly(Magnitude(bitPattern: distance.value)).unwrap("BinaryInteger/body/0...IX.max")
        //=--------------------------------------=
        // path: success or allocation is too big
        //=--------------------------------------=
        let split = shift.division(Divisor(unchecked: IX(size: Element.self))).assert()
        instance.storage.resizeByLenientUpshift(major: split.quotient, minor: split.remainder)
        Swift.assert(instance.storage.isNormal)
        return instance as Self as Self as Self
    }
    
    @inlinable public static func >> (instance: consuming Self, distance: Self) -> Self {
        if  distance.isNegative {
            return instance << distance.magnitude()
        }   else {
            return instance >> Magnitude(bitPattern: distance)
        }
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Shift<Self>) -> Self {
        //=--------------------------------------=
        Swift.assert(!distance.value.isInfinite)
        Swift.assert(!distance.value.isNegative)
        //=--------------------------------------=
        // path: trivial (-1, 0, ∞)
        //=--------------------------------------=
        if  instance.storage.count == .zero {
            return instance
        }
        //=--------------------------------------=
        let shift = IX.exactly(Magnitude(bitPattern: distance.value))
        //=--------------------------------------=
        // path: distance is >= body per protocol
        //=--------------------------------------=
        if  shift.error {
            return Self(repeating: instance.appendix)
        }
        //=--------------------------------------=
        // path: success
        //=--------------------------------------=
        let split = shift.value.division(Divisor(unchecked: IX(size: Element.self))).assert()
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
            return instance &<< Shift(unchecked: Self(bitPattern: distance))
        }
    }
    
    @inlinable internal static func >>(instance: consuming Self, distance: Magnitude) -> Self {
        if  distance.isInfinite {
            return Self(repeating: instance.appendix)
        }   else {
            return instance &>> Shift(unchecked: Self(bitPattern: distance))
        }
    }
}
