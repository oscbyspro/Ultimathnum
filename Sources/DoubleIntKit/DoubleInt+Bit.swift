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
// MARK: * Double Int x Bit
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Storage.BitPattern) {
        self.init(Storage(bitPattern: bitPattern))
    }
    
    @inlinable public var bitPattern: BitPattern {
        consuming get {
            self.storage.bitPattern
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  UX.Signitude) {
        self.init(Storage(load: source))
    }
    
    @inlinable public init(load source: consuming  UX.Magnitude) {
        self.init(Storage(load: source))
    }
    
    @inlinable public borrowing func load(as type: UX.BitPattern.Type) -> UX.BitPattern {
        self.storage.load(as: UX.self).bitPattern
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming  Element.Signitude) {
        let appendix = source.appendix
        self.init(low: Low(load: source), high: High(repeating: appendix))
    }
    
    @inlinable public init(load source: consuming  Element.Magnitude) {
        let appendix = source.appendix
        self.init(low: Low(load: source), high: High(repeating: appendix))
    }
    
    @inlinable public borrowing func load(as type: Element.BitPattern.Type) -> Element.BitPattern {
        self.storage.low.load(as: Element.BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    #warning("new")
    @inlinable public init(load source: inout MemoryInt.Iterator) {
        //=--------------------------------------=
        let low  = Low (load: &source)
        let high = High(load: &source)
        //=--------------------------------------=
        self.init(low: consume low, high: consume high)
    }

    #warning("old")
    @inlinable public init<T>(load source: inout ExchangeInt<T, Element>.BitPattern.Stream) {
        //=--------------------------------------=
        let low  = Low (load: &source)
        let high = High(load: &source)
        //=--------------------------------------=
        self.init(low: consume low, high: consume high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        self.storage.high.appendix
    }
    
    #warning("new")
    /// ### Development
    ///
    /// The current type is a placeholder for some future buffer view.
    ///
    @inlinable public var data: [UInt8] {
        Swift.withUnsafeBytes(of: self, [UInt8].init)
    }

    #warning("old")
    @inlinable public var body: Magnitude._Body {
        Magnitude._Body(low: self.low.body, high: Base.Magnitude(bitPattern: self.high).body)
    }
    
    @inlinable public borrowing func count(_ bit: Bit, where selection: BitSelection) -> Magnitude {
        Magnitude(self.storage.count(bit, where: selection))
    }
    
    @inlinable public consuming func complement(_ increment: consuming Bool) -> Fallible<Self> {
        Fallible(bitPattern: self.storage.complement(increment))
    }
}

//*============================================================================*
// MARK: * Double Int x Bit x Unsigned
//*============================================================================*

extension DoubleInt where Base == Base.Magnitude {
    
    //*========================================================================*
    // MARK: * Body
    //*========================================================================*
    
    @frozen public struct _Body: RandomAccessCollection {
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        #if _endian(big)
        @usableFromInline var high: Base.Body
        @usableFromInline var low:  Base.Body
        #else
        @usableFromInline var low:  Base.Body
        @usableFromInline var high: Base.Body
        #endif
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable public init(low: consuming Base.Body, high: consuming Base.Body) {
            self.low  = low
            self.high = high
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable public var count: Int {
            self.low.count + self.high.count // pray for compile time constant
        }
        
        @inlinable public var startIndex: Int {
            0 as Int
        }
        
        @inlinable public var endIndex: Int {
            self.count
        }
        
        @inlinable public var indices: Range<Int> {
            0 as Int ..< self.count
        }
        
        @inlinable public func distance(from start: Int, to end: Int) -> Int {
            end - start
        }
        
        @inlinable public func index(after index: Int) -> Int {
            index + 1 as Int
        }
        
        @inlinable public func index(before index: Int) -> Int {
            index - 1 as Int
        }
        
        @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
            index + distance
        }
        
        @inlinable public subscript(index: Int) -> Base.Body.Element {
            if  index  < self.low.count {
                return self.low [self.low .index(self.low .startIndex, offsetBy: index)]
            }   else {
                return self.high[self.high.index(self.high.startIndex, offsetBy: index - self.low.count)]
            }
        }
    }
}
