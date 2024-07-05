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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs an ascending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable public static func <<=(instance: inout Self, distance: some BinaryInteger) {
        instance = instance << distance
    }
    
    /// Performs an ascending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable public static func <<(instance: consuming Self, distance: some BinaryInteger) -> Self {
        //=--------------------------------------=
        if  distance.isInfinite {
            return instance.up(Count.infinity)
        }
        //=--------------------------------------=
        let max = Self.size.isInfinite ? IX.max : IX(raw: Shift<Magnitude>.max.value)
        //=--------------------------------------=
        if  distance.isNegative {
            
            if  distance >= max.complement() {
                return instance.down(Shift(unchecked: Count(unchecked: IX(load: distance).complement())))
                
            }   else {
                return instance.down(Count.infinity) // flush >= IX.max as per protocol
            }
            
        }   else {

            if  distance <= UX(raw: max) {
                return instance.up(Shift(unchecked: Count(unchecked: IX(load: distance))))
                
            }   else {
                return instance.up(Count.infinity) //.. flush >= IX.max as per protocol
            }
            
        }
    }
    
    /// Performs a descending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable public static func >>=(instance: inout Self, distance: some BinaryInteger) {
        instance = instance >> distance
    }
    
    /// Performs a descending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: A `distance` greater than `IX.max` is a directional flush.
    ///
    @inlinable public static func >>(instance: consuming Self, distance: some BinaryInteger) -> Self {
        //=--------------------------------------=
        if  distance.isInfinite {
            return instance.down(Count.infinity)
        }
        //=--------------------------------------=
        let max = Self.size.isInfinite ? IX.max : IX(raw: Shift<Magnitude>.max.value)
        //=--------------------------------------=
        if  distance.isNegative {
            
            if  distance >= max.complement() {
                return instance.up(Shift(unchecked: Count(unchecked: IX(load: distance).complement())))
                
            }   else {
                return instance.up(Count.infinity) //.. flush >= IX.max as per protocol
            }
            
        }   else {

            if  distance <= UX(raw: max) {
                return instance.down(Shift(unchecked: Count(unchecked: IX(load: distance))))
                
            }   else {
                return instance.down(Count.infinity) // flush >= IX.max as per protocol
            }
            
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Disambiguation
//=----------------------------------------------------------------------------=

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs an ascending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: The default integer literal is `Swift.Int`.
    ///
    @inlinable public static func <<=(instance: inout Self, distance: Swift.Int) {
        instance <<= IX(distance)
    }
    
    /// Performs an ascending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: The default integer literal is `Swift.Int`.
    ///
    @inlinable public static func <<(instance: consuming Self, distance: Swift.Int) -> Self {
        instance <<  IX(distance)
    }
    
    /// Performs a descending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: The default integer literal is `Swift.Int`.
    ///
    @inlinable public static func >>=(instance: inout Self, distance: Swift.Int) {
        instance >>= IX(distance)
    }
    /// Performs a descending smart shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: The default integer literal is `Swift.Int`.
    ///
    @inlinable public static func >>(instance: consuming Self, distance: Swift.Int) -> Self {
        instance >>  IX(distance)
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
    /// - Note: This method improves `Count<IX>` ergonomics.
    ///
    @inlinable public consuming func up(_ distance: Count<IX>) -> Self {
        if  let distance = Shift<Magnitude>(exactly: distance) {
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
    /// - Note: This method improves `Count<IX>` ergonomics.
    ///
    @inlinable public consuming func down(_ distance: Count<IX>) -> Self {
        if  let distance = Shift<Magnitude>(exactly: distance) {
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
    @inlinable public static func &<<=(instance: inout Self, distance: some BinaryInteger) {
        instance = instance &<< distance
    }
    
    /// Performs an ascending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &<<(instance: consuming Self, distance: some BinaryInteger) -> Self {
        instance.up(Shift(masking: distance))
    }
    
    /// Performs a descending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &>>=(instance: inout Self, distance: some BinaryInteger) {
        instance = instance &>> distance
    }
    /// Performs a descending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &>>(instance: consuming Self, distance: some BinaryInteger) -> Self {
        instance.down(Shift(masking: distance))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Disambiguation
//=----------------------------------------------------------------------------=

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Performs an ascending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: The default integer literal is `Swift.Int`.
    ///
    @inlinable public static func &<<=(instance: inout Self, distance: Swift.Int) {
        instance &<<= IX(distance)
    }
    
    /// Performs an ascending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: The default integer literal is `Swift.Int`.
    ///
    @inlinable public static func &<<(instance: consuming Self, distance: Swift.Int) -> Self {
        instance &<<  IX(distance)
    }
    
    /// Performs a descending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: The default integer literal is `Swift.Int`.
    ///
    @inlinable public static func &>>=(instance: inout Self, distance: Swift.Int) {
        instance &>>= IX(distance)
    }
    /// Performs a descending masked shift.
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    /// - Note: The default integer literal is `Swift.Int`.
    ///
    @inlinable public static func &>>(instance: consuming Self, distance: Swift.Int) -> Self {
        instance &>>  IX(distance)
    }
}
