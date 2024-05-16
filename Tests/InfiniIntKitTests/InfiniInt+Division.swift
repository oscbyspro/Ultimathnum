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
// MARK: * Infinite Int x Division
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryIntegerDocumentationExamples() {
        typealias D = Division
        typealias F = Fallible
        
        Test().division( 7 as IXL,  3 as IXL, F(D(quotient:  2 as IXL, remainder:  1 as IXL)))
        Test().division( 7 as IXL, -3 as IXL, F(D(quotient: -2 as IXL, remainder:  1 as IXL)))
        Test().division(-7 as IXL,  3 as IXL, F(D(quotient: -2 as IXL, remainder: -1 as IXL)))
        Test().division(-7 as IXL, -3 as IXL, F(D(quotient:  2 as IXL, remainder: -1 as IXL)))
        
        Test().division(~2 as UXL, ~0 as UXL, F(D(quotient:  0 as UXL, remainder: ~2 as UXL)))
        Test().division(~2 as UXL, ~1 as UXL, F(D(quotient:  0 as UXL, remainder: ~2 as UXL)))
        Test().division(~2 as UXL, ~2 as UXL, F(D(quotient:  1 as UXL, remainder:  0 as UXL)))
        Test().division(~2 as UXL, ~3 as UXL, F(D(quotient:  1 as UXL, remainder:  1 as UXL)))
        
        Test().division(~2 as UXL,  1 as UXL, F(D(quotient: ~2 as UXL, remainder:  0 as UXL)))
        Test().division(~2 as UXL,  2 as UXL, F(D(quotient: ~0 as UXL, remainder: ~0 as UXL), error: true))
        Test().division(~2 as UXL,  3 as UXL, F(D(quotient: ~0 as UXL, remainder:  0 as UXL), error: true))
        Test().division(~2 as UXL,  4 as UXL, F(D(quotient:  0 as UXL, remainder: ~2 as UXL), error: true))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivision() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).divisionOfMsbEsque()
            IntegerInvariants(T.self).divisionOfSmallBySmall()
            IntegerInvariants(T.self).divisionByZero(BinaryIntegerID())
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: UnsignedInteger {
            IntegerInvariants(T.self).divisionLongCodeCoverage(BinaryIntegerID())
        }
        
        for type in Self.types {
            whereIs(type)
        }
        
        for type in Self.typesWhereIsUnsigned {
            whereIsUnsigned(type)
        }
    }
    
    func testDivisionByNegative() {
        func whereIs<T>(_ type: T.Type) where T: SignedInteger {
            typealias E = T.Element
            typealias D = Division<T, T>
            typealias F = Fallible<D>
            //=----------------------------------=
            let  small = T(0x0000000000000000000000000000007F)
            let xsmall = small.complement()
            let  large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            let xlarge = large.complement()
            let  ratio = T(0x020406080A0C0E10121416181A1C1E20)
            let xratio = ratio.complement()
            //=----------------------------------=
            Test().division( small,  small, F(D(quotient:  T( 1), remainder:  T( 0))))
            Test().division( small, xsmall, F(D(quotient: ~T( 0), remainder:  T( 0))))
            Test().division(xsmall,  small, F(D(quotient: ~T( 0), remainder:  T( 0))))
            Test().division(xsmall, xsmall, F(D(quotient:  T( 1), remainder:  T( 0))))
            
            Test().division( small,  large, F(D(quotient:  T( 0), remainder:  small)))
            Test().division( small, xlarge, F(D(quotient:  T( 0), remainder:  small)))
            Test().division(xsmall,  large, F(D(quotient:  T( 0), remainder: xsmall)))
            Test().division(xsmall, xlarge, F(D(quotient:  T( 0), remainder: xsmall)))
            
            Test().division( large,  small, F(D(quotient:  ratio, remainder:  00016)))
            Test().division( large, xsmall, F(D(quotient: xratio, remainder:  00016)))
            Test().division(xlarge,  small, F(D(quotient: xratio, remainder: ~00015)))
            Test().division(xlarge, xsmall, F(D(quotient:  ratio, remainder: ~00015)))
            
            Test().division( large,  large, F(D(quotient:  T( 1), remainder:  T( 0))))
            Test().division( large, xlarge, F(D(quotient: ~T( 0), remainder:  T( 0))))
            Test().division(xlarge,  large, F(D(quotient: ~T( 0), remainder:  T( 0))))
            Test().division(xlarge, xlarge, F(D(quotient:  T( 1), remainder:  T( 0))))
        }
                        
        for element in Self.typesWhereIsSigned {
            whereIs(element)
        }
    }
    
    func testDivisionByInfinite() {
        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            typealias E = T.Element
            typealias D = Division<T, T>
            typealias F = Fallible<D>
            //=----------------------------------=
            let  small = T(0x0000000000000000000000000000007F)
            let xsmall = small.complement()
            let  large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            let xlarge = large.complement()
            let  ratio = T(0x020406080A0C0E10121416181A1C1E20)
            let xratio = ratio.complement()
            //=----------------------------------=
            Test().division( small,  small, F(D(quotient:  T( 1), remainder:  T( 0))))
            Test().division( small, xsmall, F(D(quotient:  T( 0), remainder:  small)))
            Test().division(xsmall,  small, F(D(quotient: ~T( 0), remainder:  T( 0)),  error: !T.isSigned))
            Test().division(xsmall, xsmall, F(D(quotient:  T( 1), remainder:  T( 0))))
            
            Test().division( small,  large, F(D(quotient:  T( 0), remainder:  small)))
            Test().division( small, xlarge, F(D(quotient:  T( 0), remainder:  small)))
            Test().division(xsmall,  large, F(D(quotient:  T( 0), remainder: xsmall),  error: !T.isSigned))
            Test().division(xsmall, xlarge, F(D(quotient:  T( 1), remainder:  large - small)))
            
            Test().division( large,  small, F(D(quotient:  ratio, remainder:  00016)))
            Test().division( large, xsmall, F(D(quotient:  T( 0), remainder:  large)))
            Test().division(xlarge,  small, F(D(quotient: xratio, remainder: ~00015),  error: !T.isSigned))
            Test().division(xlarge, xsmall, F(D(quotient:  T( 0), remainder: xlarge)))
            
            Test().division( large,  large, F(D(quotient:  T( 1), remainder:  T( 0))))
            Test().division( large, xlarge, F(D(quotient:  T( 0), remainder:  large)))
            Test().division(xlarge,  large, F(D(quotient: ~T( 0), remainder:  T( 0)),  error: !T.isSigned))
            Test().division(xlarge, xlarge, F(D(quotient:  T( 1), remainder:  T( 0))))
        }
                        
        for element in Self.typesWhereIsUnsigned {
            whereIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Code Coverage
    //=------------------------------------------------------------------------=
    
    func testDivisionLongCodeCoverage() {
        func whereIs<T, S>(_ type: T.Type, _ source: S.Type) where T: BinaryInteger, S: SystemsInteger & UnsignedInteger {
            //=--------------------------------------=
            func make(_ source: [S]) -> T {
                source.withUnsafeBufferPointer({ T(DataInt($0)!, mode: .unsigned) })
            }
            //=--------------------------------------=
            var dividend: T, divisor: T, quotient: T, remainder: T
            //=--------------------------------------=
            dividend  = make([ 0,  0,  0,  0,  0, ~0, ~0, ~0] as [S])
            divisor   = make([~0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            quotient  = make([ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            remainder = make([ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            
            Test().division(dividend, divisor, quotient, remainder)
            //=--------------------------------------=
            dividend  = make([~0, ~0, ~0, ~0,  0, ~0, ~0, ~0] as [S])
            divisor   = make([~0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            quotient  = make([ 1, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            remainder = make([ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            
            Test().division(dividend, divisor, quotient, remainder)
        }
        
        // 2024-05-15: The whereIs(InfiniInt<U8>.self, U64.self) case found a Karatsuba multiplication bug.
        for type in Self.types {
            for source in coreSystemsIntegersWhereIsUnsigned {
                whereIs(type, source)
            }
        }
    }
}
