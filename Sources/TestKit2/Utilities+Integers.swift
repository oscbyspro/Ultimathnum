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
// MARK: * Utilities x Integers
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func minLikeSystemsInteger(size: IX) -> Optional<Self> {
        guard !size.isZero, Count(size) <= Self.size else {
            return nil
        }
        
        if  Self.isSigned {
            return Self(repeating: Bit.one).up(Count(size - 1))
            
        }   else {
            return Self.zero
        }
    }
    
    @inlinable public static func maxLikeSystemsInteger(size: IX) -> Optional<Self> {
        guard !size.isZero, Count(size) <= Self.size else {
            return nil
        }
                
        if  Self.isSigned {
            return Self(repeating: Bit.one).up(Count(size - 1)).toggled()

        }   else {
            return Self(repeating: Bit.one).up(Count(((size)))).toggled()
        }
    }
}

//*============================================================================*
// MARK: * Utilities x Integers x Edgy
//*============================================================================*

extension EdgyInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var all: ClosedRange<Self> {
        Self.min  ... Self.max
    }
    
    @inlinable public static var negatives: Range<Self> {
        Self.min  ..< Self.zero
    }
    
    @inlinable public static var positives: ClosedRange<Self> {
        Self.lsb  ... Self.max
    }
    
    @inlinable public static var nonnegatives: ClosedRange<Self> {
        Self.zero ... Self.max
    }
    
    @inlinable public static var nonpositives: Range<Self> {
        Self.min  ..< Self.lsb
    }
}

//*============================================================================*
// MARK: * Utilities x Integers x Partitions
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns this instance but downshifted by its ascending `bit` count.
    @inlinable public consuming func drain(_ bit: Bit) -> Self {
        self.down(self.ascending(bit))
    }
    
    /// Returns the `floor` and `ceil` of `division` by `2`.
    @inlinable public consuming func floorceil() -> (floor: Self, ceil: Self)? {
        guard let division = self.division(Nonzero(2))?.optional() else { return nil }
        return (floor: division.floor().unwrap(), ceil: division.ceil().unwrap())
    }
}

//*============================================================================*
// MARK: * Utilities x Integers x Randomness
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Picks a random value with focus on `BinaryInteger/entropy()`.
    @inlinable public static func entropic(
        as domain: Domain = Domain.binary,
        using randomness: inout some Randomness
    )   -> Self where Self: SystemsInteger {
        
        Self.entropic(through: Shift.max, as: domain, using: &randomness)
    }
    
    /// Picks a random value with focus on `BinaryInteger/entropy()`.
    @inlinable public static func entropic(
        size: IX,
        as domain: Domain = Domain.binary,
        using randomness: inout some Randomness
    )   -> Self {
        
        Self.entropic(through: Shift(Count(size - 1)), as: domain, using: &randomness)
    }
    
    /// Picks a random value with focus on `BinaryInteger/entropy()`.
    ///
    /// ### Examples: (index: one, domain: binary)
    ///
    /// ```
    /// ..signed: [-2, -1,  0,  1        ]
    /// unsigned: [         0,  1, ~1, ~0]
    /// ```
    ///
    /// ### Examples: (index: one, domain: finite)
    ///
    /// ```
    /// ..signed: [-2, -1,  0,  1        ]
    /// unsigned: [         0,  1,  2,  3]
    /// ```
    ///
    /// ### Examples: (index: one, domain: natural)
    ///
    /// ```
    /// ..signed: [         0,  1        ]
    /// unsigned: [         0,  1,  2,  3]
    /// ```
    ///
    @inlinable public static func entropic(
        through index: Shift<Magnitude>,
        as domain: Domain = Domain.binary,
        using randomness: inout some Randomness
    )   -> Self {
        
        let index = Shift.random(through: index, using: &randomness)
        switch domain {
        case Domain.binary:
            return Self(raw: Signitude.random(through: index, using: &randomness))
            
        case Domain.finite:
            return Self.random(through: index, using: &randomness)
            
        case Domain.natural:
            let random = Magnitude.random(through: index, using: &randomness)
            return Self(raw: Self.isSigned ? random.down(Shift.one) : random)
        }
    }
    
    /// Picks an `entropic` value that also fits in the `destination` type.
    @inlinable public static func entropic<Other>(
        in destination: Other.Type,
        or arbitrary: IX,
        using randomness: inout some Randomness
    )   -> Self where Other: BinaryInteger {
        
        let sourceSize = IX(size: Self.self) ?? arbitrary
        let destinationSize = IX(size: Other.self) ?? arbitrary
        var actualSize = Swift.min(sourceSize, destinationSize)
        
        if !Self.isSigned, Other.isSigned, !Other.isArbitrary {
            actualSize -= 1 // natural from unsigned to compact
        }
        
        let domain = Self.mode == Other.mode ? Domain.finite : Domain.natural
        return Self.entropic(size: actualSize, as: domain, using: &randomness)
    }
}
