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
// MARK: * Infini Int x Division
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDivisionByNegative() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger & SignedInteger {
            //=----------------------------------=
            let  small: T = 0x0000000000000000000000000000007F
            let xsmall: T = small.complement()
            let  large: T = 0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0
            let xlarge: T = large.complement()
            let  ratio: T = 0x020406080A0C0E10121416181A1C1E20
            let xratio: T = ratio.complement()
            //=----------------------------------=
            Test().division( small,  small,  T( 1),  T( 0))
            Test().division( small, xsmall, ~T( 0),  T( 0))
            Test().division(xsmall,  small, ~T( 0),  T( 0))
            Test().division(xsmall, xsmall,  T( 1),  T( 0))
            
            Test().division( small,  large,  T( 0),  small)
            Test().division( small, xlarge,  T( 0),  small)
            Test().division(xsmall,  large,  T( 0), xsmall)
            Test().division(xsmall, xlarge,  T( 0), xsmall)
            
            Test().division( large,  small,  ratio,  00016)
            Test().division( large, xsmall, xratio,  00016)
            Test().division(xlarge,  small, xratio, ~00015)
            Test().division(xlarge, xsmall,  ratio, ~00015)
            
            Test().division( large,  large,  T( 1),  T( 0))
            Test().division( large, xlarge, ~T( 0),  T( 0))
            Test().division(xlarge,  large, ~T( 0),  T( 0))
            Test().division(xlarge, xlarge,  T( 1),  T( 0))
        }
                        
        for element in Self.typesWhereIsSigned {
            whereIs(element)
        }
    }
    
    func testDivisionByInfinite() {
        func whereIs<T>(_ type: T.Type) where T: ArbitraryInteger & UnsignedInteger {
            //=----------------------------------=
            let  small: T = 0x0000000000000000000000000000007F
            let xsmall: T = small.complement()
            let  large: T = 0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0
            let xlarge: T = large.complement()
            let  ratio: T = 0x020406080A0C0E10121416181A1C1E20
            let xratio: T = ratio.complement()
            //=----------------------------------=
            Test().division( small,  small,  T( 1),  T( 0))
            Test().division( small, xsmall,  T( 0),  small)
            Test().division(xsmall,  small, ~T( 0),  T( 0), !T.isSigned)
            Test().division(xsmall, xsmall,  T( 1),  T( 0))
            
            Test().division( small,  large,  T( 0),  small)
            Test().division( small, xlarge,  T( 0),  small)
            Test().division(xsmall,  large,  T( 0), xsmall, !T.isSigned)
            Test().division(xsmall, xlarge,  T( 1),  large - small)
            
            Test().division( large,  small,  ratio,  00016)
            Test().division( large, xsmall,  T( 0),  large)
            Test().division(xlarge,  small, xratio, ~00015, !T.isSigned)
            Test().division(xlarge, xsmall,  T( 0), xlarge)
            
            Test().division( large,  large,  T( 1),  T( 0))
            Test().division( large, xlarge,  T( 0),  large)
            Test().division(xlarge,  large, ~T( 0),  T( 0), !T.isSigned)
            Test().division(xlarge, xlarge,  T( 1),  T( 0))
        }
                        
        for element in Self.typesWhereIsUnsigned {
            whereIs(element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Code Coverage
    //=------------------------------------------------------------------------=
    
    func testDivisionLongCodeCoverage() {
        func whereIs<T, S>(_ type: T.Type, _ source: S.Type) where T: ArbitraryInteger, S: SystemsInteger & UnsignedInteger {
            //=----------------------------------=
            var dividend: T, divisor: T, quotient: T, remainder: T
            //=----------------------------------=
            dividend  = T([ 0,  0,  0,  0,  0, ~0, ~0, ~0] as [S])
            divisor   = T([~0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            quotient  = T([ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            remainder = T([ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            
            Test().division(dividend, divisor, quotient, remainder)
            //=----------------------------------=
            dividend  = T([~0, ~0, ~0, ~0,  0, ~0, ~0, ~0] as [S])
            divisor   = T([~0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            quotient  = T([ 1, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            remainder = T([ 0, ~0, ~0, ~0,  0,  0,  0,  0] as [S])
            
            Test().division(dividend, divisor, quotient, remainder)
        }
        
        // 2024-05-15: The whereIs(U8.self, U64.self) case found a Karatsuba multiplication bug.
        for type in Self.types {
            for source in coreSystemsIntegersWhereIsUnsigned {
                whereIs(type, source)
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Documentation
//=----------------------------------------------------------------------------=

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBinaryIntegerDivisionDocumentationExamples() {
        Test().division( 7 as IXL,  3 as IXL,  2 as IXL,  1 as IXL)
        Test().division( 7 as IXL, -3 as IXL, -2 as IXL,  1 as IXL)
        Test().division(-7 as IXL,  3 as IXL, -2 as IXL, -1 as IXL)
        Test().division(-7 as IXL, -3 as IXL,  2 as IXL, -1 as IXL)
        
        Test().division(~2 as UXL, ~0 as UXL,  0 as UXL, ~2 as UXL)
        Test().division(~2 as UXL, ~1 as UXL,  0 as UXL, ~2 as UXL)
        Test().division(~2 as UXL, ~2 as UXL,  1 as UXL,  0 as UXL)
        Test().division(~2 as UXL, ~3 as UXL,  1 as UXL,  1 as UXL)
        
        Test().division(~2 as UXL,  0 as UXL, nil)
        Test().division(~2 as UXL,  1 as UXL, ~2 as UXL,  0 as UXL, true)
        Test().division(~2 as UXL,  2 as UXL, ~0 as UXL, ~0 as UXL, true)
        Test().division(~2 as UXL,  3 as UXL, ~0 as UXL,  0 as UXL, true)
    }
}
