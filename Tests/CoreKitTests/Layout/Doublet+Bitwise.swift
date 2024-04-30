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
// MARK: * Doublet x Bitwise
//*============================================================================*

extension DoubletTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComplement() {
        func whereTheBaseTypeIs<B>(_ base: B.Type) where B: SystemsInteger {
            typealias T = Doublet<B>
            typealias F = Fallible<T>
            
            Case(T(low:  0, high:  0)).complement(false, is: F(T(low: ~0, high: ~0)))
            Case(T(low:  0, high:  0)).complement(true,  is: F(T(low:  0, high:  0), error: !B.isSigned))
            Case(T(low:  1, high:  2)).complement(false, is: F(T(low: ~1, high: ~2)))
            Case(T(low:  1, high:  2)).complement(true,  is: F(T(low: ~0, high: ~2)))
            
            Case(T(low: ~0, high: ~B.msb)).complement(false, is: F(T(low:  0, high:  B.msb)))
            Case(T(low: ~0, high: ~B.msb)).complement(true,  is: F(T(low:  1, high:  B.msb)))
            Case(T(low:  0, high:  B.msb)).complement(false, is: F(T(low: ~0, high: ~B.msb)))
            Case(T(low:  0, high:  B.msb)).complement(true,  is: F(T(low:  0, high:  B.msb), error: B.isSigned))
        }
        
        for base in coreSystemsIntegers {
            whereTheBaseTypeIs(base)
        }
    }
}
