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
// MARK: * Infini Int x Addition
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddition() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).additionOfMinMaxEsque()
            IntegerInvariants(T.self).additionOfRepeatingBit(BinaryIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testSubtraction() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).negation()
            IntegerInvariants(T.self).subtractionOfMinMaxEsque()
            IntegerInvariants(T.self).subtractionOfRepeatingBit(BinaryIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many + Bit
    //=------------------------------------------------------------------------=
    
    func testAdditionOfManyByBit() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = InfiniInt<B>
            typealias F = Fallible<T>
            
            let a: [UX] = [ 0,  0,  0,  0,  0,  0,  0,  0]
            let b: [UX] = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0]
            let c: [UX] = [ 1,  0,  0,  0,  0,  0,  0,  0]
            
            Test().addition(T(a, repeating: 0), 0, F(T(a, repeating: 0)))
            Test().addition(T(a, repeating: 1), 0, F(T(a, repeating: 1)))
            Test().addition(T(b, repeating: 0), 0, F(T(b, repeating: 0)))
            Test().addition(T(b, repeating: 1), 0, F(T(b, repeating: 1)))
            
            Test().addition(T(a, repeating: 0), 1, F(T(c + [ 0] as [UX], repeating: 0)))
            Test().addition(T(a, repeating: 1), 1, F(T(c + [~0] as [UX], repeating: 1)))
            Test().addition(T(b, repeating: 0), 1, F(T(a + [ 1] as [UX], repeating: 0)))
            Test().addition(T(b, repeating: 1), 1, F(T(a + [ 0] as [UX], repeating: 0), error: !T.isSigned))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testSubtractionOfManyByBit() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = InfiniInt<B>
            typealias F = Fallible<T>
            
            let a: [UX] = [ 0,  0,  0,  0,  0,  0,  0,  0]
            let b: [UX] = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0]
            let c: [UX] = [~1, ~0, ~0, ~0, ~0, ~0, ~0, ~0]
            
            Test().subtraction(T(a, repeating: 0), 0, F(T(a, repeating: 0)))
            Test().subtraction(T(a, repeating: 1), 0, F(T(a, repeating: 1)))
            Test().subtraction(T(b, repeating: 0), 0, F(T(b, repeating: 0)))
            Test().subtraction(T(b, repeating: 1), 0, F(T(b, repeating: 1)))
            
            Test().subtraction(T(a, repeating: 0), 1, F(T(b + [~0] as [UX], repeating: 1), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 1), 1, F(T(b + [~1] as [UX], repeating: 1)))
            Test().subtraction(T(b, repeating: 0), 1, F(T(c + [ 0] as [UX], repeating: 0)))
            Test().subtraction(T(b, repeating: 1), 1, F(T(c + [~0] as [UX], repeating: 1)))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many + Many
    //=------------------------------------------------------------------------=
    
    func testAdditionOfManyByMany() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = InfiniInt<B>
            typealias F = Fallible<T>
            
            let a: [UX] = [ 0,  0,  0,  0,  0,  0,  0,  0]
            let b: [UX] = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0]
            let c: [UX] = [~1, ~0, ~0, ~0, ~0, ~0, ~0, ~0] // +1
            
            Test().addition(T(a, repeating: 0), T(a, repeating: 0), F(T(a + [ 0] as [UX], repeating: 0)))
            Test().addition(T(a, repeating: 0), T(a, repeating: 1), F(T(a + [~0] as [UX], repeating: 1)))
            Test().addition(T(a, repeating: 1), T(a, repeating: 0), F(T(a + [~0] as [UX], repeating: 1)))
            Test().addition(T(a, repeating: 1), T(a, repeating: 1), F(T(a + [~1] as [UX], repeating: 1), error: !T.isSigned))
            
            Test().addition(T(a, repeating: 0), T(b, repeating: 0), F(T(b + [ 0] as [UX], repeating: 0)))
            Test().addition(T(a, repeating: 0), T(b, repeating: 1), F(T(b + [~0] as [UX], repeating: 1)))
            Test().addition(T(a, repeating: 1), T(b, repeating: 0), F(T(b + [~0] as [UX], repeating: 1)))
            Test().addition(T(a, repeating: 1), T(b, repeating: 1), F(T(b + [~1] as [UX], repeating: 1), error: !T.isSigned))

            Test().addition(T(b, repeating: 0), T(a, repeating: 0), F(T(b + [ 0] as [UX], repeating: 0)))
            Test().addition(T(b, repeating: 0), T(a, repeating: 1), F(T(b + [~0] as [UX], repeating: 1)))
            Test().addition(T(b, repeating: 1), T(a, repeating: 0), F(T(b + [~0] as [UX], repeating: 1)))
            Test().addition(T(b, repeating: 1), T(a, repeating: 1), F(T(b + [~1] as [UX], repeating: 1), error: !T.isSigned))
            
            Test().addition(T(b, repeating: 0), T(b, repeating: 0), F(T(c + [ 1] as [UX], repeating: 0)))
            Test().addition(T(b, repeating: 0), T(b, repeating: 1), F(T(c + [ 0] as [UX], repeating: 0), error: !T.isSigned))
            Test().addition(T(b, repeating: 1), T(b, repeating: 0), F(T(c + [ 0] as [UX], repeating: 0), error: !T.isSigned))
            Test().addition(T(b, repeating: 1), T(b, repeating: 1), F(T(c + [~0] as [UX], repeating: 1), error: !T.isSigned))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
    
    func testSubtractionOfManyByMany() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = InfiniInt<B>
            typealias F = Fallible<T>
            
            let a: [UX] = [ 0,  0,  0,  0,  0,  0,  0,  0]
            let b: [UX] = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0]
            let c: [UX] = [ 1,  0,  0,  0,  0,  0,  0,  0] // -1
            
            Test().subtraction(T(a, repeating: 0), T(a, repeating: 0), F(T(a + [ 0] as [UX], repeating: 0)))
            Test().subtraction(T(a, repeating: 0), T(a, repeating: 1), F(T(a + [ 1] as [UX], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 1), T(a, repeating: 0), F(T(a + [~0] as [UX], repeating: 1)))
            Test().subtraction(T(a, repeating: 1), T(a, repeating: 1), F(T(a + [ 0] as [UX], repeating: 0)))

            Test().subtraction(T(a, repeating: 0), T(b, repeating: 0), F(T(c + [~0] as [UX], repeating: 1), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 0), T(b, repeating: 1), F(T(c + [ 0] as [UX], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 1), T(b, repeating: 0), F(T(c + [~1] as [UX], repeating: 1)))
            Test().subtraction(T(a, repeating: 1), T(b, repeating: 1), F(T(c + [~0] as [UX], repeating: 1), error: !T.isSigned))

            Test().subtraction(T(b, repeating: 0), T(a, repeating: 0), F(T(b + [ 0] as [UX], repeating: 0)))
            Test().subtraction(T(b, repeating: 0), T(a, repeating: 1), F(T(b + [ 1] as [UX], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(b, repeating: 1), T(a, repeating: 0), F(T(b + [~0] as [UX], repeating: 1)))
            Test().subtraction(T(b, repeating: 1), T(a, repeating: 1), F(T(b + [ 0] as [UX], repeating: 0)))
            
            Test().subtraction(T(b, repeating: 0), T(b, repeating: 0), F(T(a + [ 0] as [UX], repeating: 0)))
            Test().subtraction(T(b, repeating: 0), T(b, repeating: 1), F(T(a + [ 1] as [UX], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(b, repeating: 1), T(b, repeating: 0), F(T(a + [~0] as [UX], repeating: 1)))
            Test().subtraction(T(b, repeating: 1), T(b, repeating: 1), F(T(a + [ 0] as [UX], repeating: 0)))
        }
        
        for element in Self.elements {
            whereTheBaseTypeIs(element)
        }
    }
}
