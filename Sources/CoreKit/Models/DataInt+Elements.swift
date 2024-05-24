//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Element x Read
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the least significant bit pattern that fits in an element, then
    /// rebases `self` such that it starts at the end of this bit pattern.
    @inlinable public mutating func next() -> Element {
        defer {
            self = self[1...]
        }
        
        return self.load()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the least significant bit pattern that fits in an element.
    ///
    /// ### Load vs Subscript
    ///
    /// A load may be more efficient than a safe subscript access but this is
    /// only because it does not need to perform any pointer arithmetic. Note,
    /// however, that calling `body[unchecked: ()]` is still the most performant
    /// option because it omits bounds checks in release mode.
    ///
    @inlinable public borrowing func load() -> Element {
        self.body.load(repeating: self.appendix)
    }
    
    @inlinable public subscript(index: UX) -> Element {
        if  index < UX(raw: self.body.count) {
            return self.body[unchecked: IX(raw: index)]
        }   else {
            return Element(repeating: self.appendix)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (DataInt<Destination>) throws -> Value
    )   rethrows -> Value {
        
        try self.body.withMemoryRebound(to: Destination.self) {
            try action(.init($0, repeating: self.appendix))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Read|Write
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Returns the least significant bit pattern that fits in an element, then
    /// rebases `self` such that it starts at the end of this bit pattern.
    @inlinable public mutating func next() -> Element {
        var immutable = Immutable.init(self)

        defer {
            self = Self(mutating: immutable)
        }
        
        return immutable.next() as Element
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the least significant bit pattern that fits in an element.
    ///
    /// ### Load vs Subscript
    ///
    /// A load may be more efficient than a safe subscript access but this is
    /// only because it does not need to perform any pointer arithmetic. Note,
    /// however, that calling `body[unchecked: ()]` is still the most performant
    /// option because it omits bounds checks in release mode.
    ///
    @inlinable public borrowing func load() -> Element {
        Immutable(self).load()
    }
    
    @inlinable public subscript(index: UX) -> Element {
        Immutable(self)[index]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (MutableDataInt<Destination>) throws -> Value
    )   rethrows -> Value {
        
        try self.body.withMemoryRebound(to: Destination.self) {
            try action(.init($0, repeating: self.appendix))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit.zero
    }
    
    @inlinable public var isEmpty: Bool {
        self.count == 0
    }
    
    @inlinable public var indices: Range<IX> {
        Range(uncheckedBounds:(0, self.count))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the least significant bit pattern that fits in an element.
    ///
    /// This method returns the first element when possible. It also handles the
    /// case where the body is empty. In that case, it returns the repeating bit
    /// pattern of `appendix`.
    ///
    @inlinable public borrowing func load(repeating appendix: Bit = .zero) -> Element {
        if  UX(raw: self.count) > .zero {
            return self[unchecked: ()]
            
        }   else {
            return Element(repeating: appendix)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(optional index: IX) -> Element? {
        if  UX(raw: index) < UX(raw: self.count) {
            return self[unchecked: index]
        }   else {
            return nil
        }
    }
    
    @inlinable public subscript(unchecked index: Void) -> Element {
        //=----------------------------------=
        Swift.assert(00000 <  self.count, String.indexOutOfBounds())
        //=----------------------------------=
        return self.start.pointee
    }
    
    @inlinable public subscript(unchecked index: IX) -> Element {
        //=--------------------------------------=
        Swift.assert(index >= 0000000000, String.indexOutOfBounds())
        Swift.assert(index <  self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        return self.start.advanced(by: Int(index)).pointee
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
            try action(.init($0, count: count))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Initialization
    //=------------------------------------------------------------------------=
    
    /// Deinitializes each element in `self`.
    @inlinable public borrowing func deinitialize() {
        self.start.deinitialize(count: Int(self.count))
    }
    
    /// Initializes the elements of `self` to the elements of `source`.
    ///
    /// - Requires: `self.count == source.count`
    ///
    @inlinable public borrowing func initialize(to source: Immutable) {
        //=--------------------------------------=
        if  self.count != source.count {
            Swift.assertionFailure(String.indexOutOfBounds())
        }
        //=--------------------------------------=
        self.start.initialize(from: source.start, count: Int(source.count))
    }
    
    /// Initializes the elements of `self` to the bit pattern of `source`.
    ///
    /// All elements in `self[source.count...]` are initialized to zero.
    ///
    /// - Requires: `self.count >= source.count`
    ///
    @inlinable public borrowing func initialize(load source: Immutable) {
        //=--------------------------------------=
        if  self.count < source.count {
            Swift.assertionFailure(String.indexOutOfBounds())
        }
        //=--------------------------------------=
        self.start.initialize(from: source.start, count: Int(source.count))
        self.start.advanced(by: Int(source.count)).initialize(repeating: .zero, count: Int(self.count - source.count))
    }
    
    /// Initializes each element in `self` to `element`.
    @inlinable public borrowing func initialize(repeating element: Element) {
        self.start.initialize(repeating: element, count: Int(self.count))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Immutable(self).appendix
    }
    
    @inlinable public var isEmpty: Bool {
        Immutable(self).isEmpty
    }
    
    @inlinable public var indices: Range<IX> {
        Immutable(self).indices
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the least significant bit pattern that fits in an element.
    ///
    /// This method returns the first element when possible. It also handles the
    /// case where the body is empty. In that case, it returns the repeating bit
    /// pattern of `appendix`.
    ///
    @inlinable public borrowing func load(repeating appendix: Bit = .zero) -> Element {
        Immutable(self).load(repeating: appendix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(optional index: IX) -> Element? {
        Immutable(self)[optional: index]
    }
    
    @inlinable public subscript(unchecked index: Void) -> Element {
        nonmutating get {
            Immutable(self)[unchecked: index]
        }
        
        nonmutating set {
            //=----------------------------------=
            Swift.assert(00000 <  self.count, String.indexOutOfBounds())
            //=----------------------------------=
            // note that the pointee is trivial
            //=----------------------------------=
            return self.start.initialize(to: newValue)
        }
    }
    
    @inlinable public subscript(unchecked index: IX) -> Element {
        nonmutating get {
            Immutable(self)[unchecked: index]
        }
        
        nonmutating set {
            //=----------------------------------=
            Swift.assert(index >= 0000000000, String.indexOutOfBounds())
            Swift.assert(index <  self.count, String.indexOutOfBounds())
            //=----------------------------------=
            // note that the pointee is trivial
            //=----------------------------------=
            return self.start.advanced(by: Int(index)).initialize(to: newValue)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (MutableDataInt<Destination>.Body) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Element.elementsCanBeRebound(to: Destination.self))
        //=--------------------------------------=
        let ratio = IX(size: Element.self) / IX(size: Destination.self)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to:  Destination.self, capacity: Int(count)) {
            try action(.init($0, count: count))
        }
    }
}
