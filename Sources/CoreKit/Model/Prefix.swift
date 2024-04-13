//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Prefix
//*============================================================================*

@frozen public struct Prefix<Base>: RandomAccessCollection where
Base: NaturallyIndexable, Base.Index.BitPattern == UX.BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let base: Base
    public let count: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base, count: Int) {
        //=----------------------------------=
        precondition(count >= Int.zero, String.indexOutOfBounds())
        //=----------------------------------=
        self.base  = base
        self.count = count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Int {
        (0 as Int)
    }
    
    @inlinable public var endIndex: Int {
        self.count
    }
    
    @inlinable public var indices: Range<Int> {
        (0 as Int) ..< self.count
    }
    
    @inlinable public func distance(from start: Int, to end: Int) -> Int {
        end - start
    }
    
    @inlinable public func index(after index: Int) -> Int {
        index + (1 as Int)
    }
    
    @inlinable public func index(before index: Int) -> Int {
        index - (1 as Int)
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
        index + distance
    }
    
    @inlinable public subscript(index: Int) -> Base.Element {
        //=--------------------------------------=
        precondition(UInt(bitPattern: index) < UInt(bitPattern: self.count), String.indexOutOfBounds())
        //=--------------------------------------=
        return self.base[Base.Index(bitPattern: index)]
    }
}
