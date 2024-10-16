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
        
        return Count(Natural(unchecked: count))
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
        let part  = IX(size: Element.self)
        let count = self.count.times(part).unchecked("BinaryInteger/entropy/0...IX.max")
        return Count(Natural(unchecked: count))
    }
    
    @inlinable public borrowing func count(_ bit: Bit) -> Count {
        var count = IX.zero
        
        for index in self.indices {
            let part = self[unchecked: index].count(bit).natural().unchecked()
            count = count.plus(part).unchecked("BinaryInteger/entropy/0...IX.max")
        }
        
        return Count(Natural(unchecked: count))
    }
    
    @inlinable public borrowing func ascending(_ bit: Bit) -> Count {
        var count = IX.zero
        
        for index in self.indices {
            let part = self[unchecked: index].ascending(bit).natural().unchecked()
            count = count.plus(part).unchecked("BinaryInteger/entropy/0...IX.max")
            guard part == IX(size: Element.self) else { break }
        }
        
        return Count(Natural(unchecked: count))
    }
    
    @inlinable public borrowing func descending(_ bit: Bit) -> Count {
        var count = IX.zero
        
        for index in self.indices.reversed() {
            let part = self[unchecked: index].descending(bit).natural().unchecked()
            count = count.plus(part).unchecked("BinaryInteger/entropy/0...IX.max")
            guard part == IX(size: Element.self) else { break }
        }
        
        return Count(Natural(unchecked: count))
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
