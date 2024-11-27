//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreIop
import CoreKit
import RandomIntKit

//*============================================================================*
// MARK: * Fuzzer Int x Stdlib
//*============================================================================*

extension FuzzerInt: RandomnessInteroperable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: consuming Stdlib) {
        self = source.base
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        Stdlib(self)
    }
    
    //*========================================================================*
    // MARK: * Stdlib
    //*========================================================================*
    
    @frozen public struct Stdlib: Equatable, RandomNumberGenerator, Sendable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var base: FuzzerInt
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ base: consuming FuzzerInt) {
            self.base = base
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public mutating func next() -> Swift.UInt64 {
            Swift.UInt64(self.base.next(as: U64.self))
        }
    }
}
