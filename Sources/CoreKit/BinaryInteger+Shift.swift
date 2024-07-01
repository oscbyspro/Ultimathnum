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
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable public static func <<=(instance: inout Self, distance: Self) {
        instance = instance << distance
    }
    
    /// Performs an ascending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable public static func <<(instance: consuming Self, distance: Self) -> Self {
        if !distance.isNegative {
            return instance  .up(Magnitude(raw: distance))
        }   else {
            return instance.down(Magnitude(raw: distance.complement()))
        }
    }
    
    /// Performs a descending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable public static func >>=(instance: inout Self, distance: Self) {
        instance = instance >> distance
    }
    
    /// Performs a descending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable public static func >>(instance: consuming Self, distance: Self) -> Self {
        if !distance.isNegative {
            return instance.down(Magnitude(raw: distance))
        }   else {
            return instance  .up(Magnitude(raw: distance.complement()))
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
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable internal consuming func up(_ distance: Magnitude) -> Self {
        if  let distance = Shift(exactly: distance) {
            return self.up(distance)
        }   else {
            return Self(repeating: Bit.zero)
        }
    }
    
    /// Performs a descending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable internal consuming func down(_ distance: Magnitude) -> Self {
        if  let distance = Shift(exactly: distance) {
            return self.down(distance)
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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs an ascending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &<<=(instance: inout Self, distance: Self) {
        instance = instance &<< distance
    }
    
    /// Performs an ascending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &<<(instance: consuming Self, distance: Self) -> Self {
        instance.up(Shift(unchecked: Magnitude(raw: distance) & Self.size.decremented().unchecked()))
    }
    
    /// Performs a descending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &>>=(instance: inout Self, distance: Self) {
        instance = instance &>> distance
    }
    /// Performs a descending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &>>(instance: consuming Self, distance: Self) -> Self {
        instance.down(Shift(unchecked: Magnitude(raw: distance) & Self.size.decremented().unchecked()))
    }
}
