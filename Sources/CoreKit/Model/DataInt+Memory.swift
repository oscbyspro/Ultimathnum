//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Memory
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (DataInt<Destination>) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        let appendix = self.appendix
        //=--------------------------------------=
        return try self.body.withMemoryRebound(to: Destination.self) {
            try action(DataInt<Destination>($0, repeating: appendix))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Memory x Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (DataInt<Destination>.Body) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Element.elementsCanBeRebound(to: Destination.self))
        //=--------------------------------------=
        let ratio = IX(size: Element.self) / IX(size: Destination.self)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to:  Destination.self, capacity: Int(count)) {
            try action(DataInt<Destination>.Body($0, count: count))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Memory x Canvas
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Initialization
    //=------------------------------------------------------------------------=
    
    /// Initializes each elements in `self` to `element`.
    @inlinable public func initialize(repeating element: Element) {
        self.start.initialize(repeating: element, count: Int(self.count))
    }
    
    /// Initializes the elements of `self` to the elements of `source`.
    ///
    /// - Requires: `self.count == source.count`
    ///
    @inlinable public func initialize(to source: Body) {
        //=--------------------------------------=
        Swift.assert(self.count == source.count, String.indexOutOfBounds())
        //=--------------------------------------=
        self.start.initialize(from: source.start, count: Int(source.count))
    }
    
    /// Initializes the elements of `self` to the bit pattern of `source`.
    ///
    /// All elements in `self[source.count...]` are initialized to zero.
    ///
    /// - Requires: `self.count >= source.count`
    ///
    @inlinable public func load(_ source: Body) {
        //=--------------------------------------=
        Swift.assert(self.count >=  source.count, String.indexOutOfBounds())
        //=--------------------------------------=
        self.start.initialize(from: source.start, count: Int(source.count))
        self.start.advanced(by: Int(source.count)).initialize(repeating: Element.zero, count: Int(self.count - source.count))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (DataInt<Destination>.Body) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Element.elementsCanBeRebound(to: Destination.self))
        //=--------------------------------------=
        let ratio = IX(size: Element.self) / IX(size: Destination.self)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to:  Destination.self, capacity: Int(count)) {
            try action(DataInt<Destination>.Body($0, count: count))
        }
    }
}
