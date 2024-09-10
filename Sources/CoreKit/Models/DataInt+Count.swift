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
    
    @inlinable public borrowing func size() -> Count {
        Count.infinity
    }
    
    @inlinable public borrowing func count(_ bit: Bit) -> Count {
        var count = self.body.count(~self.appendix)
        
        if  self.appendix == bit {
            count = Count(raw: count.base.toggled())
        }
        
        return count as Count
    }
    
    @inlinable public borrowing func ascending(_ bit: Bit) -> Count {
        let count = IX(raw: self.body.ascending(bit))
        
        if  self.appendix == bit, count == IX(raw: self.body.size()) {
            return Count.infinity
        }
        
        return Count(unchecked: count)
    }
    
    @inlinable public borrowing func descending(_ bit: Bit) -> Count {
        if  self.appendix == bit {
            let size = IX(raw: self.body.size()).toggled()
            let base = IX(raw: self.body.descending(bit))
            return Count(raw: size.plus(base).unchecked())
            
        }   else {
            return Count.zero
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Write
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public borrowing func size() -> Count {
        Count.infinity
    }
    
    @inlinable public borrowing func count(_ bit: Bit) -> Count {
        Immutable(self).count(bit)
    }
    
    @inlinable public borrowing func ascending(_ bit: Bit) -> Count {
        Immutable(self).ascending(bit)
    }
    
    @inlinable public borrowing func descending(_ bit: Bit) -> Count {
        Immutable(self).descending(bit)
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func size() -> Count {
        let count = self.count.times(IX(size: Element.self))
        return Count(unchecked: count.unchecked("BinaryInteger/entropy/0...IX.max"))
    }
    
    @inlinable public borrowing func count(_ bit: Bit) -> Count {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices {
            let subcount = self[unchecked: index].count(bit)
            count = count.plus(subcount.natural().unchecked())
        }
        
        return Count(unchecked: count.unchecked("BinaryInteger/entropy/0...IX.max"))
    }
    
    @inlinable public borrowing func ascending(_ bit: Bit) -> Count {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices {
            let subcount = self[unchecked: index].ascending(bit)
            count = count.plus(subcount.natural().unchecked())
            guard subcount == Element.size else { break }
        }
        
        return Count(unchecked: count.unchecked("BinaryInteger/entropy/0...IX.max"))
    }
    
    @inlinable public borrowing func descending(_ bit: Bit) -> Count {
        var count = Fallible(IX.zero, error: false)
        
        for index in self.indices.reversed() {
            let subcount = self[unchecked: index].descending(bit)
            count = count.plus(subcount.natural().unchecked())
            guard subcount == Element.size else { break }
        }
        
        return Count(unchecked: count.unchecked("BinaryInteger/entropy/0...IX.max"))
    }
}

//*============================================================================*
// MARK: * Data Int x Count x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func size() -> Count {
        Immutable(self).size()
    }
    
    @inlinable public borrowing func count(_ bit: Bit) -> Count {
        Immutable(self).count(bit)
    }
    
    @inlinable public borrowing func ascending(_ bit: Bit) -> Count {
        Immutable(self).ascending(bit)
    }
    
    @inlinable public borrowing func descending(_ bit: Bit) -> Count {
        Immutable(self).descending(bit)
    }
}
