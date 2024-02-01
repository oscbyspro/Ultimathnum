//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Shift
//*============================================================================*

extension Namespace.TupleBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable package static func bitShiftL11(_ instance: consuming Base, by shift: Base) -> Base {
        instance &<< shift
    }
    
    @inlinable package static func bitShiftR11(_ instance: consuming Base, by shift: Base) -> Base {
        instance &>> shift
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable package static func bitShiftL12(_ instance: consuming Base, by shift: Base) -> Doublet<Base> {
        let overshift = shift == Base() ? Base() : self.bitShiftR11(copy instance, by: shift)
        instance = self.bitShiftL11(instance, by: shift)
        return Doublet(low: Base.Magnitude(bitPattern: instance), high: overshift)
    }
    
    @inlinable package static func bitShiftL23(_ instance: consuming Doublet<Base>, by shift: Base) -> Triplet<Base> {
        let overshift = shift == Base() ? Base() : self.bitShiftR11(instance.high, by: shift)
        instance = self.bitShiftL22(instance, by: shift)
        return Triplet(low: instance.low, mid: Base.Magnitude(bitPattern: instance.high), high: overshift)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable package static func bitShiftL22(_ instance: consuming Doublet<Base>, by shift: Base) -> Doublet<Base> {
        //=--------------------------------------=
        let shift: Base.Magnitude = Base.Magnitude(bitPattern: shift) & (Base.bitWidth &<< 1 &- 1)
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
        return instance as Doublet<Base> as Doublet<Base>
    }
    
    @inlinable package static func bitShiftR22(_ instance: consuming Doublet<Base>, by shift: Base) -> Doublet<Base> {
        //=--------------------------------------=
        let shift: Base.Magnitude = Base.Magnitude(bitPattern: shift) & (Base.bitWidth &<< 1 &- 1)
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
        return instance as Doublet<Base> as Doublet<Base>
    }
}
