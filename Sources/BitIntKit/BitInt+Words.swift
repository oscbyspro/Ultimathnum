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
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T {
        let bit = (consume self).bitPattern as Bit as Bit as Bit as Bit
        return UMN.withUnsafeTemporaryAllocation(of: UX.self) { pointer in
            pointer.initialize(to: UX(repeating: bit))
            
            defer {
                pointer.deinitialize(count: 1)
            }
            
            return body(UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}

//*============================================================================*
// MARK: * Bit Int x Words x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Words
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<UX>) -> T) -> T {
        let bit = (consume self).bitPattern as Bit as Bit as Bit as Bit
        return UMN.withUnsafeTemporaryAllocation(of: UX.self) { pointer in
            pointer.initialize(to: bit == 0 ? 0 : 1)
            
            defer {
                pointer.deinitialize(count: 1)
            }
            
            return body(UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}
