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
// MARK: * Infinite Int x Subtraction
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtraction() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = E.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<T>
            //=----------------------------------=
            IntegerInvariants(T.self).subtractionByNegation()
            IntegerInvariants(T.self).subtractionOfMinMaxEsque()
            IntegerInvariants(T.self).subtractionOfRepeatingBit(BinaryIntegerID())
            //=----------------------------------=
            let a: [L] = [ 0,  0,  0,  0]
            let b: [L] = [~0, ~0, ~0, ~0]
            let c: [L] = [ 1,  0,  0,  0] // -1
            
            Test().subtraction(T(a, repeating: 0), T(a, repeating: 0), F(T(a + [ 0] as [L], repeating: 0)))
            Test().subtraction(T(a, repeating: 0), T(a, repeating: 1), F(T(a + [ 1] as [L], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 1), T(a, repeating: 0), F(T(a + [~0] as [L], repeating: 1)))
            Test().subtraction(T(a, repeating: 1), T(a, repeating: 1), F(T(a + [ 0] as [L], repeating: 0)))

            Test().subtraction(T(a, repeating: 0), T(b, repeating: 0), F(T(c + [~0] as [L], repeating: 1), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 0), T(b, repeating: 1), F(T(c + [ 0] as [L], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 1), T(b, repeating: 0), F(T(c + [~1] as [L], repeating: 1)))
            Test().subtraction(T(a, repeating: 1), T(b, repeating: 1), F(T(c + [~0] as [L], repeating: 1), error: !T.isSigned))

            Test().subtraction(T(b, repeating: 0), T(a, repeating: 0), F(T(b + [ 0] as [L], repeating: 0)))
            Test().subtraction(T(b, repeating: 0), T(a, repeating: 1), F(T(b + [ 1] as [L], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(b, repeating: 1), T(a, repeating: 0), F(T(b + [~0] as [L], repeating: 1)))
            Test().subtraction(T(b, repeating: 1), T(a, repeating: 1), F(T(b + [ 0] as [L], repeating: 0)))
            
            Test().subtraction(T(b, repeating: 0), T(b, repeating: 0), F(T(a + [ 0] as [L], repeating: 0)))
            Test().subtraction(T(b, repeating: 0), T(b, repeating: 1), F(T(a + [ 1] as [L], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(b, repeating: 1), T(b, repeating: 0), F(T(a + [~0] as [L], repeating: 1)))
            Test().subtraction(T(b, repeating: 1), T(b, repeating: 1), F(T(a + [ 0] as [L], repeating: 0)))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testSubtractionBy1() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias E = B.Element
            typealias L = E.Magnitude
            typealias T = InfiniInt<E>
            typealias F = Fallible<T>
            
            let a: [L] = [ 0,  0,  0,  0]
            let b: [L] = [~0, ~0, ~0, ~0]
            let c: [L] = [~1, ~0, ~0, ~0]
            
            Test().subtraction(T(a, repeating: 0), 1, F(T(b + [~0] as [L], repeating: 1), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 1), 1, F(T(b + [~1] as [L], repeating: 1)))
            Test().subtraction(T(b, repeating: 0), 1, F(T(c + [ 0] as [L], repeating: 0)))
            Test().subtraction(T(b, repeating: 1), 1, F(T(c + [~0] as [L], repeating: 1)))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
}
