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
        let high = High(load: source >> T(size: Low.self))
        self.init(low: low, high: high)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<UX.BitPattern> {
        let low  = self.low .load(as: T.self)
        let high = self.high.load(as: T.self) << T(size: Low.self)
        return T.init(bitPattern: low | high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable package borrowing func count(_ bit: Bit, where selection: Bit.Selection) -> Magnitude {
        var count: UX

        switch selection {
        case .anywhere:
            
            count  = UX(load: self.low .count(bit, where: selection))
            count += UX(load: self.high.count(bit, where: selection))
        
        case .ascending:
            
            count  = UX(load: self.low .count(bit, where: selection))
            guard count == UX(size: Base.self) else { break }
            count += UX(load: self.high.count(bit, where: selection))
            
        case .descending:
            
            count  = UX(load: self.high.count(bit, where: selection))
            guard count == UX(size: Base.self) else { break }
            count += UX(load: self.low .count(bit, where: selection))
            
        }
        
        return Magnitude(load: count)
    }
}
