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
    @inlinable public static func <<=(instance: inout Self, distance: Self) {
        instance = instance << distance
    }
    
    
    /// Performs a descending smart shift.
    @inlinable public static func >>=(instance: inout Self, distance: Self) {
        instance = instance >> distance
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs an ascending smart shift.
    @inlinable public static func <<(instance: consuming Self, distance: Self) -> Self {
        if !distance.isNegative {
            return instance  .upshift(Magnitude(raw: distance))
        }   else {
            return instance.downshift(Magnitude(raw: distance.complement()))
        }
    }
    
    /// Performs a descending smart shift.
    @inlinable public static func >>(instance: consuming Self, distance: Self) -> Self {
        if !distance.isNegative {
            return instance.downshift(Magnitude(raw: distance))
        }   else {
            return instance  .upshift(Magnitude(raw: distance.complement()))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs an ascending smart shift.
    ///
    /// - Note: The `0` bit fills the void.
    ///
    @inlinable internal consuming func upshift(_ distance: Magnitude) -> Self {
        if  Shift.predicate(distance) {
            return self.upshift(Shift(unchecked: Self(raw: distance)))
        }   else {
            return Self(repeating: Bit.zero)
        }
    }
    
    /// Performs a descending smart shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable internal consuming func downshift(_ distance: Magnitude) -> Self {
        if  Shift.predicate(Magnitude(raw: distance)) {
            return self.downshift(Shift(unchecked: Self(raw: distance)))
        }   else {
            return Self(repeating: self.appendix)
        }
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
        if  let nondistance = distance.inverse() {
            instance.high   = instance.high.upshift(distance)
            instance.high  |= Self(raw: instance.low.downshift(nondistance.magnitude()))
            instance.low    = instance.low .upshift(distance.magnitude())
        }
        
        return instance as Doublet<Self> as Doublet<Self>
    }
    
    /// Performs a descending shift.
    ///
    /// - Note: The `appendix` fills the void.
    ///
    @inlinable public static func downshift(_ instance: consuming Doublet<Self>, by distance: Shift<Self>) -> Doublet<Self> {
        if  let nondistance = distance.inverse() {
            instance.low    = instance .low.downshift(distance.magnitude())
            instance.low   |= Magnitude(raw: instance.high.upshift(nondistance))
            instance.high   = instance.high.downshift(distance)
        }
        
        return instance as Doublet<Self> as Doublet<Self>
    }
}
