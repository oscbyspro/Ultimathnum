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
// MARK: * Infinit Int x Addition
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereTheBaseTypeIs<Base>(_ type: Base.Type) where Base: SystemsInteger {
            typealias E = Base.Element
            typealias L = Base.Element.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<InfiniInt<E>>
            
            let a: [L] = [ 0,  0,  0,  0]
            let b: [L] = [~0, ~0, ~0, ~0]
            let c: [L] = [~1, ~0, ~0, ~0] // +1
            
            Test().same(T(a, repeating: 0).plus(T(a, repeating: 0)), F(T(a, repeating: 0)))
            Test().same(T(a, repeating: 0).plus(T(a, repeating: 1)), F(T(a, repeating: 1)))
            Test().same(T(a, repeating: 1).plus(T(a, repeating: 0)), F(T(a, repeating: 1)))
            Test().same(T(a, repeating: 1).plus(T(a, repeating: 1)), F(T(a  + [~1] as [L], repeating: 1), error: !T.isSigned))
            
            Test().same(T(a, repeating: 0).plus(T(b, repeating: 0)), F(T(b, repeating: 0)))
            Test().same(T(a, repeating: 0).plus(T(b, repeating: 1)), F(T(b, repeating: 1)))
            Test().same(T(a, repeating: 1).plus(T(b, repeating: 0)), F(T(b, repeating: 1)))
            Test().same(T(a, repeating: 1).plus(T(b, repeating: 1)), F(T(b  + [~1] as [L], repeating: 1), error: !T.isSigned))

            Test().same(T(b, repeating: 0).plus(T(a, repeating: 0)), F(T(b, repeating: 0)))
            Test().same(T(b, repeating: 0).plus(T(a, repeating: 1)), F(T(b, repeating: 1)))
            Test().same(T(b, repeating: 1).plus(T(a, repeating: 0)), F(T(b, repeating: 1)))
            Test().same(T(b, repeating: 1).plus(T(a, repeating: 1)), F(T(b  + [~1] as [L], repeating: 1), error: !T.isSigned))
            
            Test().same(T(b, repeating: 0).plus(T(b, repeating: 0)), F(T(c  + [ 1] as [L], repeating: 0)))
            Test().same(T(b, repeating: 0).plus(T(b, repeating: 1)), F(T(c, repeating: 0), error: !T.isSigned))
            Test().same(T(b, repeating: 1).plus(T(b, repeating: 0)), F(T(c, repeating: 0), error: !T.isSigned))
            Test().same(T(b, repeating: 1).plus(T(b, repeating: 1)), F(T(c, repeating: 1), error: !T.isSigned))
        }
        
        for element in elements {
            whereTheBaseTypeIs(element)
        }
    }
}
