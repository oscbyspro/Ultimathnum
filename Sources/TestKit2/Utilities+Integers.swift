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
// MARK: * Utilities x Integers x Edgy
//*============================================================================*

extension EdgyInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var all: ClosedRange<Self> {
        ClosedRange(uncheckedBounds: (Self.min, Self.max))
    }
    
    @inlinable public static var negatives: Range<Self> {
        Range(uncheckedBounds: (Self.min, Self.zero))
    }
    
    @inlinable public static var positives: ClosedRange<Self> {
        ClosedRange(uncheckedBounds: (Self.lsb, Self.max))
    }
    
    @inlinable public static var nonnegatives: ClosedRange<Self> {
        ClosedRange(uncheckedBounds: (Self.zero, Self.max))
    }
    
    @inlinable public static var nonpositives: Range<Self> {
        Range(uncheckedBounds: (Self.min, Self.lsb))
    }
}

//*============================================================================*
// MARK: * Utilities x Integers x Randomness
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func entropic(
        as domain: Domain = Domain.binary,
        using randomness: inout some Randomness
    )   -> Self where Self: SystemsInteger {
        
        Self.entropic(through: Shift.max, as: domain, using: &randomness)
    }
    
    @inlinable public static func entropic(
        size: IX,
        as domain: Domain = Domain.binary,
        using randomness: inout some Randomness
    )   -> Self {
        
        Self.entropic(through: Shift(Count(size - 1)), as: domain, using: &randomness)
    }
    
    @inlinable public static func entropic(
        through index: Shift<Magnitude>,
        as domain: Domain = Domain.binary,
        using randomness: inout some Randomness
    )   -> Self {
        
        let index = Shift.random(through: index, using: &randomness)
        
        switch domain {
        case Domain .binary: return Self(raw: Signitude.random(through: index, using: &randomness))
        case Domain .finite: return Self(raw: Magnitude.random(through: index, using: &randomness))
        case Domain.natural: return Self(raw: Self.random(through: index, using: &randomness).magnitude())
        }
    }
}
