//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Triplet x Bit
//*============================================================================*

extension Triplet: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Triplet<Base.Magnitude>) {
        self.init(
            low:  bitPattern.low,
            mid:  bitPattern.mid,
            high: Base(bitPattern: bitPattern.high)
        )
    }
    
    @inlinable public var bitPattern: Triplet<Base.Magnitude> {
        consuming get {
            Triplet<Base.Magnitude>(
                low:  self.low,
                mid:  self.mid,
                high: Base.Magnitude(bitPattern: self.high)
            )
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable public func count(_ bit: Bit, option: BitSelection, as type: UX.Type) -> UX {
        var count: UX

        switch option {
        case .all:
            
            count  = self.low .count(bit, option: option).load(as: UX.self)
            count += self.mid .count(bit, option: option).load(as: UX.self)
            count += self.high.count(bit, option: option).load(as: UX.self)
        
        case .ascending:
            
            count  = self.low .count(bit, option: option).load(as: UX.self)
            guard count == Base.bitWidth.load(as: UX.self) * 1 else { break }
            count += self.mid .count(bit, option: option).load(as: UX.self)
            guard count == Base.bitWidth.load(as: UX.self) * 2 else { break }
            count += self.high.count(bit, option: option).load(as: UX.self)
            
        case .descending:
            
            count  = self.high.count(bit, option: option).load(as: UX.self)
            guard count == Base.bitWidth.load(as: UX.self) * 1 else { break }
            count += self.mid .count(bit, option: option).load(as: UX.self)
            guard count == Base.bitWidth.load(as: UX.self) * 2 else { break }
            count += self.low .count(bit, option: option).load(as: UX.self)
            
        }
        
        return count as UX
    }
}
