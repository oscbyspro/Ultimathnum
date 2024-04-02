//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Doublet x Bit
//*============================================================================*

extension Doublet: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Doublet<Base.Magnitude>) {
        self.init(
            low:  bitPattern.low,
            high: Base(bitPattern: bitPattern.high)
        )
    }
    
    @inlinable public var bitPattern: Doublet<Base.Magnitude> {
        consuming get {
            Doublet<Base.Magnitude>(
                low:  self.low,
                high: Base.Magnitude(bitPattern: self.high)
            )
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
            
    @inlinable public var appendix: Bit {
        self.high.appendix
    }
        
    @inlinable public func count(_ bit: Bit, option: BitSelection, as type: UX.Type) -> UX {
        var count: UX

        switch option {
        case .all:
            
            count  = self.low .count(bit, option: option).load(as: UX.self)
            count += self.high.count(bit, option: option).load(as: UX.self)
        
        case .ascending:
            
            count  = self.low .count(bit, option: option).load(as: UX.self)
            guard count == Base.bitWidth.load(as: UX.self) * 1 else { break }
            count += self.high.count(bit, option: option).load(as: UX.self)
            
        case .descending:
            
            count  = self.high.count(bit, option: option).load(as: UX.self)
            guard count == Base.bitWidth.load(as: UX.self) * 1 else { break }
            count += self.low .count(bit, option: option).load(as: UX.self)
            
        }
        
        return count as UX
    }
}
