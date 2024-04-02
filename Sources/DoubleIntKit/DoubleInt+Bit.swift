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
    
    @inlinable public init(bitPattern: consuming Doublet<Base>.BitPattern) {        
        self.init(low: bitPattern.low, high: Base(bitPattern: bitPattern.high))
    }
    
    @inlinable public var bitPattern: BitPattern {
        consuming get {
            BitPattern(low: self.low, high: Base.Magnitude(bitPattern: self.high))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable public init<T>(load source: T) where T: SystemsInteger<Element.BitPattern> {
        self.init(low: Low(load: source), high: High(repeating: source.appendix))
    }
    
    @inlinable public init<T>(load source: inout ExchangeInt<T, Element>.BitPattern.Stream) {
        //=--------------------------------------=
        let low  = Low (load: &source)
        let high = High(load: &source)
        //=--------------------------------------=
        self.init(low: consume low, high: consume high)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<Element.BitPattern> {
        self.low.load(as: T.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: T) where T: SystemsInteger<UX.BitPattern> {
        //=--------------------------------------=
        let low  = Low (load: source)
        let high = High(load: source >> Low.bitWidth.load(as: T.self))
        //=--------------------------------------=
        self.init(low: low, high: high)
    }
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: SystemsInteger<UX.BitPattern> {
        //=--------------------------------------=
        let low  = self.low .load(as: T.self)
        let high = self.high.load(as: T.self) << Low.bitWidth.load(as: T.self)
        //=--------------------------------------=
        return T.init(bitPattern: low | high)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        self.storage.high.appendix
    }
    
    @inlinable public var body: Magnitude._Body {
        Magnitude._Body(low: self.low.body, high: Base.Magnitude(bitPattern: self.high).body)
    }
    
    @inlinable public func count(_ bit: Bit, option: BitSelection) -> Magnitude {
        Magnitude(load: self.storage.count(bit, option: option, as: UX.self))
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
