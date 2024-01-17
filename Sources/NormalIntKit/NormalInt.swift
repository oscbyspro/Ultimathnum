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
// MARK: * Normal Int
//*============================================================================*

/// A normalized big integer magnitude.
@frozen public struct NormalInt<Element>: Integer where
Element: UnsignedInteger & SystemInteger, Element.BitPattern == UX.BitPattern {
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias Magnitude = Self
    
    @usableFromInline typealias Storage = NormalIntKit.Storage<Element.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        false
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=

    @inlinable init(storage: consuming NormalInt.Storage) {
        self.storage = storage
    }
    
    @inlinable init(normalizing storage: consuming NormalInt.Storage) {
        self.storage = storage
        self.storage.normalize()
    }
    
    @inlinable static func uninitialized(
    count: Int, init: (inout UnsafeMutableBufferPointer<Element>) -> Void) -> Self {
        Self.uninitialized(capacity: count, init:{ $1 = $0.count; `init`(&$0) })
    }
    
    @inlinable static func uninitialized(
    capacity: Int, init: (inout UnsafeMutableBufferPointer<Element>, inout Int) throws -> Void) rethrows -> Self {
        Self(normalizing: try Storage.uninitialized(capacity: capacity, init: `init`))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var magnitude: Magnitude {
        consuming get { consume self }
    }
    
    @inlinable public var words: some RandomAccessCollection<UX> {
        consuming get { self.storage.words }
    }
}
