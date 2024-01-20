//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Int x Words x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: UX) {
        self.init(bitPattern: source & 1 == 1)
    }
    
    @inlinable public init<T>(load source: Pattern<T>) {
        self.init(load: source.load(as: UX.self))
    }
    
    @inlinable public func load(as type: UX.Type) -> UX {
        UX(repeating: U1(bitPattern: self.bitPattern))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        Words(self)
    }
    
    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    @frozen public struct Words: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var base: BitInt
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: BitInt) {
            self.base = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var startIndex: UInt {
            0
        }
        
        @inlinable public var endIndex: UInt {
            1
        }
        
        @inlinable public subscript(index: UInt) -> UX {
            //=----------------------------------=
            precondition(index >= 0, .indexOutOfBounds())
            //=----------------------------------=
            return self.base.load(as: UX.self)
        }
    }
}

//*============================================================================*
// MARK: * Bit Int x Words x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: UX) {
        self.init(bitPattern: source & 1 == 1)
    }
    
    @inlinable public init<T>(load source: Pattern<T>) {
        self.init(load: source.load(as: UX.self))
    }
    
    @inlinable public func load(as type: UX.Type) -> UX {
        self.bitPattern ? 1 as UX : 0 as UX
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var words: Words {
        Words(self)
    }

    //*========================================================================*
    // MARK: * Words
    //*========================================================================*
    
    @frozen public struct Words: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var base: BitInt.Magnitude
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: BitInt.Magnitude) {
            self.base = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var startIndex: UInt {
            0
        }
        
        @inlinable public var endIndex: UInt {
            1
        }
        
        @inlinable public subscript(index: UInt) -> UX {
            //=----------------------------------=
            precondition(index >= 0, .indexOutOfBounds())
            //=----------------------------------=
            return index == 0 ? self.base.load(as: UX.self) : 0
        }
    }
}
