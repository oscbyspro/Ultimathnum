//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Count x Read
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing public func count(_ selection: Bit.Entropy) -> IX {
        let count = self.count(.nonappendix).incremented()
        return count.unchecked("nonappendix < body.size() or body.size() == 0")
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nonappendix) -> IX {
        self.body.count(.nondescending(self.appendix))
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Write
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing public func count(_ selection: Bit.Entropy) -> IX {
        Immutable(self).count(selection)
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nonappendix) -> IX {
        Immutable(self).count(selection)
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing public func size() -> IX {
        let count = self.count.times(IX(size: Element.self))
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
    
    @inlinable borrowing public func count(_ selection: Bit) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices {
            let subcount = self[unchecked: index].count(selection)
            count = count.plus(IX(load: subcount))
        }
        
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Ascending) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices {
            let subcount = self[unchecked: index].count(selection)
            count = count.plus(IX(load: subcount))
            guard subcount == Element.size else { break }
        }
        
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Descending) -> IX {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices.reversed() {
            let subcount = self[unchecked: index].count(selection)
            count = count.plus(IX(load: subcount))
            guard subcount == Element.size else { break }
        }
        
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing public func count(_ selection: Bit.Entropy) -> IX {
        let count = self.count(.nonappendix).incremented()
        return count.unchecked("nonappendix < self.size() or self.size() == 0")
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Appendix) -> IX {
        self.count(.descending(self.appendix))
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nonappendix) -> IX {
        self.size().minus(self.count(.appendix)).unchecked("inverse bit count")
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nonascending) -> IX {
        self.size().minus(self.count( .ascending(selection.bit))).unchecked("inverse bit count")
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nondescending) -> IX {
        self.size().minus(self.count(.descending(selection.bit))).unchecked("inverse bit count")
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing public func size() -> IX {
        Immutable(self).size()
    }
    
    @inlinable borrowing public func count(_ selection: Bit) -> IX {
        Immutable(self).count(selection)
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Ascending) -> IX {
        Immutable(self).count(selection)
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Descending) -> IX {
        Immutable(self).count(selection)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing public func count(_ selection: Bit.Entropy) -> IX {
        Immutable(self).count(selection)
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Appendix) -> IX {
        Immutable(self).count(selection)
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nonappendix) -> IX {
        Immutable(self).count(selection)
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nonascending) -> IX {
        Immutable(self).count(selection)
    }
    
    @inlinable borrowing public func count(_ selection: Bit.Nondescending) -> IX {
        Immutable(self).count(selection)
    }
}
