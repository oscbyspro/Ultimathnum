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
    
    public func invariants<T>(_ type: T.Type, _ id: SystemsIntegerID = .init()) where T: SystemsInteger {
        //=--------------------------------------=
        same(
            T.bitWidth.count(1, option: .all),
            T.Magnitude(1),
            "\(T.self).bitWidth must be a power of 2"
        )
        nonless(
            UX(bitWidth: T.self),
            UX(bitWidth: T.Element.self),
            "\(T.self) must be at least as wide as \(T.Element.self)"
        )
        //=--------------------------------------=
        equal(MemoryLayout<T>.self, MemoryLayout<T.Content>.self)
        //=--------------------------------------=
        invariants(type, BinaryIntegerID())
    }
    
    public func invariants<T>(_ type: T.Type, _ id: BinaryIntegerID = .init()) where T: BinaryInteger {
        //=--------------------------------------=
        same(
            T.Element.bitWidth.count(1, option: .all),
            T.Element.Magnitude(1),
            "\(T.Element.self).bitWidth must be a power of 2"
        )
        //=--------------------------------------=
        same( T.isSigned, T.self is any   SignedInteger.Type)
        same(!T.isSigned, T.self is any UnsignedInteger.Type)
        //=--------------------------------------=
        invariants(type, BitCastableID())
    }
    
    public func invariants<T>(_ type: T.Type, _ id: BitCastableID) where T: BitCastable {
        equal(MemoryLayout<T>.self, MemoryLayout<T.BitPattern>.self)
    }
}
