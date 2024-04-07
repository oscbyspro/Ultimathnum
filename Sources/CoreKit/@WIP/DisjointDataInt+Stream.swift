//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Disjoint Data Int x Stream
//*============================================================================*

extension DisjointDataInt {
    
    @frozen public struct Stream {
                
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        @usableFromInline var base: DisjointDataInt
        @usableFromInline var index: IX
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
        @inlinable init(_ base: consuming DisjointDataInt, from index: consuming IX) {
            self.base  = base
            self.index = index
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Transformations
        //=------------------------------------------------------------------------=
        
        @inlinable public mutating func next() -> Element {
            let element  = self.base[index]
            self.index &+= self.index >= 0 ? 1 : 0
            return element
        }
        
        @inlinable public mutating func finalize() {
            self.index = IX.max
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var appendix: Bit {
            self.base.appendix
        }
        
        @inlinable public var isOnRepeat: Bool {
            self.index >= self.base.major + IX(Bit(self.base.minor != 0))
        }
    }
}
