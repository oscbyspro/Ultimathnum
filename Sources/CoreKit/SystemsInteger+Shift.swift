//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Shift
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<=(instance: inout Self, shift: borrowing Self) {
        instance = instance &<< shift
    }
    
    @inlinable public static func &>>=(instance: inout Self, shift: borrowing Self) {
        instance = instance &>> shift
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 2
    //=------------------------------------------------------------------------=

    @inlinable public static func upshift(_ instance: consuming Doublet<Self>, by distance: Shift<Self>) -> Doublet<Self> {
        //=--------------------------------------=
        if  distance.value != .zero {
            instance.high  &<<= distance
            instance.high    |= Self(bitPattern: instance.low) &>> distance.nondistance()
            instance.low   &<<= Shift(unchecked: Magnitude(bitPattern:  distance.value))
        }
        //=--------------------------------------=
        return instance as Doublet<Self> as Doublet<Self>
    }
    
    @inlinable public static func downshift(_ instance: consuming Doublet<Self>, by distance: Shift<Self>) -> Doublet<Self> {
        //=--------------------------------------=
        if  distance.value != .zero {
            instance.low   &>>= Shift(unchecked: Magnitude(bitPattern:  distance.value))
            instance.low     |= Magnitude(bitPattern: instance.high &<< distance.nondistance())
            instance.high  &>>= distance
        }
        //=--------------------------------------=
        return instance as Doublet<Self> as Doublet<Self>
    }
}
