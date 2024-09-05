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
        func whereTheBaseIs<B>(_ base: B.Type) where B: SystemsInteger {
            typealias T = TripleInt<B>
            typealias F = Fallible<T>
            
            Test().complement(T(low:  0, mid:  0, high:  00000), false, F(T(low: ~0, mid: ~0, high: ~00000)))
            Test().complement(T(low:  0, mid:  0, high:  00000), true,  F(T(low:  0, mid:  0, high:  00000), error: !B.isSigned))
            Test().complement(T(low:  1, mid:  2, high:  00003), false, F(T(low: ~1, mid: ~2, high: ~00003)))
            Test().complement(T(low:  1, mid:  2, high:  00003), true,  F(T(low: ~0, mid: ~2, high: ~00003)))
            
            Test().complement(T(low: ~0, mid: ~0, high: ~B.msb), false, F(T(low:  0, mid:  0, high:  B.msb)))
            Test().complement(T(low: ~0, mid: ~0, high: ~B.msb), true,  F(T(low:  1, mid:  0, high:  B.msb)))
            Test().complement(T(low:  0, mid:  0, high:  B.msb), false, F(T(low: ~0, mid: ~0, high: ~B.msb)))
            Test().complement(T(low:  0, mid:  0, high:  B.msb), true,  F(T(low:  0, mid:  0, high:  B.msb), error:  B.isSigned))
        }
        
        for base in Self.bases {
            whereTheBaseIs(base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

private extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func complement<B>(_ instance: TripleInt<B>, _ increment: Bool, _ expectation: Fallible<TripleInt<B>>) {
        same(instance.complement(increment), expectation, "complement [0]")
        
        if  increment {
            same(instance.complement(), expectation.value, "complement [1]")
        }   else {
            let roundtrip = instance.complement(increment).value.complement(increment).value
            same(roundtrip, instance, "complement [2]")
        }
        
        if  increment, instance.high.isNegative {
            same(TripleInt(raw: instance.magnitude()), expectation.value, "complement [3]")
        }   else {
            same(TripleInt(raw: instance.magnitude()), instance, "complement [4]")
        }
    }
}
