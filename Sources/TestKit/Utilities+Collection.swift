//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit

//*============================================================================*
// MARK: * Utilities x Collection
//*============================================================================*

extension RangeReplaceableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(count: Int, next: () -> Element) {
        self.init()
        self.reserveCapacity(count)
        for _ in 0 ..< count {
            self.append(next())
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Data Integer Body
//=----------------------------------------------------------------------------=

extension BidirectionalCollection where Element: SystemsIntegerAsUnsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func asBinaryIntegerBodyNormalized() -> SubSequence {
        var subsequence: SubSequence = self[...]
        
        while let last = subsequence.last, last.isZero {
            subsequence.removeLast()
        }
        
        return subsequence as SubSequence
    }
}

extension RangeReplaceableCollection where Element: SystemsIntegerAsUnsigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public static func random(count: Swift.Int, using randomness: inout some Randomness) -> Self {
        Self.random(count: count...count, using: &randomness)
    }
    
    @inlinable public static func random(count: Range<Swift.Int>, using randomness: inout some Randomness) -> Self {
        Self.random(count: ClosedRange(count), using: &randomness)
    }
    
    @inlinable public static func random(count: ClosedRange<Swift.Int>, using randomness: inout some Randomness) -> Self {
        let min = IX(count.lowerBound)
        let max = IX(count.upperBound)
        let count = IX.random(in: min...max, using: &randomness)
        return Self(count: Swift.Int(count)) {
            Element.random(using: &randomness)
        }
    }
}
