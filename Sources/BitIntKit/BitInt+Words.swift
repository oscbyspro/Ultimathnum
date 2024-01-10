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
// MARK: * Bit Int x Words x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<Word>) throws -> T) rethrows -> T {
        try UMN.withUnsafeTemporaryAllocation(copying: self.bitPattern == 0 ? 0 : ~0 as Word) {
            try body(UnsafeBufferPointer(start: $0, count: 1))
        }
    }
}

//*============================================================================*
// MARK: * Bit Int x Words x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<Word>) throws -> T) rethrows -> T {
        try UMN.withUnsafeTemporaryAllocation(copying: self.bitPattern == 0 ? 0 : 1 as Word) {
            try body(UnsafeBufferPointer(start: $0, count: 1))
        }
    }
}
