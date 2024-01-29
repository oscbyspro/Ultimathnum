//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
    
    @inlinable public static func <<(instance: consuming Self, shift: Self) -> Self {
        if  shift.isLessThanZero {
            return instance >> -shift
        }   else if Magnitude(bitPattern: shift) >= Self.bitWidth {
            return Self(repeating: Bit(bitPattern: false))
        }   else {
            return instance &<< shift
        }
    }
    
    @inlinable public static func >>(instance: consuming Self, shift: Self) -> Self {
        if  shift.isLessThanZero {
            return instance << -shift
        }   else if Magnitude(bitPattern: shift) >= Self.bitWidth {
            return Self(repeating: Bit(bitPattern: instance.isLessThanZero))
        }   else {
            return instance &>> shift
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<(instance: consuming Self, shift: Self) -> Self {
        //=--------------------------------------=
        // Self.bitWidth - 1 fits in Base.Magnitude
        //=--------------------------------------=
        let shift: Base.Magnitude = shift.low & (Self.bitWidth &- 1).low
        //=--------------------------------------=
        if  shift.load(as: UX.self) >= Base.bitWidth.load(as: UX.self) {
            instance.high    = Base(bitPattern: instance.low &<< (shift &- Base.bitWidth))
            instance.low     = Base.Magnitude(repeating: Bit(bitPattern: false))
        }   else if shift   != Base.Magnitude() {
            instance.high &<<= Base(bitPattern: shift)
            instance.high   |= Base(bitPattern: instance.low &>> (Base.bitWidth &- shift))
            instance.low  &<<= shift
        }
        //=--------------------------------------=
        return instance as Self as Self as Self as Self
    }
    
    @inlinable public static func &>>(instance: consuming Self, shift: Self) -> Self {
        //=--------------------------------------=
        // Self.bitWidth - 1 fits in Base.Magnitude
        //=--------------------------------------=
        let shift: Base.Magnitude = shift.low & (Self.bitWidth &- 1).low
        //=--------------------------------------=
        if  shift.load(as: UX.self) >= Base.bitWidth.load(as: UX.self) {
            instance.low     = Base.Magnitude(bitPattern: instance.high &>> Base(bitPattern: shift &- Base.bitWidth))
            instance.high    = Base(repeating: Bit(bitPattern: instance.high.isLessThanZero))
        }   else if shift   != Base.Magnitude() {
            instance.low  &>>= shift
            instance.low    |= Base.Magnitude(bitPattern: instance.high &<< Base(bitPattern: Base.bitWidth &- shift))
            instance.high &>>= Base(bitPattern: shift)
        }
        //=--------------------------------------=
        return instance as Self as Self as Self as Self
    }
}
