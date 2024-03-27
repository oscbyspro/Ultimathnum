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
        self.high.appendix
    }
    
    @inlinable public var content: Magnitude._Content {
        Magnitude._Content(low: self.low.content, high: Base.Magnitude(bitPattern: self.high).content)
    }
    
    @inlinable public func count(_ bit: Bit, option: Bit.Selection) -> Magnitude {
        var count: Magnitude
        
        switch option {
        case .all:
            
            brr: do {
                count  = Magnitude(low: self.low .count(bit, option: option))
                count += Magnitude(low: self.high.count(bit, option: option))
            }
        
        case .ascending:
                        
            brr: do {
                count  = Magnitude(low: self.low .count(bit, option: option))
            };  if count.low == Low.bitWidth {
                count += Magnitude(low: self.high.count(bit, option: option))
            }
            
        case .descending:
            
            brr: do {
                count  = Magnitude(low: self.high.count(bit, option: option))
            };  if count.low == High.bitWidth {
                count += Magnitude(low: self.low .count(bit, option: option))
            }
            
        }
        
        return count as Magnitude
    }
}

//*============================================================================*
// MARK: * Double Int x Bit x Unsigned
//*============================================================================*

extension DoubleInt where Base == Base.Magnitude {
    
    //*========================================================================*
    // MARK: * Content
    //*========================================================================*
    
    @frozen public struct _Content: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        #if _endian(big)
        @usableFromInline var high: Base.Content
        @usableFromInline var low:  Base.Content
        #else
        @usableFromInline var low:  Base.Content
        @usableFromInline var high: Base.Content
        #endif
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(low: consuming Base.Content, high: consuming Base.Content) {
            self.low  = low
            self.high = high
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
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
        
        @inlinable public subscript(index: Int) -> Base.Content.Element {
            if  index  < self.low.count {
                return self.low [self.low .index(self.low .startIndex, offsetBy: index)]
            }   else {
                return self.high[self.high.index(self.high.startIndex, offsetBy: index - self.low.count)]
            }
        }
    }
}
