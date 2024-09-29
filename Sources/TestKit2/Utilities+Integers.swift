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
    
    @inlinable public static func entropic(using randomness: inout some Randomness) -> Self where Self: SystemsInteger {
        Self.entropic(through: Shift.max, using: &randomness)
    }
    
    @inlinable public static func entropic(through index: Shift<Magnitude>, using randomness: inout some Randomness) -> Self {
        let index = IX.random(in:   00000000...index.natural().unwrap(), using: &randomness)
        return Self.random(through: Shift(unchecked: Count(raw: index)), using: &randomness)
    }
    
    @inlinable public static func entropic(through index: Shift<Magnitude>, mode: Signedness, using randomness: inout some Randomness) -> Self {
        switch mode {
        case Signedness  .signed: return Self(raw: Signitude.entropic(through: index, using: &randomness))
        case Signedness.unsigned: return Self(raw: Magnitude.entropic(through: index, using: &randomness))
        }
    }
}
