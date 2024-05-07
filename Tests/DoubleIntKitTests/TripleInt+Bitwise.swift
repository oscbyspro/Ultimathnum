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
import TestKit

//*============================================================================*
// MARK: * Triple Int x Bitwise
//*============================================================================*

extension TripleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComplement() {
        func whereTheBaseTypeIs<B>(_ base: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            typealias F = Fallible<T>
            
            Case(T(low:  0, mid:  0, high:  00000)).complement(false, is: F(T(low: ~0, mid: ~0, high: ~00000)))
            Case(T(low:  0, mid:  0, high:  00000)).complement(true,  is: F(T(low:  0, mid:  0, high:  00000), error: !B.isSigned))
            Case(T(low:  1, mid:  2, high:  00003)).complement(false, is: F(T(low: ~1, mid: ~2, high: ~00003)))
            Case(T(low:  1, mid:  2, high:  00003)).complement(true,  is: F(T(low: ~0, mid: ~2, high: ~00003)))
            
            Case(T(low: ~0, mid: ~0, high: ~B.msb)).complement(false, is: F(T(low:  0, mid:  0, high:  B.msb)))
            Case(T(low: ~0, mid: ~0, high: ~B.msb)).complement(true,  is: F(T(low:  1, mid:  0, high:  B.msb)))
            Case(T(low:  0, mid:  0, high:  B.msb)).complement(false, is: F(T(low: ~0, mid: ~0, high: ~B.msb)))
            Case(T(low:  0, mid:  0, high:  B.msb)).complement(true,  is: F(T(low:  0, mid:  0, high:  B.msb), error:  B.isSigned))
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseTypeIs(base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension TripleIntTests.Case {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func complement(_ increment: Bool, is expectation: Fallible<Item>) {
        always: do {
            test.same(item.complement(increment), expectation, "complement [0]")
        }
        
        if  increment {
            test.same(item.complement(), expectation.value, "complement [1]")
        }   else {
            let roundtrip = item.complement(increment).value.complement(increment).value
            test.same(roundtrip,  item, "complement [2]")
        }
        
        if  increment, item.high.isNegative {
            test.same(Item(raw: item.magnitude()), expectation.value, "complement [3]")
        }   else {
            test.same(Item(raw: item.magnitude()), item, "complement [4]")
        }
    }
}
