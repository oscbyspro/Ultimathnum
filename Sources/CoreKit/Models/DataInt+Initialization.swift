//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Initialization x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Initialization
    //=------------------------------------------------------------------------=
    
    /// Deinitializes each element in `self`.
    @inlinable public func deinitialize() {
        self.start.deinitialize(count: Int(self.count))
    }
    
    /// Initializes each element in `self` to `element`.
    @inlinable public func initialize(repeating element: Element) {
        self.start.initialize(repeating: element, count: Int(self.count))
    }
    
    /// Initializes the elements of `self` to the elements of `source`.
    ///
    /// - Requires: `self.count == source.count`
    ///
    @inlinable public func initialize(to source: Immutable) {
        //=--------------------------------------=
        Swift.assert(self.count ==  source.count, String.indexOutOfBounds())
        //=--------------------------------------=
        self.start.initialize(from: source.start, count: Int(source.count))
    }
    
    /// Initializes the elements of `self` to the bit pattern of `source`.
    ///
    /// All elements in `self[source.count...]` are initialized to zero.
    ///
    /// - Requires: `self.count >= source.count`
    ///
    @inlinable public func initialize(load source: Immutable) {
        //=--------------------------------------=
        Swift.assert(self.count >=  source.count, String.indexOutOfBounds())
        //=--------------------------------------=
        self.start.initialize(from: source.start, count: Int(source.count))
        self.start.advanced(by: Int(source.count)).initialize(repeating: Element.zero, count: Int(self.count - source.count))
    }
}
