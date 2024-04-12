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
    
    @usableFromInline let base: MemoryInt<U8>
    @usableFromInline let count: UX
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: MemoryInt<U8>, count: UX) {
        self.base  = base
        self.count = count
    }
    
    @inlinable public init(normalizing base: MemoryInt<U8>) {
        self.base  = base.normalized()
        let  index = UX(bitPattern: self.base.body.count)
        let  major = index * 8
        let  minor = index > 0 ? UX(load: self.base[index - 1].count(.appendix)) : 0
        self.count = major.minus(minor).assert()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: UX {
        UX.zero
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
