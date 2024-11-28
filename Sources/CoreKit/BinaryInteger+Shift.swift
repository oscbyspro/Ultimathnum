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
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func <<=(instance: inout Self, distance: some BinaryInteger) {
        instance = instance << distance
    }
    
    /// Performs an ascending smart shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func <<(instance: consuming Self, distance: some BinaryInteger) -> Self {
        if  distance.isInfinite {
            return instance.up(Count.infinity)
        }
        //=--------------------------------------=
        let limit = IX(size: Self.self)?.decremented().unchecked() ?? IX.max
        //=--------------------------------------=
        if  distance.isNegative {
            
            if  distance >= limit.complement() {
                return instance.down(Shift(unchecked: Count(Natural(unchecked: IX(load: distance).complement()))))
                
            }   else {
                return instance.down(Count.infinity)
            }
            
        }   else {

            if  distance <= UX(raw: limit) {
                return instance.up(Shift(unchecked: Count(Natural(unchecked: IX(load: distance)))))
                
            }   else if !Self.isArbitrary {
                return instance.up(Count.infinity)
                
            }   else {
                return instance.veto({ !$0.isZero }).unwrap(String.overallocation())
            }
            
        }
    }
    
    /// Performs a descending smart shift.
    /// 
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func >>=(instance: inout Self, distance: some BinaryInteger) {
        instance = instance >> distance
    }
    
    /// Performs a descending smart shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func >>(instance: consuming Self, distance: some BinaryInteger) -> Self {
        if  distance.isInfinite {
            return instance.down(Count.infinity)
        }
        //=--------------------------------------=
        let limit = IX(size: Self.self)?.decremented().unchecked() ?? IX.max
        //=--------------------------------------=
        if  distance.isNegative {
            
            if  distance >= limit.complement() {
                return instance.up(Shift(unchecked: Count(Natural(unchecked: IX(load: distance).complement()))))
                
            }   else if !Self.isArbitrary {
                return instance.up(Count.infinity)
                
            }   else {
                return instance.veto({ !$0.isZero }).unwrap(String.overallocation())
            }
            
        }   else {

            if  distance <= UX(raw: limit) {
                return instance.down(Shift(unchecked: Count(Natural(unchecked: IX(load: distance)))))
                
            }   else {
                return instance.down(Count.infinity)
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
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func <<=(instance: inout Self, distance: Swift.Int) {
        instance <<= IX(distance)
    }
    
    /// Performs an ascending smart shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func <<(instance: consuming Self, distance: Swift.Int) -> Self {
        instance <<  IX(distance)
    }
    
    /// Performs a descending smart shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func >>=(instance: inout Self, distance: Swift.Int) {
        instance >>= IX(distance)
    }
    
    /// Performs a descending smart shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
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
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public consuming func up(_ distance: Count) -> Self {
        if  let distance = Shift<Magnitude>(exactly: distance) {
            return self.up(distance)
        }   else {
            return Self(repeating: Bit.zero)
        }
    }
    
    /// Performs a descending smart shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public consuming func down(_ distance: Count) -> Self {
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
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &<<=(instance: inout Self, distance: some BinaryInteger) {
        instance = instance &<< distance
    }
    
    /// Performs an ascending masked shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &<<(instance: consuming Self, distance: some BinaryInteger) -> Self {
        instance.up(Shift(masking: distance))
    }
    
    /// Performs a descending masked shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &>>=(instance: inout Self, distance: some BinaryInteger) {
        instance = instance &>> distance
    }
    
    /// Performs a descending masked shift.
    ///
    /// ### Binary Integer Shift
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
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &<<=(instance: inout Self, distance: Swift.Int) {
        instance &<<= IX(distance)
    }
    
    /// Performs an ascending masked shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &<<(instance: consuming Self, distance: Swift.Int) -> Self {
        instance &<<  IX(distance)
    }
    
    /// Performs a descending masked shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &>>=(instance: inout Self, distance: Swift.Int) {
        instance &>>= IX(distance)
    }
    
    /// Performs a descending masked shift.
    ///
    /// ### Binary Integer Shift
    ///
    /// - Note: The filler bit is either `0` (up) or `appendix` (down).
    ///
    @inlinable public static func &>>(instance: consuming Self, distance: Swift.Int) -> Self {
        instance &>>  IX(distance)
    }
}
