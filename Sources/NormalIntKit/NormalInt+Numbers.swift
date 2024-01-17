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
// MARK: * Normal Int x Numbers
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(sign: consuming Sign, magnitude: consuming Magnitude) throws {
        self = consume magnitude
        let overflow = sign == Sign.minus && self != 0
        
        if  overflow {
            throw Overflow(self)
        }
    }
    
    @inlinable public init(words: consuming some RandomAccessCollection<UX>, isSigned: consuming Bool) throws {
        self.storage = Storage(BitCastSequence(consume words))
        let overflow = isSigned && self.storage.last & Element.msb != 0
        self.storage.normalize()
        
        if  overflow {
            throw Overflow(self)
        }
    }
}
