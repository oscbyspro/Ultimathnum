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
// MARK: * Doublet x Bit
//*============================================================================*

extension Doublet {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: T) where T: SystemsInteger<UX.BitPattern> {
        let low  = Low (load: source)
        let high = High(load: source >> Low.bitWidth.load(as: T.self))
        self.init(low: low, high: high)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<UX.BitPattern> {
        let low  = self.low .load(as: T.self)
        let high = self.high.load(as: T.self) << Low.bitWidth.load(as: T.self)
        return T.init(bitPattern: low | high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable package borrowing func count(_ bit: Bit, where selection: BitSelection) -> Magnitude {
        var count: UX

        switch selection {
        case .anywhere:
            
            count  = self.low .count(bit, where: selection).load(as: UX.self)
            count += self.high.count(bit, where: selection).load(as: UX.self)
        
        case .ascending:
            
            count  = self.low .count(bit, where: selection).load(as: UX.self)
            guard count == Base.bitWidth.load(as: UX.self) * 1 else { break }
            count += self.high.count(bit, where: selection).load(as: UX.self)
            
        case .descending:
            
            count  = self.high.count(bit, where: selection).load(as: UX.self)
            guard count == Base.bitWidth.load(as: UX.self) * 1 else { break }
            count += self.low .count(bit, where: selection).load(as: UX.self)
            
        }
        
        return Magnitude(load: count)
    }
}
