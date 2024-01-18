//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Normal Int x Storage
//*============================================================================*

@frozen @usableFromInline struct Storage<Element>: Sendable where
Element: UnsignedInteger & SystemsInteger, Element.BitPattern == UX.BitPattern {
    
    @usableFromInline typealias Element = Element
    
    @usableFromInline typealias Allocation = ContiguousArray<Element>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var mode: Mode
    @usableFromInline var allocation: Allocation
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ element: Element) {
        self.mode = Mode.inline(element)
        self.allocation = Allocation()
    }
    
    @inlinable init(unchecked elements: Allocation) {
        self.mode = Mode.allocation
        self.allocation = elements
        Swift.assert(!allocation.isEmpty)
    }
    
    @inlinable init(_ elements: some RandomAccessCollection<Element>) {
        if  elements.count < 2 {
            self.init(elements.first ?? Element())
        }   else {
            self.init(unchecked: Allocation(elements))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Allocates inline storage, etc.
    @inlinable mutating func allocate() {
        switch self.mode {
        case .inline(let payload):
            
            self.allocation.append(payload)
            self.mode = Self.Mode.allocation
            
        case .allocation: break }
    }
    
    @inlinable var words: some RandomAccessCollection<UX> {
        consuming get {
            
            self.allocate()
            
            return BitCastSequence(self.allocation)
        }
    }
    
    //*========================================================================*
    // MARK: * Mode
    //*========================================================================*
    
    /// ### Development
    ///
    /// The storage model contains a separate allocation to prevent copy-on-writes.
    /// At some point, I would like to store everything in and enum. The preferred
    /// alternative is kind of possible with unsafe code, but I'd rather wait until
    /// the language supports in-place payload mutations.
    ///
    /// - Note: Untouched arrays are immortal singletons in Swift.
    ///
    @frozen @usableFromInline enum Mode: Sendable {
        
        ///  One inline element.
        case inline(Element)
        
        ///  At least one element is stored in a separate allocation.
        case allocation
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var count: Int {
        switch self.mode {
        case .inline: 1
        case .allocation: self.allocation.count
        }
    }
    
    @inlinable var first: Element {
        self[0]
    }
    
    @inlinable var last: Element {
        self[self.count - 1]
    }
    
    @inlinable subscript(index: Int) -> Element {
        self.withUnsafeBufferPointer { elements in
            precondition(elements.indices ~= index)
            return elements[index]
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ element: Element) {
        self.allocate()
        self.allocation.append(element)
    }
    
    @inlinable mutating func resize(minCount: Int) {
        guard minCount > 1 else { return }
        
        self.allocate()
        self.allocation.reserveCapacity(minCount)
        
        while self.allocation.count < minCount {
            ((self.allocation)).append(Element())
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Normalization
//=----------------------------------------------------------------------------=

extension Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool {
        switch self.mode {
        case .inline:
            
            return true
            
        case .allocation:
            
            return self.allocation.count == 1 || self.allocation.last! != 0
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func normalize() {
        switch self.mode {
        case .inline:
            
            break
            
        case .allocation:
            
            while self.allocation.count > 1 && self.allocation.last! == 0 {
                ((self.allocation)).removeLast()
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Pointers
//=----------------------------------------------------------------------------=

extension Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<Element>) throws -> T) rethrows -> T {
        switch self.mode {
        case .inline(let payload):
            
            try Swift.withUnsafePointer(to: payload) {
                try body(UnsafeBufferPointer(start: $0, count: 1))
            }
            
        case .allocation:
            
            try self.allocation.withUnsafeBufferPointer(body)
        }
    }
    
    @inlinable mutating func withUnsafeMutableBufferPointer<T>(_ body: (inout UnsafeMutableBufferPointer<Element>) throws -> T) rethrows -> T {
        switch self.mode {
        case .inline(var payload):
            
            let result = try Swift.withUnsafeMutablePointer(to: &payload) {
                var buffer = UnsafeMutableBufferPointer(start: $0, count: 1)
                return try body(&buffer)
            }
            
            self.mode = Mode.inline(payload)
            return consume result
            
        case .allocation:
            
            return try self.allocation.withUnsafeMutableBufferPointer(body)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Words
//=----------------------------------------------------------------------------=

extension Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to its uninitialized words.
    ///
    /// The `init` is responsible for initializing up to `capacity` prefixing words.
    /// The `init` is given a buffer and an initialized prefix count. All words in
    /// the prefix must be initialized and all words after it must be uninitialized.
    /// This postcondition must hold even when the `init` throws an error.
    ///
    /// - Note: While the resulting instance may have a capacity larger than the
    /// requested amount, the buffer passed to `init` will cover exactly the requested
    /// number of words.
    ///
    /// ### Semantics when there is no initialized prefix
    ///
    /// It returns zero when there is no initialized prefix because the following
    /// expressions must return the same values:
    ///
    /// ```swift
    /// 1. Self.init(words:   words) // this is zero when words == []
    /// 2. Self.uninitialized(count:    words.count) {  _ = $0.initialize(from: words).index }
    /// 3. Self.uninitialized(capacity: words.count) { $1 = $0.initialize(from: words).index }
    /// ```
    ///
    @inlinable public static func uninitialized(
    capacity: Int, init: (inout UnsafeMutableBufferPointer<Element>, inout Int) throws -> Void) rethrows -> Self {
        try Self(Allocation(unsafeUninitializedCapacity: capacity, initializingWith: `init`))
    }
}
