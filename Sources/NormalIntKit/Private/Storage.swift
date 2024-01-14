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
// MARK: * Normal Int Storage
//*============================================================================*

@frozen @usableFromInline struct Storage<Element> where
Element: UnsignedInteger & SystemInteger, Element.BitPattern == Word.BitPattern {
    
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
    
    @inlinable init(_ elements: Allocation) {
        self.mode = Mode.allocation
        self.allocation = elements
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
    
    @inlinable var words: some RandomAccessCollection<Word> {
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
    @frozen @usableFromInline enum Mode {
        
        ///  One inline element.
        case inline(Element)
        
        ///  At least one element is stored in a separate allocation.
        case allocation
    }
}
