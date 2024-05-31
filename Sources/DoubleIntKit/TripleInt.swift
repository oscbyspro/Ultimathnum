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

@frozen public struct TripleInt<Base: SystemsInteger>: BitCastable, Comparable, Hashable {
    
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
    
    @inlinable public static var mode: Base.Mode {
        Base.mode
    }
    
    @inlinable public static var size: Magnitude {
        Magnitude(low: Base.size.multiplication(3), high: Base.Magnitude())
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
    
    @inlinable public init(low: consuming Base.Magnitude, mid: consuming Base.Magnitude, high: consuming Base) {
        self.init(Storage(low: low, mid: mid, high: high))
    }
    
    @inlinable public init(high: consuming Base, mid: consuming Base.Magnitude, low: consuming Base.Magnitude) {
        self.init(Storage(high: high, mid: mid, low: low))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(low: consuming Base.Magnitude, high: consuming Doublet<Base>) {
        self.init(Storage(low: low, high: high))
    }
    
    @inlinable public init(low: consuming Doublet<Base.Magnitude>, high: consuming Base) {
        self.init(Storage(low: low, high: high))
    }
    
    @inlinable public init(high: consuming Doublet<Base>, low: consuming Base.Magnitude) {
        self.init(Storage(high: high, low: low))
    }
    
    @inlinable public init(high: consuming Base, low: consuming Doublet<Base.Magnitude>) {
        self.init(Storage(high: high, low: low))
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
    
    @inlinable public consuming func ascending() -> (low: Low, mid: Mid, high: High) {
        self.storage.ascending()
    }
    
    @inlinable public consuming func descending() -> (high: High, mid: Mid, low: Low) {
        self.storage.descending()
    }
}
