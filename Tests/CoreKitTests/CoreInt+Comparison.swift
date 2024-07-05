//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Core Int x Comparison
//*============================================================================*

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self).comparisonOfGenericLowEntropy()
            IntegerInvariants(T.self).comparisonOfGenericMinMaxEsque()
            IntegerInvariants(T.self).comparisonOfGenericRepeatingBit()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    /// - Note: Generic tests may depend on these results.
    func testComparisonOfSize() {
        for size: Count<IX> in [I8 .size, U8 .size] {
            Test().comparison(size, U8 .size,  0 as Signum, id: ComparableID())
            Test().comparison(size, U16.size, -1 as Signum, id: ComparableID())
            Test().comparison(size, U32.size, -1 as Signum, id: ComparableID())
            Test().comparison(size, U64.size, -1 as Signum, id: ComparableID())
        }
        
        for size: Count<IX> in [I16.size, U16.size] {
            Test().comparison(size, U8 .size,  1 as Signum, id: ComparableID())
            Test().comparison(size, U16.size,  0 as Signum, id: ComparableID())
            Test().comparison(size, U32.size, -1 as Signum, id: ComparableID())
            Test().comparison(size, U64.size, -1 as Signum, id: ComparableID())
        }
        
        for size: Count<IX> in [I32.size, U32.size] {
            Test().comparison(size, U8 .size,  1 as Signum, id: ComparableID())
            Test().comparison(size, U16.size,  1 as Signum, id: ComparableID())
            Test().comparison(size, U32.size,  0 as Signum, id: ComparableID())
            Test().comparison(size, U64.size, -1 as Signum, id: ComparableID())
        }
        
        for size: Count<IX> in [I64.size, U64.size] {
            Test().comparison(size, U8 .size,  1 as Signum, id: ComparableID())
            Test().comparison(size, U16.size,  1 as Signum, id: ComparableID())
            Test().comparison(size, U32.size,  1 as Signum, id: ComparableID())
            Test().comparison(size, U64.size,  0 as Signum, id: ComparableID())
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension CoreIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 2024-06-16: Checks the use of `init(load:)` or similar.
    func testComparisonDoesNotReinterpretNegativeValuesAsUnsigned() {
        Test().comparison(-1 as I32, 0 as U8,  -1 as Signum) // OK
        Test().comparison(-1 as I32, 0 as U16, -1 as Signum) // OK
        Test().comparison(-1 as I32, 0 as U32, -1 as Signum) // OK
        Test().comparison(-1 as I32, 0 as U64, -1 as Signum) // :(
    }
}
