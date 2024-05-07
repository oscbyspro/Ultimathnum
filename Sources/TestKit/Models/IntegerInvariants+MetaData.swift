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
// MARK: * Integer Invariants x Meta Data
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func mode(_ id: BinaryIntegerID) where T: BinaryInteger {
        test.same( T.isSigned, T.mode.isSigned)
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
            T.size.count(1),
            T.Magnitude (1),
            "\(T.self).size must be a power of 2"
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
        if  T.size.isInfinite {
            test.same(T.size, M(repeating: 1), "log2(max+1) size should be promoted to max infinite value")
        }   else {
            test.expect(T.size <= IX.max, "the maximum finite size is IX.max")
        }
    }
    
    public func protocols() where T: BinaryInteger {
        //=--------------------------------------=
        let isEdgy = !T.isSigned || !T.size.isInfinite
        //=--------------------------------------=
        test.same(   isEdgy,   T.self is any     EdgyInteger.Type,     "EdgyInteger")
        test.same( T.isSigned, T.self is any   SignedInteger.Type,   "SignedInteger")
        test.same(!T.isSigned, T.self is any UnsignedInteger.Type, "UnsignedInteger")
    }
}
