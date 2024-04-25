//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Prefix
//*============================================================================*

extension ExchangeInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func prefix(_ count: UX) -> Prefix {
        Prefix(self, count: count)
    }
    
    //*========================================================================*
    // MARK: * Prefix
    //*========================================================================*
    
    @frozen public struct Prefix: RandomAccessCollection {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let base: ExchangeInt
        public let count: UX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: ExchangeInt, count: UX) {
            self.base  = base
            self.count = count
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var startIndex: UX {
            UX.zero
        }
        
        @inlinable public var endIndex: UX {
            self.count
        }
        
        @inlinable public var indices: Range<UX> {
            UX.zero ..< self.count
        }
        
        @inlinable public func distance(from start: UX, to end: UX) -> UX {
            end - start
        }
        
        @inlinable public func index(after index: UX) -> UX {
            index + 1
        }
        
        @inlinable public func index(before index: UX) -> UX {
            index - 1
        }
        
        @inlinable public func index(_ index: UX, offsetBy distance: Int) -> UX {
            index.advanced(by: distance)
        }
        
        @inlinable public subscript(index: UX) -> Element {
            self.base[index]
        }
    }
}
