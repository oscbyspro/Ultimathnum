//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import InfiniIntKit
import TestKit

//*============================================================================*
// MARK: * Binary Integer x Metadata
//*============================================================================*

final class BinaryIntegerTestsOnMetadata: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testProtocols() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().same( T.isArbitrary, T.self is any  ArbitraryInteger.Type, "ArbitraryInteger")
            Test().same(!T.isArbitrary, T.self is any    SystemsInteger.Type,   "SystemsInteger")
            Test().same( T.isEdgy,      T.self is any       EdgyInteger.Type,      "EdgyInteger")
            Test().same(!T.isEdgy,      T.self is any (ArbitraryInteger &   SignedInteger).Type, "non-EdgyInteger")
            Test().same( T.isFinite,    T.self is any     FiniteInteger.Type,    "FiniteInteger")
            Test().same(!T.isFinite,    T.self is any (ArbitraryInteger & UnsignedInteger).Type, "non-FiniteInteger")
            Test().same( T.isSigned,    T.self is any     SignedInteger.Type,    "SignedInteger")
            Test().same(!T.isSigned,    T.self is any   UnsignedInteger.Type,  "UnsignedInteger")
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testMode() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            Test().same( T.isSigned, T.mode == Signedness  .signed)
            Test().same(!T.isSigned, T.mode == Signedness.unsigned)
        }
        
        for type in binaryIntegers {
            whereIs(type)
        }
    }
    
    func testSize() {
        func whereIsBinaryInteger<T>(_ type: T.Type) where T: BinaryInteger {
            Test().same(T.size, T.Magnitude.size, "T.size == T.Magnitude.size")
            Test().same(T.size, T.Signitude.size, "T.size == T.Signitude.size")
            
            for value: T in [~3, ~2, ~1, ~0, 0, 1, 2, 3] {
                let x0 = IX(raw: value.count(0))
                let x1 = IX(raw: value.count(1))
                Test().same(Count(raw: x0 + x1), T.size, "size == 0s + 1s [\(value), \(x0), \(x1)]")
            }
            
            if !T.size.isInfinite {
                Test().expect(T.size <= Count(IX.max), "the maximum finite size is IX.max")
            }   else {
                Test().same(T.size, Count.infinity, "any infinite size must be log2(UXL.max + 1)")
            }
        }
        
        func whereIsSystemsInteger<T>(_ type: T.Type) where T: SystemsInteger {
            Test().same(
                IX(size: T.self).count(1),
                Count(1),
                "\(T.self).size must be a power of 2"
            )
            
            Test().same(
                IX(size: T.self),
                IX(MemoryLayout<T>.size) * 8,
                "\(T.self).size must match memory layout"
            )
            
            Test().same(
                MemoryLayout<T>.size,
                MemoryLayout<T>.stride,
                "\(T.self)'s size must be the same as its stride"
            )
            
            Test().yay(
                MemoryLayout<T>.size.isMultiple(of: MemoryLayout<T.Element>.alignment),
                "\(T.self)'s size must be a multiple of \(T.Element.self)'s size"
            )
            
            Test().yay(
                MemoryLayout<T>.stride.isMultiple(of: MemoryLayout<T.Element>.alignment),
                "\(T.self)'s stride must be a multiple of \(T.Element.self)'s stride"
            )
            
            Test().yay(
                MemoryLayout<T>.alignment.isMultiple(of: MemoryLayout<T.Element>.alignment),
                "\(T.self)'s alignment must be a multiple of \(T.Element.self)'s alignment"
            )
        }
        
        for type in binaryIntegers {
            whereIsBinaryInteger(type)
        }
        
        for type in systemsIntegers {
            whereIsSystemsInteger(type)
        }
    }
}
