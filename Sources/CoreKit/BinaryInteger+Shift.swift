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

    /// Performs an ascending smart shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public static func  <<=(instance: inout Self, distance: Self) {
        instance = instance  << distance
    }
    
    /// Performs an ascending exact shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public static func &<<=(instance: inout Self, distance: Shift<Self>) {
        instance = instance &<< distance
    }
    
    /// Performs a descending smart shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public static func  >>=(instance: inout Self, distance: Self) {
        instance = instance  >> distance
    }

    /// Performs a descending exact shift.
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
    
    /// Performs an ascending masked shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public static func &<<=(instance: inout Self, shift: borrowing Self) {
        instance = instance &<< shift
    }
    
    /// Performs a descending masked shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public static func &>>=(instance: inout Self, shift: borrowing Self) {
        instance = instance &>> shift
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2 by 1 as 2
    //=------------------------------------------------------------------------=

    /// Performs an ascending shift.
    ///
    ///  - Note: The `0` bit fills the void.
    ///
    @inlinable public static func upshift(_ instance: consuming Doublet<Self>, by distance: Shift<Self>) -> Doublet<Self> {
        if  let nondistance  = distance.inverse() {
            instance.high &<<= distance
            instance.high   |= Self(raw: instance.low &>> Shift<Magnitude>(raw: nondistance))
            instance.low  &<<= Shift<Magnitude>(raw: distance)
        }
        
        return instance as Doublet<Self> as Doublet<Self>
    }
    
    /// Performs a descending shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public static func downshift(_ instance: consuming Doublet<Self>, by distance: Shift<Self>) -> Doublet<Self> {
        if  let nondistance  = distance.inverse() {
            instance.low  &>>= Shift<Magnitude>(raw: distance)
            instance.low    |= Magnitude(raw: instance.high &<< nondistance)
            instance.high &>>= distance
        }
        
        return instance as Doublet<Self> as Doublet<Self>
    }
}
