//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int x Bitwise
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(instance: consuming Self) -> Self {
        Self(low: ~instance.storage.low, high: ~instance.storage.high)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(low: lhs.storage.low & rhs.storage.low, high: lhs.storage.high & rhs.storage.high)
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(low: lhs.storage.low | rhs.storage.low, high: lhs.storage.high | rhs.storage.high)
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(low: lhs.storage.low ^ rhs.storage.low, high: lhs.storage.high ^ rhs.storage.high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func complement(_ increment: consuming Bool) -> Fallible<Self> {
        Fallible(raw: self.storage.complement(increment))
    }

    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ bit: Bit, where selection: Bit.Selection) -> Magnitude {
        var count: UX

        switch selection {
        case .anywhere:
            
            count  = UX(load: self.storage.low .count(bit, where: selection))
            count += UX(load: self.storage.high.count(bit, where: selection))
        
        case .ascending:
            
            count  = UX(load: self.storage.low .count(bit, where: selection))
            guard count == UX(size: Base.self) else { break }
            count += UX(load: self.storage.high.count(bit, where: selection))
            
        case .descending:
            
            count  = UX(load: self.storage.high.count(bit, where: selection))
            guard count == UX(size: Base.self) else { break }
            count += UX(load: self.storage.low .count(bit, where: selection))
            
        }
        
        return Magnitude(load: count)
    }
}
