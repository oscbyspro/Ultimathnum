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
// MARK: * Signum
//*============================================================================*

final class SignumTests: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        Test().same(Signum(0 as Bit), Signum.zero)
        Test().same(Signum(1 as Bit), Signum.positive)
    }
    
    func testInitSign() {
        Test().same(Signum(Sign.plus ), Signum.positive)
        Test().same(Signum(Sign.minus), Signum.negative)
        
        Test().same(Signum(Optional<Sign>(nil )), Signum.zero)
        Test().same(Signum(Optional(Sign.plus )), Signum.positive)
        Test().same(Signum(Optional(Sign.minus)), Signum.negative)
    }
    
    func testInitIntegerLiteral() {
        Test().same(-1 as Signum, Signum.negative)
        Test().same( 0 as Signum, Signum.zero)
        Test().same( 1 as Signum, Signum.positive)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparison() {
        Test().yay(Signum.negative.isNegative)
        Test().nay(Signum.negative.isZero)
        Test().nay(Signum.negative.isPositive)
        Test().nay(Signum.zero    .isNegative)
        Test().yay(Signum.zero    .isZero)
        Test().nay(Signum.zero    .isPositive)
        Test().nay(Signum.positive.isNegative)
        Test().nay(Signum.positive.isZero)
        Test().yay(Signum.positive.isPositive)
        
        Test().same(Signum.negative, Signum.negative)
        Test().less(Signum.negative, Signum.zero)
        Test().less(Signum.negative, Signum.positive)
        Test().more(Signum.zero,     Signum.negative)
        Test().same(Signum.zero,     Signum.zero)
        Test().less(Signum.zero,     Signum.positive)
        Test().more(Signum.positive, Signum.negative)
        Test().more(Signum.positive, Signum.zero)
        Test().same(Signum.positive, Signum.positive)
                
        Test().same(Signum.negative.compared(to: Signum.negative),  0)
        Test().same(Signum.negative.compared(to: Signum.zero),     -1)
        Test().same(Signum.negative.compared(to: Signum.positive), -1)
        Test().same(Signum.zero    .compared(to: Signum.negative),  1)
        Test().same(Signum.zero    .compared(to: Signum.zero),      0)
        Test().same(Signum.zero    .compared(to: Signum.positive), -1)
        Test().same(Signum.positive.compared(to: Signum.negative),  1)
        Test().same(Signum.positive.compared(to: Signum.zero),      1)
        Test().same(Signum.positive.compared(to: Signum.positive),  0)
    }
    
    func testNegation() {
        Test().same(-Signum.negative, Signum.positive)
        Test().same(-Signum.zero,     Signum.zero)
        Test().same(-Signum.positive, Signum.negative)
        
        Test().same( Signum.negative.negated(), Signum.positive)
        Test().same( Signum.zero    .negated(), Signum.zero)
        Test().same( Signum.positive.negated(), Signum.negative)
        
        Test().same({ var x = Signum.negative; x.negate(); return x }(), Signum.positive)
        Test().same({ var x = Signum.zero;     x.negate(); return x }(), Signum.zero)
        Test().same({ var x = Signum.positive; x.negate(); return x }(), Signum.negative)
    }
}
