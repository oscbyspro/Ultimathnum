//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Fuzzer Int
//*============================================================================*

/// A deterministic source of random data.
///
/// ### Algorithm
///
/// It adapts `SplitMix64` because it's simple and light-weight.
///
/// - Important: It may use a different algorithm in the future.
///
@frozen public struct FuzzerInt: Equatable, Interoperable, Randomness, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var state: U64
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(seed: U64) {
        self.state = (seed)
    }
    
    @inlinable public init(_ source: consuming Stdlib) {
        self = source.base
    }
    
    @inlinable public consuming func stdlib() -> Stdlib {
        Stdlib(self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func next() -> some SystemsInteger & UnsignedInteger {
        self.state &+= 0x9e3779b97f4a7c15
        var next = ((((((self.state))))))
        next = (next ^ (next &>> 30)) &* 0xbf58476d1ce4e5b9
        next = (next ^ (next &>> 27)) &* 0x94d049bb133111eb
        return (next ^ (next &>> 31))
    }
    
    //*========================================================================*
    // MARK: * Stdlib
    //*========================================================================*
    
    @frozen public struct Stdlib: Swift.RandomNumberGenerator {
        
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
