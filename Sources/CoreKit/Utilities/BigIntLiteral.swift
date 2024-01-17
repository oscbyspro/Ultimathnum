//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Big Int Literal
//*============================================================================*

@frozen public struct BigIntLiteral: RandomAccessCollection, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: StaticBigInt) {
        self.base = base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison against zero.
    ///
    /// ```
    /// ┌────── → ────────┐
    /// │ self  │ signum  │
    /// ├────── → ────────┤
    /// │ -2    │ Int(-1) │ - less
    /// │  0    │ Int( 0) │ - same
    /// │  2    │ Int( 1) │ - more
    /// └────── → ────────┘
    /// ```
    ///
    @inlinable public func signum() -> Int {
        self.base.signum()
    }
    
    /// The number of bits in this value's binary representation.
    @inlinable public var bitWidth: Int {
        self.base.bitWidth
    }
    
    /// Accesses the word at the given index, from least significant to most.
    @inlinable public subscript(index: Int) -> UX {
        UX(bitPattern: self.base[index])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension BigIntLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        let width = self.bitWidth as Int
        let major = width &>> UInt.bitWidth.trailingZeroBitCount
        let minor = width &  (UInt.bitWidth &- 1)
        return major &+ (minor > 0 ? 1 : 0)
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
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
}
