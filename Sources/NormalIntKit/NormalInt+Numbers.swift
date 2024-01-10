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
// MARK: * Normal Int x Numbers x Unsigned
//*============================================================================*

extension NormalInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral: consuming StaticBigInt) {
        fatalError("TODO")
    }
    
    @inlinable public init(sign: consuming Sign, magnitude: consuming Magnitude) throws {
        fatalError("TODO")
    }
    
    @inlinable public init(words: consuming some RandomAccessCollection<Word>, isSigned: consuming Bool) throws {
        fatalError("TODO")
    }
}
