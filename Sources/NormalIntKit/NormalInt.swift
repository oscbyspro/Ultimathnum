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

/// An unsigned, auto-normalized, arbitrary precision integer.
@frozen public struct NormalInt<Element>: UnsignedInteger & BinaryInteger where 
Element: UnsignedInteger & SystemInteger, Element.BitPattern == Word.BitPattern {
    
    public typealias Magnitude = Self
    
    public typealias IntegerLiteralType = StaticBigInt
    
    @usableFromInline typealias Storage = NormalIntKit.Storage<Element>
    
    //=--------------------------------------------------------------------=
    // MARK: State
    //=--------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=--------------------------------------------------------------------=
    // MARK: Initializers
    //=--------------------------------------------------------------------=
    
    @inlinable init(storage: consuming NormalInt.Storage) {
        self.storage = storage
    }
    
    //=--------------------------------------------------------------------=
    // MARK: Utilities
    //=--------------------------------------------------------------------=
    
    @inlinable public var words: some RandomAccessCollection<Word> {
        consuming get { self.storage.words }
    }
}
