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
Element: UnsignedInteger & SystemInteger, Element.BitPattern == Word.BitPattern {
    
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var magnitude: Magnitude {
        consuming get { consume self }
    }
    
    @inlinable public var words: some RandomAccessCollection<Word> {
        consuming get { self.storage.words }
    }
}
