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
    // MARK: Tests x Many + Bit
    //=------------------------------------------------------------------------=
    
    func testAdditionOfManyByBit() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let x: (UX) = UX.msb
            let a: [UX] = [ 0,  0,  0,  0]
            let b: [UX] = [~0, ~0, ~0, ~0]
            let c: [UX] = [ 1,  0,  0,  0]
            let d: [UX] = [~0, ~0, ~0, ~x]
            let e: [UX] = [ 0,  0,  0,  x]
            let f: [UX] = [ 1,  0,  0,  x]
            //=----------------------------------=
            Test().addition(T(a, repeating: 0), 0, F(T(a, repeating: 0)))
            Test().addition(T(a, repeating: 1), 0, F(T(a, repeating: 1)))
            Test().addition(T(b, repeating: 0), 0, F(T(b, repeating: 0)))
            Test().addition(T(b, repeating: 1), 0, F(T(b, repeating: 1)))
            
            Test().addition(T(a, repeating: 0), 1, F(T(c + [ 0] as [UX], repeating: 0)))
            Test().addition(T(a, repeating: 1), 1, F(T(c + [~0] as [UX], repeating: 1)))
            Test().addition(T(b, repeating: 0), 1, F(T(a + [ 1] as [UX], repeating: 0)))
            Test().addition(T(b, repeating: 1), 1, F(T(a + [ 0] as [UX], repeating: 0), error: !T.isSigned))
            
            Test().addition(T(d, repeating: 0), 0, F(T(d, repeating: 0)))
            Test().addition(T(d, repeating: 1), 0, F(T(d, repeating: 1)))
            Test().addition(T(e, repeating: 0), 0, F(T(e, repeating: 0)))
            Test().addition(T(e, repeating: 1), 0, F(T(e, repeating: 1)))
            
            Test().addition(T(d, repeating: 0), 1, F(T(e, repeating: 0)))
            Test().addition(T(d, repeating: 1), 1, F(T(e, repeating: 1)))
            Test().addition(T(e, repeating: 0), 1, F(T(f, repeating: 0)))
            Test().addition(T(e, repeating: 1), 1, F(T(f, repeating: 1)))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testSubtractionOfManyByBit() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let x: (UX) = UX.msb
            let a: [UX] = [ 0,  0,  0,  0]
            let b: [UX] = [~0, ~0, ~0, ~0]
            let c: [UX] = [~1, ~0, ~0, ~0]
            let d: [UX] = [~0, ~0, ~0, ~x]
            let e: [UX] = [ 0,  0,  0,  x]
            let f: [UX] = [~1, ~0, ~0, ~x]
            //=----------------------------------=
            Test().subtraction(T(a, repeating: 0), 0, F(T(a, repeating: 0)))
            Test().subtraction(T(a, repeating: 1), 0, F(T(a, repeating: 1)))
            Test().subtraction(T(b, repeating: 0), 0, F(T(b, repeating: 0)))
            Test().subtraction(T(b, repeating: 1), 0, F(T(b, repeating: 1)))
            
            Test().subtraction(T(a, repeating: 0), 1, F(T(b + [~0] as [UX], repeating: 1), error: !T.isSigned))
            Test().subtraction(T(a, repeating: 1), 1, F(T(b + [~1] as [UX], repeating: 1)))
            Test().subtraction(T(b, repeating: 0), 1, F(T(c + [ 0] as [UX], repeating: 0)))
            Test().subtraction(T(b, repeating: 1), 1, F(T(c + [~0] as [UX], repeating: 1)))
            
            Test().subtraction(T(d, repeating: 0), 0, F(T(d, repeating: 0)))
            Test().subtraction(T(d, repeating: 1), 0, F(T(d, repeating: 1)))
            Test().subtraction(T(e, repeating: 0), 0, F(T(e, repeating: 0)))
            Test().subtraction(T(e, repeating: 1), 0, F(T(e, repeating: 1)))
            
            Test().subtraction(T(d, repeating: 0), 1, F(T(f, repeating: 0)))
            Test().subtraction(T(d, repeating: 1), 1, F(T(f, repeating: 1)))
            Test().subtraction(T(e, repeating: 0), 1, F(T(d, repeating: 0)))
            Test().subtraction(T(e, repeating: 1), 1, F(T(d, repeating: 1)))
        }
        
        for types in Self.types {
            whereIs(types)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Many + Many
    //=------------------------------------------------------------------------=
    
    func testAdditionOfManyByMany() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let x: (UX) = UX.msb
            let a: [UX] = [ 0,  0,  0,  0]
            let b: [UX] = [~0, ~0, ~0, ~0]
            let c: [UX] = [~1, ~0, ~0, ~0]
            let d: [UX] = [~0, ~0, ~0, ~x]
            let e: [UX] = [ 0,  0,  0,  x]
            //=----------------------------------=
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
            //=----------------------------------=
            Test().addition(T(d, repeating: 0), T(d, repeating: 0), F(T(c + [ 0] as [UX], repeating: 0)))
            Test().addition(T(d, repeating: 0), T(d, repeating: 1), F(T(c + [~0] as [UX], repeating: 1)))
            Test().addition(T(d, repeating: 1), T(d, repeating: 0), F(T(c + [~0] as [UX], repeating: 1)))
            Test().addition(T(d, repeating: 1), T(d, repeating: 1), F(T(c + [~1] as [UX], repeating: 1), error: !T.isSigned))
            
            Test().addition(T(d, repeating: 0), T(e, repeating: 0), F(T(b + [ 0] as [UX], repeating: 0)))
            Test().addition(T(d, repeating: 0), T(e, repeating: 1), F(T(b + [~0] as [UX], repeating: 1)))
            Test().addition(T(d, repeating: 1), T(e, repeating: 0), F(T(b + [~0] as [UX], repeating: 1)))
            Test().addition(T(d, repeating: 1), T(e, repeating: 1), F(T(b + [~1] as [UX], repeating: 1), error: !T.isSigned))
            
            Test().addition(T(e, repeating: 0), T(d, repeating: 0), F(T(b + [ 0] as [UX], repeating: 0)))
            Test().addition(T(e, repeating: 0), T(d, repeating: 1), F(T(b + [~0] as [UX], repeating: 1)))
            Test().addition(T(e, repeating: 1), T(d, repeating: 0), F(T(b + [~0] as [UX], repeating: 1)))
            Test().addition(T(e, repeating: 1), T(d, repeating: 1), F(T(b + [~1] as [UX], repeating: 1), error: !T.isSigned))
            
            Test().addition(T(e, repeating: 0), T(e, repeating: 0), F(T(a + [ 1] as [UX], repeating: 0)))
            Test().addition(T(e, repeating: 0), T(e, repeating: 1), F(T(a + [ 0] as [UX], repeating: 0), error: !T.isSigned))
            Test().addition(T(e, repeating: 1), T(e, repeating: 0), F(T(a + [ 0] as [UX], repeating: 0), error: !T.isSigned))
            Test().addition(T(e, repeating: 1), T(e, repeating: 1), F(T(a + [~0] as [UX], repeating: 1), error: !T.isSigned))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testSubtractionOfManyByMany() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger {
            typealias F = Fallible<T>
            //=----------------------------------=
            let x: (UX) = UX.msb
            let a: [UX] = [ 0,  0,  0,  0]
            let b: [UX] = [~0, ~0, ~0, ~0]
            let c: [UX] = [ 1,  0,  0,  0]
            let d: [UX] = [~0, ~0, ~0, ~x]
            let e: [UX] = [ 0,  0,  0,  x]
            //=----------------------------------=
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
            //=----------------------------------=
            Test().subtraction(T(d, repeating: 0), T(d, repeating: 0), F(T(a + [ 0] as [UX], repeating: 0)))
            Test().subtraction(T(d, repeating: 0), T(d, repeating: 1), F(T(a + [ 1] as [UX], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(d, repeating: 1), T(d, repeating: 0), F(T(a + [~0] as [UX], repeating: 1)))
            Test().subtraction(T(d, repeating: 1), T(d, repeating: 1), F(T(a + [ 0] as [UX], repeating: 0)))
            
            Test().subtraction(T(d, repeating: 0), T(e, repeating: 0), F(T(b + [~0] as [UX], repeating: 1), error: !T.isSigned))
            Test().subtraction(T(d, repeating: 0), T(e, repeating: 1), F(T(b + [ 0] as [UX], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(d, repeating: 1), T(e, repeating: 0), F(T(b + [~1] as [UX], repeating: 1)))
            Test().subtraction(T(d, repeating: 1), T(e, repeating: 1), F(T(b + [~0] as [UX], repeating: 1), error: !T.isSigned))
            
            Test().subtraction(T(e, repeating: 0), T(d, repeating: 0), F(T(c + [ 0] as [UX], repeating: 0)))
            Test().subtraction(T(e, repeating: 0), T(d, repeating: 1), F(T(c + [ 1] as [UX], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(e, repeating: 1), T(d, repeating: 0), F(T(c + [~0] as [UX], repeating: 1)))
            Test().subtraction(T(e, repeating: 1), T(d, repeating: 1), F(T(c + [ 0] as [UX], repeating: 0)))
            
            Test().subtraction(T(e, repeating: 0), T(e, repeating: 0), F(T(a + [ 0] as [UX], repeating: 0)))
            Test().subtraction(T(e, repeating: 0), T(e, repeating: 1), F(T(a + [ 1] as [UX], repeating: 0), error: !T.isSigned))
            Test().subtraction(T(e, repeating: 1), T(e, repeating: 0), F(T(a + [~0] as [UX], repeating: 1)))
            Test().subtraction(T(e, repeating: 1), T(e, repeating: 1), F(T(a + [ 0] as [UX], repeating: 0)))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
