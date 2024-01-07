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
// MARK: * Normal Int x Storage
//*============================================================================*

extension NormalInt {
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @frozen @usableFromInline enum Storage: Hashable, Sendable {
        case some(Word) // one
        case many(ContiguousArray<Word>) // one or more
    }
}
