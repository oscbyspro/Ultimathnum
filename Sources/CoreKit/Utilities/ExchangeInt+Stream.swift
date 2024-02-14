//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Stream x Bit Pattern
//*============================================================================*

extension ExchangeInt where Element == Element.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func stream() -> Stream {
        Stream(self.bitPattern, from: Int.zero)
    }
    
    //*========================================================================*
    // MARK: * Stream
    //*========================================================================*
    
    @frozen public struct Stream {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let base:  ExchangeInt
        @usableFromInline let limit: ExchangeInt.Index
        @usableFromInline var index: ExchangeInt.Index
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ base: ExchangeInt, from index: ExchangeInt.Index) {
            self.base  = (base)
            self.limit = ExchangeInt.count(chunking: base.base)
            self.index = (index)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating public func next() -> Element {
            defer {
                self.index += (self.index < self.limit) ? 1 : 0
            }
            
            return self.base[self.index] as Element
        }
                
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var appendix: Bit.Extension<Element> {
            self.base.appendix
        }
        
        @inlinable public mutating func consume() {
            self.index = self.limit
        }
        
        @inlinable public func succinct() -> ExchangeInt.Prefix.Iterator {
            var index: ExchangeInt.Index = self.limit
            
            trimming: while self.index < index {
                let predecessorIndex = index - 1
                guard self.base[predecessorIndex] == self.base.appendix.element else { break }
                index = predecessorIndex as ExchangeInt.Index
            }
            
            return ExchangeInt.Prefix.Iterator(self.base.prefix(index), from: self.index)
        }
    }
}
