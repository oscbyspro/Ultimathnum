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
// MARK: * Infinit Int x Division
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDocumentationTables() {
        Test().division( 7 as IXL,  3 as IXL, Fallible(quotient:  2 as IXL, remainder:  1 as IXL))
        Test().division( 7 as IXL, -3 as IXL, Fallible(quotient: -2 as IXL, remainder:  1 as IXL))
        Test().division(-7 as IXL,  3 as IXL, Fallible(quotient: -2 as IXL, remainder: -1 as IXL))
        Test().division(-7 as IXL, -3 as IXL, Fallible(quotient:  2 as IXL, remainder: -1 as IXL))
        //=--------------------------------------=
        Test().division(~2 as UXL, ~0 as UXL, Fallible(quotient:  0 as UXL, remainder: ~2 as UXL))
        Test().division(~2 as UXL, ~1 as UXL, Fallible(quotient:  0 as UXL, remainder: ~2 as UXL))
        Test().division(~2 as UXL, ~2 as UXL, Fallible(quotient:  1 as UXL, remainder:  0 as UXL))
        Test().division(~2 as UXL, ~3 as UXL, Fallible(quotient:  1 as UXL, remainder:  1 as UXL))
        
        Test().division(~2 as UXL,  1 as UXL, Fallible(quotient: ~2 as UXL, remainder:  0 as UXL))
        Test().division(~2 as UXL,  2 as UXL, Fallible(quotient: ~0 as UXL, remainder: ~0 as UXL)) // TODO: error
        Test().division(~2 as UXL,  3 as UXL, Fallible(quotient: ~0 as UXL, remainder:  0 as UXL)) // TODO: error
        Test().division(~2 as UXL,  4 as UXL, Fallible(quotient:  0 as UXL, remainder: ~2 as UXL)) // TODO: error
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
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    func testDivisionByNegative() {
        func whereIs<T>(_ type: T.Type) where T: SignedInteger {
            typealias E = T.Element
            typealias L = T.Element.Magnitude
            typealias F = Fallible<Division<T, T>>
            //=----------------------------------=
            let  small = T(0x0000000000000000000000000000007F)
            let xsmall = small.complement()
            let  large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            let xlarge = large.complement()
            let  ratio = T(0x020406080A0C0E10121416181A1C1E20)
            let xratio = ratio.complement()
            //=----------------------------------=
            Test().division( small,  small, F(quotient:  T( 1), remainder:  T( 0)))
            Test().division( small, xsmall, F(quotient: ~T( 0), remainder:  T( 0)))
            Test().division(xsmall,  small, F(quotient: ~T( 0), remainder:  T( 0)))
            Test().division(xsmall, xsmall, F(quotient:  T( 1), remainder:  T( 0)))
            
            Test().division( small,  large, F(quotient:  T( 0), remainder:  small))
            Test().division( small, xlarge, F(quotient:  T( 0), remainder:  small))
            Test().division(xsmall,  large, F(quotient:  T( 0), remainder: xsmall))
            Test().division(xsmall, xlarge, F(quotient:  T( 0), remainder: xsmall))
            
            Test().division( large,  small, F(quotient:  ratio, remainder:  00016))
            Test().division( large, xsmall, F(quotient: xratio, remainder:  00016))
            Test().division(xlarge,  small, F(quotient: xratio, remainder: ~00015))
            Test().division(xlarge, xsmall, F(quotient:  ratio, remainder: ~00015))
            
            Test().division( large,  large, F(quotient:  T( 1), remainder:  T( 0)))
            Test().division( large, xlarge, F(quotient: ~T( 0), remainder:  T( 0)))
            Test().division(xlarge,  large, F(quotient: ~T( 0), remainder:  T( 0)))
            Test().division(xlarge, xlarge, F(quotient:  T( 1), remainder:  T( 0)))
        }
                        
        for element in Self.typesWhereIsSigned {
            whereIs(element)
        }
    }
    
    func testDivisionByInfinite() {
        func whereIs<T>(_ type: T.Type) where T: UnsignedInteger {
            typealias E = T.Element
            typealias L = T.Element.Magnitude
            typealias F = Fallible<Division<T, T>>
            //=----------------------------------=
            let  small = T(0x0000000000000000000000000000007F)
            let xsmall = small.complement()
            let  large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            let xlarge = large.complement()
            let  ratio = T(0x020406080A0C0E10121416181A1C1E20)
            let xratio = ratio.complement()
            //=----------------------------------=
            Test().division( small,  small, F(quotient:  T( 1), remainder:  T( 0)))
            Test().division( small, xsmall, F(quotient:  T( 0), remainder:  small))
            Test().division(xsmall,  small, F(quotient: ~T( 0), remainder:  T( 0)))
            Test().division(xsmall, xsmall, F(quotient:  T( 1), remainder:  T( 0)))
            
            Test().division( small,  large, F(quotient:  T( 0), remainder:  small))
            Test().division( small, xlarge, F(quotient:  T( 0), remainder:  small))
            Test().division(xsmall,  large, F(quotient:  T( 0), remainder: xsmall))
            Test().division(xsmall, xlarge, F(quotient:  T( 1), remainder:  large - small))
            
            Test().division( large,  small, F(quotient:  ratio, remainder:  00016))
            Test().division( large, xsmall, F(quotient:  T( 0), remainder:  large))
            Test().division(xlarge,  small, F(quotient: xratio, remainder: ~00015))
            Test().division(xlarge, xsmall, F(quotient:  T( 0), remainder: xlarge))
            
            Test().division( large,  large, F(quotient:  T( 1), remainder:  T( 0)))
            Test().division( large, xlarge, F(quotient:  T( 0), remainder:  large))
            Test().division(xlarge,  large, F(quotient: ~T( 0), remainder:  T( 0)))
            Test().division(xlarge, xlarge, F(quotient:  T( 1), remainder:  T( 0)))
        }
                        
        for element in Self.typesWhereIsUnsigned {
            whereIs(element)
        }
    }
}
