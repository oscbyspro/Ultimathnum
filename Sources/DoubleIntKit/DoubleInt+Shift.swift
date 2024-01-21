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
    
    @inlinable public static func <<(lhs: consuming Self, rhs: Self) -> Self {
        if  rhs.isLessThanZero {
            return lhs >> -rhs
        }   else if Magnitude(bitPattern: rhs) >= Self.bitWidth {
            return Self(repeating: U1(bitPattern: false))
        }   else {
            return lhs &>> rhs
        }
    }
    
    @inlinable public static func >>(lhs: consuming Self, rhs: Self) -> Self {
        if  rhs.isLessThanZero {
            return lhs << -rhs
        }   else if Magnitude(bitPattern: rhs) >= Self.bitWidth {
            return Self(repeating: U1(bitPattern: lhs.isLessThanZero))
        }   else {
            return lhs &<< rhs
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<(lhs: consuming Self, rhs: Self) -> Self {
        //=--------------------------------------=
        let rhs: Base.Magnitude = rhs.low & (Self.bitWidth &- 1).low
        //=--------------------------------------=
        if  rhs.load(as: UX.self) < Base.bitWidth.load(as: UX.self) {
            lhs.high = lhs.high &<< Base(bitPattern: rhs)
            lhs.high = lhs.high |   Base(bitPattern: lhs.low &>> (Base.bitWidth &- rhs))
            lhs.low  = lhs.low  &<< rhs
        }   else if rhs.load(as: UX.self) > Base.bitWidth.load(as: UX.self) {
            lhs.low  = Base.Magnitude(repeating: U1(bitPattern: false))
            lhs.high = Base(bitPattern: lhs.low &<< (rhs &- Base.bitWidth))
        }
        //=--------------------------------------=
        return lhs as Self as Self as Self as Self
    }
    
    @inlinable public static func &>>(lhs: consuming Self, rhs: Self) -> Self {
        //=--------------------------------------=
        let rhs: Base.Magnitude = rhs.low & (Self.bitWidth &- 1).low
        //=--------------------------------------=
        if  rhs.load(as: UX.self) < Base.bitWidth.load(as: UX.self) {
            lhs.low  = lhs.low  &>> rhs
            lhs.low  = lhs.low  |   Base.Magnitude(bitPattern: lhs.high &<< Base(bitPattern: Base.bitWidth &- rhs))
            lhs.high = lhs.high &>> Base(bitPattern: rhs)
        }   else if rhs.load(as: UX.self) > Base.bitWidth.load(as: UX.self) {
            lhs.low  = Base.Magnitude(bitPattern: lhs.high &>> Base(bitPattern: rhs &- Base.bitWidth))
            lhs.high = Base(repeating: U1(bitPattern: lhs.high.isLessThanZero))
        }
        //=--------------------------------------=
        return lhs as Self as Self as Self as Self
    }
}
