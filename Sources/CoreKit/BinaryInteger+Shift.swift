//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Shift
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Forms the result that fits of a so-called smart left shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public static func  <<=(instance: inout Self, distance: Self) {
        instance = instance  << distance
    }
    
    /// Forms the result that fits of a so-called exact left shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public static func &<<=(instance: inout Self, distance: Shift<Self>) {
        instance = instance &<< distance
    }
    
    /// Forms the result that fits of a so-called un/signed smart right shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public static func  >>=(instance: inout Self, distance: Self) {
        instance = instance  >> distance
    }

    /// Forms the result that fits of a so-called un/signed exact right shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public static func &>>=(instance: inout Self, distance: Shift<Self>) {
        instance = instance &>> distance
    }
}

//*============================================================================*
// MARK: * Binary Integer x Shift x Systems
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Forms the result that fits of a so-called masked left shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public static func &<<=(instance: inout Self, shift: borrowing Self) {
        instance = instance &<< shift
    }
    
    /// Forms the result that fits of a so-called un/signed masked right shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public static func &>>=(instance: inout Self, shift: borrowing Self) {
        instance = instance &>> shift
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 2
    //=------------------------------------------------------------------------=

    /// Returns the result that fits of a so-called left shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public static func upshift(_ instance: consuming Doublet<Self>, by distance: Shift<Self>) -> Doublet<Self> {
        //=--------------------------------------=
        if !distance.value.isZero {
            instance.high  &<<= distance
            instance.high    |= Self(raw: instance.low &>> Shift<Magnitude>(raw: distance).nondistance())
            instance.low   &<<= Shift(unchecked: Magnitude(raw:  distance.value))
        }
        //=--------------------------------------=
        return instance as Doublet<Self> as Doublet<Self>
    }
    
    /// Returns the result that fits of a so-called un/signed right shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public static func downshift(_ instance: consuming Doublet<Self>, by distance: Shift<Self>) -> Doublet<Self> {
        //=--------------------------------------=
        if !distance.value.isZero {
            instance.low   &>>= Shift(unchecked: Magnitude(raw:  distance.value))
            instance.low     |= Magnitude(raw: instance.high &<< distance.nondistance())
            instance.high  &>>= distance
        }
        //=--------------------------------------=
        return instance as Doublet<Self> as Doublet<Self>
    }
}
