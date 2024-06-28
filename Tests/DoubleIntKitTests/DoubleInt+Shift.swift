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
// MARK: * Double Int x Shift
//*============================================================================*

extension DoubleIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testShift() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger {
            IntegerInvariants(T.self)  .upshiftRepeatingBit()
            IntegerInvariants(T.self).downshiftRepeatingBit()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testUpshift() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            //=----------------------------------=
            let low = T.zero
            let mid = T(low: B.size)
            let top = T(raw: T.size)
            //=----------------------------------=
            Test().upshift(T(low: 1, high:  2), low + 0 as T, T(low:  1, high:  2))
            Test().upshift(T(low: 1, high:  2), low + 1 as T, T(low:  2, high:  4))
            Test().upshift(T(low: 1, high:  2), low + 2 as T, T(low:  4, high:  8))
            Test().upshift(T(low: 1, high:  2), low + 3 as T, T(low:  8, high: 16))
            
            Test().upshift(T(low: 1, high:  2), mid - 3 as T, T(low:  B.Magnitude.msb / 4, high: B(raw: B.Magnitude.msb / 2)))
            Test().upshift(T(low: 1, high:  2), mid - 2 as T, T(low:  B.Magnitude.msb / 2, high: B(raw: B.Magnitude.msb    )))
            Test().upshift(T(low: 1, high:  2), mid - 1 as T, T(low:  B.Magnitude.msb,     high: 000000000000000000000000000))
            Test().upshift(T(low: 1, high:  2), mid + 0 as T, T(low:  0, high:  1))
            Test().upshift(T(low: 1, high:  2), mid + 1 as T, T(low:  0, high:  2))
            Test().upshift(T(low: 1, high:  2), mid + 2 as T, T(low:  0, high:  4))
            Test().upshift(T(low: 1, high:  2), mid + 3 as T, T(low:  0, high:  8))
            
            Test().upshift(T(low: 1, high:  2), top - 0 as T, T(low:  0, high:  0))
            Test().upshift(T(low: 1, high:  2), top - 1 as T, T(low:  0, high:  B(raw: B.Magnitude.msb    )))
            Test().upshift(T(low: 1, high:  2), top - 2 as T, T(low:  0, high:  B(raw: B.Magnitude.msb / 2)))
            Test().upshift(T(low: 1, high:  2), top - 3 as T, T(low:  0, high:  B(raw: B.Magnitude.msb / 4)))
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testDownshift() {
        func whereTheBaseTypeIs<B>(_ type: B.Type) where B: SystemsInteger {
            typealias T = DoubleInt<B>
            //=----------------------------------=
            let low = T.zero
            let mid = T(low: B.size)
            let top = T(raw: T.size)
            //=----------------------------------=
            Test().downshift(T(low: 8, high: 16), low + 0 as T, T(low:  8, high: 16))
            Test().downshift(T(low: 8, high: 16), low + 1 as T, T(low:  4, high:  8))
            Test().downshift(T(low: 8, high: 16), low + 2 as T, T(low:  2, high:  4))
            Test().downshift(T(low: 8, high: 16), low + 3 as T, T(low:  1, high:  2))
            
            Test().downshift(T(low: 8, high: 16), mid + 0 as T, T(low: 16, high:  0))
            Test().downshift(T(low: 8, high: 16), mid + 1 as T, T(low:  8, high:  0))
            Test().downshift(T(low: 8, high: 16), mid + 2 as T, T(low:  4, high:  0))
            Test().downshift(T(low: 8, high: 16), mid + 3 as T, T(low:  2, high:  0))
            
            if  T.isSigned {
                let x = B.Magnitude.msb
                Test().downshift(T(low: 0, high: B.msb), mid - 3 as T, T(low:  0, high: ~3))
                Test().downshift(T(low: 0, high: B.msb), mid - 2 as T, T(low:  0, high: ~1))
                Test().downshift(T(low: 0, high: B.msb), mid - 1 as T, T(low:  0, high: ~0))
                Test().downshift(T(low: 0, high: B.msb), mid - 0 as T, T(low:  x, high: ~0))
                
                Test().downshift(T(low: 0, high: B.msb), top - 3 as T, T(low: ~3, high: ~0))
                Test().downshift(T(low: 0, high: B.msb), top - 2 as T, T(low: ~1, high: ~0))
                Test().downshift(T(low: 0, high: B.msb), top - 1 as T, T(low: ~0, high: ~0))
                Test().downshift(T(low: 0, high: B.msb), top - 0 as T, T(low: ~0, high: ~0))
            }   else {
                let x = B.Magnitude.msb
                Test().downshift(T(low: 0, high: B.msb), mid - 3 as T, T(low:  0, high:  4))
                Test().downshift(T(low: 0, high: B.msb), mid - 2 as T, T(low:  0, high:  2))
                Test().downshift(T(low: 0, high: B.msb), mid - 1 as T, T(low:  0, high:  1))
                Test().downshift(T(low: 0, high: B.msb), mid - 0 as T, T(low:  x, high:  0))
                
                Test().downshift(T(low: 0, high: B.msb), top - 3 as T, T(low:  4, high:  0))
                Test().downshift(T(low: 0, high: B.msb), top - 2 as T, T(low:  2, high:  0))
                Test().downshift(T(low: 0, high: B.msb), top - 1 as T, T(low:  1, high:  0))
                Test().downshift(T(low: 0, high: B.msb), top - 0 as T, T(low:  0, high:  0))
            }
        }
        
        for base in Self.bases {
            whereTheBaseTypeIs(base)
        }
    }
    
    func testUpshiftByMinSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            for value in [T.zero, ~T.zero, T.min, ~T.min, T.max, ~T.max] {
                Test().upshift(value, T.min,     T(repeating: value.appendix))
                Test().upshift(value, T.min + 1, T(repeating: value.appendix))
                Test().upshift(value, T.min + 2, T(repeating: value.appendix))
            }
        }
        
        for type in Self.typesWhereIsSigned {
            whereIsSigned(type)
        }
    }
    
    func testDownshiftByMinSigned() {
        func whereIsSigned<T>(_ type: T.Type) where T: SystemsInteger & SignedInteger {
            for value in [T.zero, ~T.zero, T.min, ~T.min, T.max, ~T.max] {
                Test().downshift(value, T.min,     T(repeating: Bit.zero))
                Test().downshift(value, T.min + 1, T(repeating: Bit.zero))
                Test().downshift(value, T.min + 2, T(repeating: Bit.zero))
            }
        }
        
        for type in Self.typesWhereIsSigned {
            whereIsSigned(type)
        }
    }
}
