//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Cast Map
//*============================================================================*

@frozen public struct BitCastMap<Base, Element>: Sequence where 
Element: BitCastable, Base: Sequence, Base.Element: BitCastable,
Base.Element.BitPattern == Element.BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: consuming Base, as type: Element.Type = Element.self) {
        self.base = base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var underestimatedCount: Int {
        self.base.underestimatedCount
    }
    
    @inlinable public consuming func makeIterator() -> Iterator {
        Iterator(self.base.makeIterator())
    }
    
    //*========================================================================*
    // MARK: * Iterator
    //*========================================================================*
    
    @frozen public struct Iterator: IteratorProtocol {
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        @usableFromInline var base: Base.Iterator
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(_ base: Base.Iterator) {
            self.base = base
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable public mutating func next() -> Element? {
            self.base.next().map(Element.init(bitPattern:))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension BitCastMap: Collection where Base: Collection { }
extension BitCastMap: BidirectionalCollection where Base: BidirectionalCollection { }
extension BitCastMap:  RandomAccessCollection where Base:  RandomAccessCollection { }
extension BitCastMap where Base: Collection {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: Base.Index) -> Element {
        Element(bitPattern: self.base[index])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Base.Index {
        self.base.startIndex
    }
    
    @inlinable public var endIndex: Base.Index {
        self.base.endIndex
    }
    
    @inlinable public func index(after index: Base.Index) -> Base.Index {
        self.base.index(after: index)
    }
    
    @inlinable public func index(before index: Base.Index) -> Base.Index where Base: BidirectionalCollection {
        self.base.index(before: index)
    }
    
    @inlinable public func index(_ index: Base.Index, offsetBy distance: Int) -> Base.Index {
        self.base.index(index, offsetBy: distance)
    }
    
    @inlinable public func index(_ index: Base.Index, offsetBy distance: Int, limitedBy limit: Base.Index) -> Base.Index? {
        self.base.index(index, offsetBy: distance, limitedBy: limit)
    }
    
    @inlinable public func distance(from start: Base.Index, to end: Base.Index) -> Int {
        self.base.distance(from: start, to: end)
    }
}
