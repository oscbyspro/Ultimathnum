//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Prefix x Bit Pattern
//*============================================================================*

extension ExchangeInt where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func prefix(_ count: Int) -> Prefix {
        Prefix(self.bitPattern, count: count)
    }
    
    //*========================================================================*
    // MARK: * Prefix
    //*========================================================================*
    
    @frozen public struct Prefix: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let base: ExchangeInt
        public let count: Int
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ base: ExchangeInt, count: Int) {
            self.base  = base
            self.count = count
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var `extension`: Bit.Extension<Element> {
            self.base.extension
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
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
        
        @inlinable public consuming func makeIterator() -> Iterator {
            Iterator(self, from: Int.zero)
        }
        
        @inlinable public subscript(index: Int) -> Element {
            precondition(index < self.count, String.indexOutOfBounds())
            return self.base[index]
        }
        
        //*====================================================================*
        // MARK: * Iterator
        //*====================================================================*
        
        @frozen public struct Iterator: IteratorProtocol {
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=

            @usableFromInline var base:  ExchangeInt.Prefix
            @usableFromInline var index: ExchangeInt.Prefix.Index
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=

            @inlinable internal init(_ base: ExchangeInt.Prefix, from index: ExchangeInt.Prefix.Index) {
                self.base = base; self.index = index
            }
            
            //=----------------------------------------------------------------=
            // MARK: Utilities
            //=----------------------------------------------------------------=

            @inlinable public var count: Int {
                self.base.distance(from: self.index, to: self.base.endIndex)
            }
            
            @inlinable mutating public func next() -> Element? {
                guard self.index < self.base.endIndex else {
                    return nil
                };  defer {
                    self.base.formIndex(after: &self.index)
                };  return self.base[self.index] as Element
            }
        }
    }
}
