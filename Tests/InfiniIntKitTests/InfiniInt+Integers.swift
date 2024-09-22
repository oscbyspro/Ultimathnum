//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Infini Int x Integers
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testValidationAsExactlyArbitraryAppendixValues() {
        func whereIs<A, B>(_ source: A.Type, _ destination: B.Type) where A: BinaryInteger, B: BinaryInteger {
            Test().exactly(A.zero &- 2, Fallible(B.zero &- 2, error: A.isSigned != B.isSigned))
            Test().exactly(A.zero &- 1, Fallible(B.zero &- 1, error: A.isSigned != B.isSigned))
            Test().exactly(A.zero,      Fallible(B.zero))
            Test().exactly(A.zero &+ 1, Fallible(B.zero &+ 1))
            Test().exactly(A.zero &+ 2, Fallible(B.zero &+ 2))
        }
        
        for source in Self.types {
            for destination in Self.types {
                whereIs(source, destination)
            }
        }
    }
    
    func testValidationByClampingArbitraryAppendixValues() {
        func whereIs<A, B>(_ source: A.Type, _ destination: B.Type) where A: BinaryInteger, B: BinaryInteger {
            Test().same(B(clamping: A.zero &- 2), A.isSigned == B.isSigned ? B.zero &- 2 : A.isSigned ? B.zero : nil)
            Test().same(B(clamping: A.zero &- 1), A.isSigned == B.isSigned ? B.zero &- 1 : A.isSigned ? B.zero : nil)
            Test().same(B(clamping: A.zero     ), B.zero     )
            Test().same(B(clamping: A.zero &+ 1), B.zero &+ 1)
            Test().same(B(clamping: A.zero &+ 2), B.zero &+ 2)
        }
        
        func whereTheSourceIsFinite<A, B>(_ source: A.Type, _ destination: B.Type) where A: FiniteInteger, B: BinaryInteger {
            Test().same(B(clamping: A.zero     ) as B, B.zero     )
            Test().same(B(clamping: A.zero &+ 1) as B, B.zero &+ 1)
            Test().same(B(clamping: A.zero &+ 2) as B, B.zero &+ 2)
        }
        
        func whereTheDestinationIsEdgy<A, B>(_ source: A.Type, _ destination: B.Type) where A: BinaryInteger, B: EdgyInteger {
            Test().same(B(clamping: A.zero     ) as B, B.zero     )
            Test().same(B(clamping: A.zero &+ 1) as B, B.zero &+ 1)
            Test().same(B(clamping: A.zero &+ 2) as B, B.zero &+ 2)
        }
        
        for source in Self.types {
            for destination in Self.types {
                whereIs(source, destination)
            }
        }
        
        for source in Self.typesWhereIsSigned {
            for destination in Self.types {
                whereTheSourceIsFinite(source, destination)
            }
        }
        
        for source in Self.types {
            for destination in Self.typesWhereIsUnsigned {
                whereTheDestinationIsEdgy(source, destination)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIntegerLiterals() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            typealias F = Fallible<T>
            Test().same(T.exactly(-0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), F((~0 as T) << 128 + 1, error: !T.isSigned))
            Test().same(T.exactly(-0x80000000000000000000000000000001), F((~0 as T) << 127 - 1, error: !T.isSigned))
            Test().same(T.exactly(-0x80000000000000000000000000000000), F((~0 as T) << 127,     error: !T.isSigned))
            Test().same(T.exactly( 0x00000000000000000000000000000000), F(T.zero))
            Test().same(T.exactly( 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), F(( 1 as T) << 127 - 1))
            Test().same(T.exactly( 0x80000000000000000000000000000000), F(( 1 as T) << 127    ))
            Test().same(T.exactly( 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF), F(( 1 as T) << 128 - 1))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
