//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Bit x Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ bit: Bit.Type) -> IX {
        let count = self.count.times(IX(size: Element.self))
        return count.unwrap("binary integer body may store at most IX.max bits per protocol")
    }
    
    @inlinable public borrowing func count(_ bit: Bit) -> IX {
        self.count(bit, where: BitSelection.anywhere)
    }
    
    @inlinable public borrowing func count(_ selection: BitSelection.Body) -> IX {
        typealias T = BitSelection
        typealias E = BitSelection.Instruction
        return switch selection {
            
        case .bit:
            self.count(Bit.self)
            
        case let .each(bit):
            self.count(bit, where: T.anywhere)
            
        case let .ascending(bit):
            self.count(bit, where: T.ascending)
            
        case let .nonascending(bit):
            self.count(Bit.self).minus(self.count(bit, where: T.ascending )).assert()
            
        case let .descending(bit):
            self.count(bit, where: T.descending)
            
        case let .nondescending(bit):
            self.count(Bit.self).minus(self.count(bit, where: T.descending)).assert()
        }
    }
    
    @inlinable public borrowing func count(_ bit: Bit, where selection: BitSelection) -> IX {
        var count = Fallible(IX.zero, error: false)
        switch selection {
            
        case BitSelection.anywhere:
            for index in self.indices {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
            }
            
        case BitSelection.ascending:
            for index in self.indices {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
                guard subcount == Element.size else { break }
            }
            
        case BitSelection.descending:
            for index in self.indices.reversed() {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
                guard subcount == Element.size else { break }
            }
        }
        
        return count.unwrap("binary integer body may store at most IX.max bits per protocol")
    }
}

//*============================================================================*
// MARK: * Data Int x Bit x Canvas
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Toggles each bit in its binary representation.
    @inlinable public borrowing func toggle() {
        for index in self.indices {
            self[unchecked: index][{ $0.toggled() }]
        }
    }
    
    /// Toggles each bit in its binary representation then adds `increment`.
   @inlinable public borrowing func toggle(carrying increment: consuming Bool) -> Bool {
        for index in self.indices {
            increment = self[unchecked: index][{ $0.complement(increment) }]
        }
        
        return increment as Bool
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count(_ bit: Bit.Type) -> IX {
        Body(self).count(bit)
    }
    
    @inlinable public borrowing func count(_ bit: Bit) -> IX {
        Body(self).count(bit)
    }
    
    @inlinable public borrowing func count(_ selection: BitSelection.Body) -> IX {
        Body(self).count(selection)
    }
    
    @inlinable public borrowing func count(_ bit: Bit, where selection: BitSelection) -> IX {
        Body(self).count(bit, where: selection)
    }
}
