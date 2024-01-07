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
// MARK: * Normal Int x Words x Unsigned
//*============================================================================*

extension NormalInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<Word>) throws -> T) rethrows -> T {
        switch self.storage {
        case let .some(x): try x.withUnsafeBufferPointer(body)
        case let .many(x): try x.withUnsafeBufferPointer(body) }
    }
}
