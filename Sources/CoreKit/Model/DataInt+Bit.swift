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

extension SomeDataIntBody {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func count(_ bit: Bit.Type) -> IX {
        let count = self.count.times(IX(size: Element.self))
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
    
    @inlinable public borrowing func count(_ bit: Bit) -> IX {
        self.count(bit, where: BitSelection.anywhere)
    }
    
    @inlinable public borrowing func count(_ selection: BitSelection.Body) -> IX {
        typealias T = BitSelection
        return switch selection {
            
        case .bit:
            self.count(Bit.self)
            
        case let .each(x):
            self.count(x, where: T.anywhere)
            
        case let .ascending(x):
            self.count(x, where: T.ascending)
            
        case let .nonascending(x):
            self.count(Bit.self).minus(self.count(x, where: T.ascending)).assert()
            
        case let .descending(x):
            self.count(x, where: T.descending)
            
        case let .nondescending(x):
            self.count(Bit.self).minus(self.count(x, where: T.descending)).assert()
        }
    }
    
    @inlinable public func count(_ bit: Bit, where selection: BitSelection) -> IX {
        typealias T = BitSelection
        var count = Fallible(IX.zero, error: false)
        switch selection {
            
        case T.anywhere:
            for index in self.indices {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
            }
            
        case T.ascending:
            for index in self.indices {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
                guard subcount == Element.size else { break }
            }
            
        case T.descending:
            for index in self.indices.reversed() {
                let subcount = self[unchecked: index].count(bit, where: selection)
                count = count.plus(IX(load: subcount))
                guard subcount == Element.size else { break }
            }
        }
        
        return count.unwrap("BinaryInteger/body/0...IX.max")
    }
}

//*============================================================================*
// MARK: * Data Int x Bit x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
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
}
