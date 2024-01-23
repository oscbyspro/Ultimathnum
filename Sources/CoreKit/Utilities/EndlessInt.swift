//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Endless Int
//*============================================================================*

@frozen public struct EndlessInt<Base> where Base: RandomAccessCollection, Base.Element: SystemsInteger & UnsignedInteger {
    
    public typealias Element = Base.Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let base: Base
    public let endlessLast: Element
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base, endlessLast: Bit) {
        self.init(unchecked: base, endlessLast: Element(repeating: endlessLast))
    }
    
    @inlinable public init(unchecked base: Base, endlessLast: Element) {
        self.base = base
        self.endlessLast = endlessLast
        Swift.assert(endlessLast.count(1, option: .all) % Element.bitWidth == 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func load(as type: UX.Type) -> UX {
        fatalError("TODO")
    }
    
    @inlinable public func stream() -> Stream {
        Stream(self.base.makeIterator(), endlessLast: self.endlessLast)
    }
    
    //*========================================================================*
    // MARK: * Stream
    //*========================================================================*
    
    @frozen public struct Stream {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var base: Base.Iterator
        @usableFromInline let endlessLast: Element
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ base: Base.Iterator, endlessLast: Element) {
            self.base = base; self.endlessLast = endlessLast
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable mutating public func next() -> Element {
            self.base.next() ?? self.endlessLast
        }
    }
}
