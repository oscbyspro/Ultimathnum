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
// MARK: * Triple Int
//*============================================================================*

@frozen public struct TripleInt<Base: SystemsInteger>: BitCastable, Comparable {
    
    public typealias Storage = Triplet<Base>
    
    public typealias High = Base
    
    public typealias Mid  = Base.Magnitude
    
    public typealias Low  = Base.Magnitude
    
    public typealias BitPattern = Storage.BitPattern
    
    public typealias Element = Base.Element
    
    public typealias Magnitude = TripleInt<Base.Magnitude>
    
    public typealias Signitude = TripleInt<Base.Signitude>
    
    public typealias IntegerLiteralType = StaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signedness {
        Base.mode
    }
    
    @inlinable public static var size: Count {
        Count(unchecked: 3 * IX(size: Base.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ storage: consuming Storage) {
        self.storage = storage
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given components.
    @inlinable public init() {
        self.init(Storage())
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude) {
        self.init(Storage(low: low))
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude, mid: consuming Base.Magnitude) {
        self.init(Storage(low: low, mid: mid))
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude, mid: consuming Base.Magnitude, high: consuming Base) {
        self.init(Storage(low: low, mid: mid, high: high))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Base.Magnitude, high: consuming Doublet<Base>) {
        self.init(Storage(low: low, high: high))
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Doublet<Base.Magnitude>) {
        self.init(Storage(low: low))
    }
    
    /// Creates a new instance from the given components.
    @inlinable public init(low: consuming Doublet<Base.Magnitude>, high: consuming Base) {
        self.init(Storage(low: low, high: high))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(Storage(raw: source))
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        self.storage.load(as: BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var low: Low {
        get {
            self.storage.low
        }
        
        mutating set {
            self.storage.low = newValue
        }
    }
        
    @inlinable public var mid: Mid {
        get {
            self.storage.mid
        }
        
        mutating set {
            self.storage.mid = newValue
        }
    }
    
    @inlinable public var high: High {
        get {
            self.storage.high
        }
        
        mutating set {
            self.storage.high = newValue
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns its components in ascending order.
    @inlinable public consuming func components() -> (low: Low, mid: Mid, high: High) {
        self.storage.components()
    }
}
