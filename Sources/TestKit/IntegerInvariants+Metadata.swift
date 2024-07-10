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
// MARK: * Integer Invariants x Metadata
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func mode(_ id: BinaryIntegerID) where T: BinaryInteger {
        test.same( T.isSigned, T.mode == .signed)
        test.same( T.isSigned, T.self is any   SignedInteger.Type)
        test.same(!T.isSigned, T.self is any UnsignedInteger.Type)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func size(_ id: SystemsIntegerID) where T: SystemsInteger {
        //=--------------------------------------=
        self.size(BinaryIntegerID())
        //=--------------------------------------=
        test.same(
            IX(size: T.self).count(1),
            Count(1),
            "\(T.self).size must be a power of 2"
        )
        
        test.same(
            IX(size: T.self),
            IX(MemoryLayout<T>.size) * 8,
            "\(T.self).size must match memory layout"
        )
        
        test.same(
            MemoryLayout<T>.size,
            MemoryLayout<T>.stride,
            "\(T.self)'s size must be the same as its stride"
        )
        
        test.yay(
            MemoryLayout<T>.size.isMultiple(of: MemoryLayout<T.Element>.alignment),
            "\(T.self)'s size must be a multiple of \(T.Element.self)'s size"
        )
        
        test.yay(
            MemoryLayout<T>.stride.isMultiple(of: MemoryLayout<T.Element>.alignment),
            "\(T.self)'s stride must be a multiple of \(T.Element.self)'s stride"
        )
        
        test.yay(
            MemoryLayout<T>.alignment.isMultiple(of: MemoryLayout<T.Element>.alignment),
            "\(T.self)'s alignment must be a multiple of \(T.Element.self)'s alignment"
        )
    }
    
    public func size(_ id: BinaryIntegerID) where T: BinaryInteger {
        //=--------------------------------------=
        test.same(T.size, M.size, "Self.size == Self.Magnitude.size")
        test.same(T.size, S.size, "Self.size == Self.Signitude.size")
        //=--------------------------------------=
        for value: T in [~3, ~2, ~1, ~0, 0, 1, 2, 3] {
            let x0 = IX(raw: value.count(0))
            let x1 = IX(raw: value.count(1))
            test.same(Count(raw: x0 + x1), T.size, "size == 0s + 1s [\(value), \(x0), \(x1)]")
        }
        //=--------------------------------------=
        if !T.size.isInfinite {
            test.expect(T.size <= Count(IX.max), "the maximum finite size is IX.max")
        }   else {
            test.same(T.size, Count.infinity, "any infinite size must be log2(UXL.max + 1)")
        }
    }
    
    public func protocols() where T: BinaryInteger {
        //=--------------------------------------=
        let isArbitrary = T.size.isInfinite
        let isEdgy   = !T.isSigned || !isArbitrary
        let isFinite =  T.isSigned || !isArbitrary
        //=--------------------------------------=
        test.same(isArbitrary, T.self is any ArbitraryInteger.Type, "ArbitraryInteger")
        test.same(   isEdgy,   T.self is any      EdgyInteger.Type,      "EdgyInteger")
        test.same(   isFinite, T.self is any    FiniteInteger.Type,    "FiniteInteger")
        test.same( T.isSigned, T.self is any    SignedInteger.Type,    "SignedInteger")
        test.same(!T.isSigned, T.self is any  UnsignedInteger.Type,  "UnsignedInteger")
    }
}
