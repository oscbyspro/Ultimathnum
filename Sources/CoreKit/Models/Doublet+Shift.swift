//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet x Shift
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<(instance: consuming Self, distance: Base) -> Doublet<Base> {
        //=--------------------------------------=
        let distance = Base.Magnitude(bitPattern: distance) & (Base.bitWidth &<< 1 &- 1)
        //=--------------------------------------=
        if  distance.load(as: UX.self) >= UX(bitWidth: Base.self) {
            instance.high     = Base(bitPattern: instance.low &<< (distance &- Base.bitWidth))
            instance.low      = Base.Magnitude(repeating: Bit(bitPattern: false))
        }   else if distance != Base.Magnitude() {
            instance.high  &<<= Base(bitPattern: distance)
            instance.high    |= Base(bitPattern: instance.low &>> (Base.bitWidth &- distance))
            instance.low   &<<= distance
        }
        //=--------------------------------------=
        return instance as Doublet<Base> as Doublet<Base>
    }
    
    @inlinable public static func &>>(instance: consuming Self, distance: Base) -> Doublet<Base> {
        //=--------------------------------------=
        let distance = Base.Magnitude(bitPattern: distance) & (Base.bitWidth &<< 1 &- 1)
        //=--------------------------------------=
        if  distance.load(as: UX.self) >= UX(bitWidth: Base.self) {
            instance.low      = Base.Magnitude(bitPattern: instance.high &>> Base(bitPattern: distance &- Base.bitWidth))
            instance.high     = Base(repeating: Bit(bitPattern: instance.high.isLessThanZero))
        }   else if distance != Base.Magnitude() {
            instance.low   &>>= distance
            instance.low     |= Base.Magnitude(bitPattern: instance.high &<< Base(bitPattern: Base.bitWidth &- distance))
            instance.high  &>>= Base(bitPattern: distance)
        }
        //=--------------------------------------=
        return instance as Doublet<Base> as Doublet<Base>
    }
}
