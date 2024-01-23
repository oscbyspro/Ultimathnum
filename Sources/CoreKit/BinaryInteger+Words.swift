//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Words
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: consuming some RandomAccessCollection<UX>) throws {
        try  self.init(words: consume words, isSigned: Self.isSigned)
    }
    
    @inlinable public init(words: consuming some RandomAccessCollection<UX>, isSigned: consuming Bool) throws {
        fatalError("TODO")
    }
}
