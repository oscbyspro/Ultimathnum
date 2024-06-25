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
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `first` element.
    ///
    /// - Note: This operation does not perform any pointer arithmetic.
    ///
    @inlinable public var first: Element {
        if  let element = self.body.first {
            return element
            
        }   else {
            return self.last
        }
    }
    
    /// Returns the `last` element.
    ///
    /// - Returns: `Element(repeating: appendix)`
    ///
    /// - Note: This operation does not perform any pointer arithmetic.
    ///
    @inlinable public var last: Element {
        Element(repeating: self.appendix)
    }
    
    /// Returns the element at the given `index`.
    @inlinable public subscript(index: UX) -> Element {
        if  let element = self.body[exactly: IX(raw: index)] {
            return element
            
        }   else {
            return self.last
        }
    }
    
    /// Returns the `first` element then drops it.
    @inlinable public mutating func next() -> Element {
        if  let element = self.body.first {
            self = Self(self.body[unchecked: 1...], repeating: self.appendix)
            return element
            
        }   else {
            return self.last
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Read|Write
//*============================================================================*

extension MutableDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `first` element.
    ///
    /// - Note: This operation does not perform any pointer arithmetic.
    ///
    @inlinable public var first: Element {
        Immutable(self).first
    }
    
    /// Returns the `last` element.
    ///
    /// - Returns: `Element(repeating: appendix)`
    ///
    /// - Note: This operation does not perform any pointer arithmetic.
    ///
    @inlinable public var last: Element {
        Immutable(self).last
    }
    
    /// Returns the element at the given `index`.
    @inlinable public subscript(index: UX) -> Element {
        Immutable(self)[index]
    }
    
    /// Returns the `first` element then drops it.
    @inlinable public mutating func next() -> Element {
        var immutable = Immutable(self)

        defer {
            self = Self(mutating: immutable)
        }
        
        return immutable.next() as Element
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
    
    @inlinable public var indices: Range<IX> {
        Range(uncheckedBounds:(0, self.count))
    }
    
    /// Returns the `first` element, if it exists.
    ///
    /// - Note: This operation does not perform any pointer arithmetic.
    ///
    @inlinable public var first: Optional<Element> {
        if  self.isEmpty {
            return nil
            
        }   else {
            return self[unchecked: ()]
        }
    }
    
    /// Returns the `last` element, if it exists.
    @inlinable public var last: Optional<Element> {
        self[exactly: self.count.decremented().unchecked()]
    }
    
    /// Returns the element at `IX.zero`.
    ///
    /// - Requires: `self.count >= 1`
    ///
    /// - Note: This operation does not perform any pointer arithmetic.
    ///
    @inlinable public subscript(unchecked index: Void) -> Element {
        Swift.assert(!self.isEmpty, String.indexOutOfBounds())
        
        return self.start.pointee
    }
    
    /// Returns the element at the given `index`.
    ///
    /// - Requires: `self.count >= index + 1`
    ///
    @inlinable public subscript(unchecked index: IX) -> Element {
        Swift.assert(index >= 0000000000, String.indexOutOfBounds())
        Swift.assert(index <  self.count, String.indexOutOfBounds())
        
        return self.start.advanced(by: Int(index)).pointee
    }
    
    /// Return the element at the given `index`, if it exists.
    @inlinable public subscript(exactly index: IX) -> Optional<Element> {
        if  UX(raw: index) < UX(raw: self.count) {
            return self[unchecked: index]
        }   else {
            return nil
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
        if  self.count != source.count {
            Swift.assertionFailure(String.indexOutOfBounds())
        }
        
        self.start.initialize(from: source.start, count: Int(source.count))
    }
    
    /// Initializes the elements of `self` to the bit pattern of `source`.
    ///
    /// All elements in `self[source.count...]` are initialized to zero.
    ///
    /// - Requires: `self.count >= source.count`
    ///
    @inlinable public borrowing func initialize(load source: Immutable) {
        if  self.count < source.count {
            Swift.assertionFailure(String.indexOutOfBounds())
        }
        
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
    
    @inlinable public var indices: Range<IX> {
        Immutable(self).indices
    }
    
    /// Returns the `first` element, if it exists.
    ///
    /// - Note: This operation does not perform any pointer arithmetic.
    ///
    @inlinable public var first: Optional<Element> {
        Immutable(self).first
    }
    
    /// Returns the `last` element, if it exists.
    @inlinable public var last: Optional<Element> {
        Immutable(self).last
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the element at `IX.zero`.
    ///
    /// - Requires: `self.count >= 1`
    ///
    /// - Note: This operation does not perform any pointer arithmetic.
    ///
    @inlinable public subscript(unchecked index: Void) -> Element {
        nonmutating get {
            Immutable(self)[unchecked: index]
        }
        
        nonmutating set {
            Swift.assert(!self.isEmpty, String.indexOutOfBounds())
            //=----------------------------------=
            // note that the pointee is trivial
            //=----------------------------------=
            return self.start.initialize(to: newValue)
        }
    }
    
    /// Returns the element at the given `index`.
    ///
    /// - Requires: `self.count >= index + 1`
    ///
    @inlinable public subscript(unchecked index: IX) -> Element {
        nonmutating get {
            Immutable(self)[unchecked: index]
        }
        
        nonmutating set {
            Swift.assert(index >= 0000000000, String.indexOutOfBounds())
            Swift.assert(index <  self.count, String.indexOutOfBounds())
            //=----------------------------------=
            // note that the pointee is trivial
            //=----------------------------------=
            return self.start.advanced(by: Int(index)).initialize(to: newValue)
        }
    }
    
    /// Return the element at the given `index`, if it exists.
    @inlinable public subscript(exactly index: IX) -> Optional<Element> {
        nonmutating get {
            Immutable(self)[exactly: index]
        }
    }
}
