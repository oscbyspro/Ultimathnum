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
// MARK: * Bits
//*============================================================================*

@frozen public struct Bits: RandomAccessCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: DataInt<U8>
    @usableFromInline let count: UX
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: DataInt<U8>, count: UX) {
        self.base  = base
        self.count = count
    }
    
    /// ### Development
    ///
    /// - TODO: Mark it as `throws(Overflow)`.
    ///
    @inlinable public init(normalizing base: DataInt<U8>) throws {
        self.base = base.normalized()
        let index = UX(bitPattern: self.base.body.count)
        
        if  let i: UX  = index.minus(1).optional() {
            let major  = try i.times(8).get()
            let minor  = UX(load: self.base[i].count(.nonappendix))
            self.count = try major.plus(minor).get()
        }   else {
            self.count = index
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: UX {
        UX()
    }
    
    @inlinable public var endIndex: UX {
        self.count
    }
    
    @inlinable public func index(after  index: UX) -> UX {
        index + 1
    }
    
    @inlinable public func index(before index: UX) -> UX {
        index - 1
    }
    
    @inlinable public func distance(from start: UX, to end: UX) -> Int {
        start.distance(to: end)
    }
    
    @inlinable public subscript(index: UX) -> Bit {
        Bit(self.base[index &>> 3] &>> U8(load: index) & (1 as U8) != (0 as U8))
    }
}
