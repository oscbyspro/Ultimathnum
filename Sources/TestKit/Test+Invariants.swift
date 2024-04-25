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
// MARK: * Test x Invariants
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func invariants<T>(_ type: T.Type, _ id: SystemsIntegerID) where T: SystemsInteger {
        //=--------------------------------------=
        same(
            T.size.count(.each(1)),
            T.Magnitude(1),
            "\(T.self).size must be a power of 2"
        )
        
        same(
            MemoryLayout<T>.size,
            MemoryLayout<T>.stride,
            "\(T.self)'s size must be the same as its stride"
        )
        
        yay(
            MemoryLayout<T>.size.isMultiple(of: MemoryLayout<T.Element>.alignment),
            "\(T.self)'s size must be a multiple of \(T.Element.self)'s size"
        )
        
        yay(
            MemoryLayout<T>.stride.isMultiple(of: MemoryLayout<T.Element>.alignment),
            "\(T.self)'s stride must be a multiple of \(T.Element.self)'s stride"
        )
        
        yay(
            MemoryLayout<T>.alignment.isMultiple(of: MemoryLayout<T.Element>.alignment),
            "\(T.self)'s alignment must be a multiple of \(T.Element.self)'s alignment"
        )
        //=--------------------------------------=
        invariants(type, BinaryIntegerID())
    }
    
    public func invariants<T>(_ type: T.Type, _ id: BinaryIntegerID) where T: BinaryInteger {
        //=--------------------------------------=
        same( T.isSigned, T.self is any   SignedInteger.Type)
        same(!T.isSigned, T.self is any UnsignedInteger.Type)
        //=--------------------------------------=
        invariants(type, BitCastableID())
    }
    
    public func invariants<T>(_ type: T.Type, _ id: BitCastableID) where T: BitCastable {
        same(MemoryLayout<T>.self, MemoryLayout<T.BitPattern>.self)
    }
}
