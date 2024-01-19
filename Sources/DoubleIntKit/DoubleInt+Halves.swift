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
// MARK: * Double Int x Halves
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `low` and `high` halves.
    ///
    /// - Parameter low:  The least significant half of this value.
    /// - Parameter high: The most  significant half of this value.
    ///
    @inlinable public init(low: Low, high: High = 0) {
        self.init(Doublet (low: low, high: high))
    }
    
    /// Creates a new instance from the given `low` and `high` halves.
    ///
    /// - Parameter ascending: Both halves of this value, from least significant to most.
    ///
    @inlinable public init(ascending  halves: (low: Low, high: High)) {
        self.init(Doublet (ascending: halves))
    }
    
    /// Creates a new instance from the given `high` and `low` halves.
    ///
    /// - Parameter high: The most  significant half of this value.
    /// - Parameter low:  The least significant half of this value.
    ///
    @inlinable public init(high: High, low: Low = 0) {
        self.init(Doublet (high: high, low: low))
    }
    
    /// Creates a new instance from the given `high` and `low` halves.
    ///
    /// - Parameter descending: Both halves of this value, from most significant to least.
    ///
    @inlinable public init(descending  halves: (high: High, low: Low)) {
        self.init(Doublet (descending: halves))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The `low` half of this value.
    @inlinable public var low: Low {
        get {
            self.storage.low
        }
        set {
            self.storage.low = newValue
        }
    }
    
    /// The `high` half of this value.
    @inlinable public var high: High {
        get {
            self.storage.high
        }
        set {
            self.storage.high = newValue
        }
    }
    
    /// The `low` and `high` halves of this value.
    @inlinable public var ascending: (low: Low, high: High) {
        consuming get {
            self.storage.ascending
        }
        consuming set {
            self.storage.ascending = newValue
        }
    }
    
    /// The `high` and `low` halves of this value.
    @inlinable public var descending: (high: High, low: Low) {
        consuming get {
            self.storage.descending
        }
        consuming set {
            self.storage.descending = newValue
        }
    }
}
