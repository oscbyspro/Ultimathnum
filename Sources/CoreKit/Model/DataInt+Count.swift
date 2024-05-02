//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Count x Body
//*============================================================================*

extension SomeDataIntBody {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func size() -> IX {
        let count = self.count.times(IX(size: Element.self))
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Anywhere<Self>.Type) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices {
            let subcount = self[unchecked: index].count(.anywhere(bit))
            count = count.plus(IX(load: subcount))
        }
        
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Ascending<Self>.Type) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices {
            let subcount = self[unchecked: index].count(.ascending(bit))
            count = count.plus(IX(load: subcount))
            guard subcount == Element.size else { break }
        }
        
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
    
    @inlinable public func count(_ bit: Bit, where selection: Bit.Descending<Self>.Type) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices.reversed() {
            let subcount = self[unchecked: index].count(.descending(bit))
            count = count.plus(IX(load: subcount))
            guard subcount == Element.size else { break }
        }
        
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
}
