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
    
    @inlinable public static func <<(instance: consuming Self, shift: Self) -> Self {
        if  shift.isLessThanZero {
            return instance >> -shift // TODO: no not trap on min
        }   else if Magnitude(bitPattern: shift) >= Self.bitWidth {
            return Self(repeating: Bit(bitPattern: false))
        }   else {
            return instance &<< shift
        }
    }
    
    @inlinable public static func >>(instance: consuming Self, shift: Self) -> Self {
        if  shift.isLessThanZero {
            return instance << -shift // TODO: no not trap on min
        }   else if Magnitude(bitPattern: shift) >= Self.bitWidth {
            return Self(repeating: Bit(bitPattern: instance.isLessThanZero))
        }   else {
            return instance &>> shift
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &<<(instance: consuming Self, shift: Self) -> Self {
        Self(TBI.bitShiftL22(instance.storage, by: Base(bitPattern: shift.low & (Self.bitWidth &- 1).low)))
    }
    
    @inlinable public static func &>>(instance: consuming Self, shift: Self) -> Self {
        Self(TBI.bitShiftR22(instance.storage, by: Base(bitPattern: shift.low & (Self.bitWidth &- 1).low)))
    }
}
