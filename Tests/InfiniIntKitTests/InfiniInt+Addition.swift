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
import RandomIntKit
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
            Test().addition(T(a, repeating: Bit.zero), 0, F(T(a, repeating: Bit.zero)))
            Test().addition(T(a, repeating: Bit.one ), 0, F(T(a, repeating: Bit.one )))
            Test().addition(T(b, repeating: Bit.zero), 0, F(T(b, repeating: Bit.zero)))
            Test().addition(T(b, repeating: Bit.one ), 0, F(T(b, repeating: Bit.one )))
            
            Test().addition(T(a, repeating: Bit.zero), 1, F(T(c + [ 0] as [UX], repeating: Bit.zero)))
            Test().addition(T(a, repeating: Bit.one ), 1, F(T(c + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(b, repeating: Bit.zero), 1, F(T(a + [ 1] as [UX], repeating: Bit.zero)))
            Test().addition(T(b, repeating: Bit.one ), 1, F(T(a + [ 0] as [UX], repeating: Bit.zero), error: !T.isSigned))
            
            Test().addition(T(d, repeating: Bit.zero), 0, F(T(d, repeating: Bit.zero)))
            Test().addition(T(d, repeating: Bit.one ), 0, F(T(d, repeating: Bit.one )))
            Test().addition(T(e, repeating: Bit.zero), 0, F(T(e, repeating: Bit.zero)))
            Test().addition(T(e, repeating: Bit.one ), 0, F(T(e, repeating: Bit.one )))
            
            Test().addition(T(d, repeating: Bit.zero), 1, F(T(e, repeating: Bit.zero)))
            Test().addition(T(d, repeating: Bit.one ), 1, F(T(e, repeating: Bit.one )))
            Test().addition(T(e, repeating: Bit.zero), 1, F(T(f, repeating: Bit.zero)))
            Test().addition(T(e, repeating: Bit.one ), 1, F(T(f, repeating: Bit.one )))
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
            Test().subtraction(T(a, repeating: Bit.zero), 0, F(T(a, repeating: Bit.zero)))
            Test().subtraction(T(a, repeating: Bit.one ), 0, F(T(a, repeating: Bit.one )))
            Test().subtraction(T(b, repeating: Bit.zero), 0, F(T(b, repeating: Bit.zero)))
            Test().subtraction(T(b, repeating: Bit.one ), 0, F(T(b, repeating: Bit.one )))
            
            Test().subtraction(T(a, repeating: Bit.zero), 1, F(T(b + [~0] as [UX], repeating: Bit.one ), error: !T.isSigned))
            Test().subtraction(T(a, repeating: Bit.one ), 1, F(T(b + [~1] as [UX], repeating: Bit.one )))
            Test().subtraction(T(b, repeating: Bit.zero), 1, F(T(c + [ 0] as [UX], repeating: Bit.zero)))
            Test().subtraction(T(b, repeating: Bit.one ), 1, F(T(c + [~0] as [UX], repeating: Bit.one )))
            
            Test().subtraction(T(d, repeating: Bit.zero), 0, F(T(d, repeating: Bit.zero)))
            Test().subtraction(T(d, repeating: Bit.one ), 0, F(T(d, repeating: Bit.one )))
            Test().subtraction(T(e, repeating: Bit.zero), 0, F(T(e, repeating: Bit.zero)))
            Test().subtraction(T(e, repeating: Bit.one ), 0, F(T(e, repeating: Bit.one )))
            
            Test().subtraction(T(d, repeating: Bit.zero), 1, F(T(f, repeating: Bit.zero)))
            Test().subtraction(T(d, repeating: Bit.one ), 1, F(T(f, repeating: Bit.one )))
            Test().subtraction(T(e, repeating: Bit.zero), 1, F(T(d, repeating: Bit.zero)))
            Test().subtraction(T(e, repeating: Bit.one ), 1, F(T(d, repeating: Bit.one )))
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
            Test().addition(T(a, repeating: Bit.zero), T(a, repeating: Bit.zero), F(T(a + [ 0] as [UX], repeating: Bit.zero)))
            Test().addition(T(a, repeating: Bit.zero), T(a, repeating: Bit.one ), F(T(a + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(a, repeating: Bit.one ), T(a, repeating: Bit.zero), F(T(a + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(a, repeating: Bit.one ), T(a, repeating: Bit.one ), F(T(a + [~1] as [UX], repeating: Bit.one ), error: !T.isSigned))
            
            Test().addition(T(a, repeating: Bit.zero), T(b, repeating: Bit.zero), F(T(b + [ 0] as [UX], repeating: Bit.zero)))
            Test().addition(T(a, repeating: Bit.zero), T(b, repeating: Bit.one ), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(a, repeating: Bit.one ), T(b, repeating: Bit.zero), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(a, repeating: Bit.one ), T(b, repeating: Bit.one ), F(T(b + [~1] as [UX], repeating: Bit.one ), error: !T.isSigned))

            Test().addition(T(b, repeating: Bit.zero), T(a, repeating: Bit.zero), F(T(b + [ 0] as [UX], repeating: Bit.zero)))
            Test().addition(T(b, repeating: Bit.zero), T(a, repeating: Bit.one ), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(b, repeating: Bit.one ), T(a, repeating: Bit.zero), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(b, repeating: Bit.one ), T(a, repeating: Bit.one ), F(T(b + [~1] as [UX], repeating: Bit.one ), error: !T.isSigned))
            
            Test().addition(T(b, repeating: Bit.zero), T(b, repeating: Bit.zero), F(T(c + [ 1] as [UX], repeating: Bit.zero)))
            Test().addition(T(b, repeating: Bit.zero), T(b, repeating: Bit.one ), F(T(c + [ 0] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().addition(T(b, repeating: Bit.one ), T(b, repeating: Bit.zero), F(T(c + [ 0] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().addition(T(b, repeating: Bit.one ), T(b, repeating: Bit.one ), F(T(c + [~0] as [UX], repeating: Bit.one ), error: !T.isSigned))
            //=----------------------------------=
            Test().addition(T(d, repeating: Bit.zero), T(d, repeating: Bit.zero), F(T(c + [ 0] as [UX], repeating: Bit.zero)))
            Test().addition(T(d, repeating: Bit.zero), T(d, repeating: Bit.one ), F(T(c + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(d, repeating: Bit.one ), T(d, repeating: Bit.zero), F(T(c + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(d, repeating: Bit.one ), T(d, repeating: Bit.one ), F(T(c + [~1] as [UX], repeating: Bit.one ), error: !T.isSigned))
            
            Test().addition(T(d, repeating: Bit.zero), T(e, repeating: Bit.zero), F(T(b + [ 0] as [UX], repeating: Bit.zero)))
            Test().addition(T(d, repeating: Bit.zero), T(e, repeating: Bit.one ), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(d, repeating: Bit.one ), T(e, repeating: Bit.zero), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(d, repeating: Bit.one ), T(e, repeating: Bit.one ), F(T(b + [~1] as [UX], repeating: Bit.one ), error: !T.isSigned))
            
            Test().addition(T(e, repeating: Bit.zero), T(d, repeating: Bit.zero), F(T(b + [ 0] as [UX], repeating: Bit.zero)))
            Test().addition(T(e, repeating: Bit.zero), T(d, repeating: Bit.one ), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(e, repeating: Bit.one ), T(d, repeating: Bit.zero), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().addition(T(e, repeating: Bit.one ), T(d, repeating: Bit.one ), F(T(b + [~1] as [UX], repeating: Bit.one ), error: !T.isSigned))
            
            Test().addition(T(e, repeating: Bit.zero), T(e, repeating: Bit.zero), F(T(a + [ 1] as [UX], repeating: Bit.zero)))
            Test().addition(T(e, repeating: Bit.zero), T(e, repeating: Bit.one ), F(T(a + [ 0] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().addition(T(e, repeating: Bit.one ), T(e, repeating: Bit.zero), F(T(a + [ 0] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().addition(T(e, repeating: Bit.one ), T(e, repeating: Bit.one ), F(T(a + [~0] as [UX], repeating: Bit.one ), error: !T.isSigned))
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
            Test().subtraction(T(a, repeating: Bit.zero), T(a, repeating: Bit.zero), F(T(a + [ 0] as [UX], repeating: Bit.zero)))
            Test().subtraction(T(a, repeating: Bit.zero), T(a, repeating: Bit.one ), F(T(a + [ 1] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().subtraction(T(a, repeating: Bit.one ), T(a, repeating: Bit.zero), F(T(a + [~0] as [UX], repeating: Bit.one )))
            Test().subtraction(T(a, repeating: Bit.one ), T(a, repeating: Bit.one ), F(T(a + [ 0] as [UX], repeating: Bit.zero)))

            Test().subtraction(T(a, repeating: Bit.zero), T(b, repeating: Bit.zero), F(T(c + [~0] as [UX], repeating: Bit.one ), error: !T.isSigned))
            Test().subtraction(T(a, repeating: Bit.zero), T(b, repeating: Bit.one ), F(T(c + [ 0] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().subtraction(T(a, repeating: Bit.one ), T(b, repeating: Bit.zero), F(T(c + [~1] as [UX], repeating: Bit.one )))
            Test().subtraction(T(a, repeating: Bit.one ), T(b, repeating: Bit.one ), F(T(c + [~0] as [UX], repeating: Bit.one ), error: !T.isSigned))

            Test().subtraction(T(b, repeating: Bit.zero), T(a, repeating: Bit.zero), F(T(b + [ 0] as [UX], repeating: Bit.zero)))
            Test().subtraction(T(b, repeating: Bit.zero), T(a, repeating: Bit.one ), F(T(b + [ 1] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().subtraction(T(b, repeating: Bit.one ), T(a, repeating: Bit.zero), F(T(b + [~0] as [UX], repeating: Bit.one )))
            Test().subtraction(T(b, repeating: Bit.one ), T(a, repeating: Bit.one ), F(T(b + [ 0] as [UX], repeating: Bit.zero)))
            
            Test().subtraction(T(b, repeating: Bit.zero), T(b, repeating: Bit.zero), F(T(a + [ 0] as [UX], repeating: Bit.zero)))
            Test().subtraction(T(b, repeating: Bit.zero), T(b, repeating: Bit.one ), F(T(a + [ 1] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().subtraction(T(b, repeating: Bit.one ), T(b, repeating: Bit.zero), F(T(a + [~0] as [UX], repeating: Bit.one )))
            Test().subtraction(T(b, repeating: Bit.one ), T(b, repeating: Bit.one ), F(T(a + [ 0] as [UX], repeating: Bit.zero)))
            //=----------------------------------=
            Test().subtraction(T(d, repeating: Bit.zero), T(d, repeating: Bit.zero), F(T(a + [ 0] as [UX], repeating: Bit.zero)))
            Test().subtraction(T(d, repeating: Bit.zero), T(d, repeating: Bit.one ), F(T(a + [ 1] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().subtraction(T(d, repeating: Bit.one ), T(d, repeating: Bit.zero), F(T(a + [~0] as [UX], repeating: Bit.one )))
            Test().subtraction(T(d, repeating: Bit.one ), T(d, repeating: Bit.one ), F(T(a + [ 0] as [UX], repeating: Bit.zero)))
            
            Test().subtraction(T(d, repeating: Bit.zero), T(e, repeating: Bit.zero), F(T(b + [~0] as [UX], repeating: Bit.one ), error: !T.isSigned))
            Test().subtraction(T(d, repeating: Bit.zero), T(e, repeating: Bit.one ), F(T(b + [ 0] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().subtraction(T(d, repeating: Bit.one ), T(e, repeating: Bit.zero), F(T(b + [~1] as [UX], repeating: Bit.one )))
            Test().subtraction(T(d, repeating: Bit.one ), T(e, repeating: Bit.one ), F(T(b + [~0] as [UX], repeating: Bit.one ), error: !T.isSigned))
            
            Test().subtraction(T(e, repeating: Bit.zero), T(d, repeating: Bit.zero), F(T(c + [ 0] as [UX], repeating: Bit.zero)))
            Test().subtraction(T(e, repeating: Bit.zero), T(d, repeating: Bit.one ), F(T(c + [ 1] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().subtraction(T(e, repeating: Bit.one ), T(d, repeating: Bit.zero), F(T(c + [~0] as [UX], repeating: Bit.one )))
            Test().subtraction(T(e, repeating: Bit.one ), T(d, repeating: Bit.one ), F(T(c + [ 0] as [UX], repeating: Bit.zero)))
            
            Test().subtraction(T(e, repeating: Bit.zero), T(e, repeating: Bit.zero), F(T(a + [ 0] as [UX], repeating: Bit.zero)))
            Test().subtraction(T(e, repeating: Bit.zero), T(e, repeating: Bit.one ), F(T(a + [ 1] as [UX], repeating: Bit.zero), error: !T.isSigned))
            Test().subtraction(T(e, repeating: Bit.one ), T(e, repeating: Bit.zero), F(T(a + [~0] as [UX], repeating: Bit.one )))
            Test().subtraction(T(e, repeating: Bit.one ), T(e, repeating: Bit.one ), F(T(a + [ 0] as [UX], repeating: Bit.zero)))
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
}
