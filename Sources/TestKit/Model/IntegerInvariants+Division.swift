//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Integer Invariants x Division
//*============================================================================*

extension IntegerInvariants {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func divisionAboutMsbEsque() where T: BinaryInteger {
        //=--------------------------------------=
        let shl: T = (T.size.isInfinite ? 127 : T(raw: T.size - 1))
        let msb: T = (T.isSigned ? -001 : 001) << shl
        let inv: T = (T.isSigned ? ~msb : msb  &- 01)
        //=--------------------------------------=
        if T.isSigned {
            test.division(msb, msb >> 1, Fallible(quotient:  2, remainder: 0))
            test.division(inv, msb >> 1, Fallible(quotient: -1, remainder: (msb >> 1 + 1).complement()))
        }   else {
            test.division(msb, msb >> 1, Fallible(quotient:  2, remainder: 0))
            test.division(inv, msb >> 1, Fallible(quotient:  1, remainder: (msb >> 1 - 1)))
        }
        
        if  T.isSigned {
            test.division(inv, ~3 as T, Fallible(quotient: msb >> 2 + 1, remainder: 3))
            test.division(inv, ~1 as T, Fallible(quotient: msb >> 1 + 1, remainder: 1))
            test.division(inv, ~0 as T, Fallible(quotient: msb >> 0 + 1, remainder: 0))
            test.division(inv,  0 as T, nil)
            test.division(inv,  1 as T, Fallible(quotient: inv,          remainder: 0))
            test.division(inv,  2 as T, Fallible(quotient: inv >> 1,     remainder: 1))
            test.division(inv,  4 as T, Fallible(quotient: inv >> 2,     remainder: 3))
            
            test.division(msb, ~3 as T, Fallible(quotient: (msb >> 2).complement(), remainder: 0))
            test.division(msb, ~1 as T, Fallible(quotient: (msb >> 1).complement(), remainder: 0))
            test.division(msb, ~0 as T, Fallible(quotient: (msb >> 0).complement(), remainder: 0, error: msb.count(.ascending(0)) == T.size - 1))
            test.division(msb,  0 as T, nil)
            test.division(msb,  1 as T, Fallible(quotient: msb,          remainder: 0))
            test.division(msb,  2 as T, Fallible(quotient: msb >> 1,     remainder: 0))
            test.division(msb,  4 as T, Fallible(quotient: msb >> 2,     remainder: 0))
        }   else {
            test.division(inv, ~3 as T, Fallible(quotient: T.zero,       remainder: inv))
            test.division(inv, ~1 as T, Fallible(quotient: T.zero,       remainder: inv))
            test.division(inv, ~0 as T, Fallible(quotient: T.zero,       remainder: inv))
            test.division(inv,  0 as T, nil)
            test.division(inv,  1 as T, Fallible(quotient: inv,          remainder: 0))
            test.division(inv,  2 as T, Fallible(quotient: inv >> 1,     remainder: 1))
            
            test.division(msb, ~1 as T, Fallible(quotient: T.zero,       remainder: msb))
            test.division(msb, ~0 as T, Fallible(quotient: T.zero,       remainder: msb))
            test.division(msb,  0 as T, nil)
            test.division(msb,  1 as T, Fallible(quotient: msb,          remainder: 0))
            test.division(msb,  2 as T, Fallible(quotient: msb >> 1,     remainder: 0))
            test.division(msb,  4 as T, Fallible(quotient: msb >> 2,     remainder: 0))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func divisionAboutSmallBySmall() where T: BinaryInteger {
        //=--------------------------------------=
        let x0 = 0 as T
        let x7 = 7 as T
        //=--------------------------------------=
        for divisor:  T in [4, 3, 2, 1, ~0, ~1, ~2, ~3, ~4] {
            test.division( x0, divisor, Fallible(quotient: x0, remainder: x0))
        }
        
        if  T.isSigned {
            test.division( x7,  3 as T, Fallible(quotient:  2, remainder:  1))
            test.division( x7, -3 as T, Fallible(quotient: -2, remainder:  1))
            test.division(-x7,  3 as T, Fallible(quotient: -2, remainder: -1))
            test.division(-x7, -3 as T, Fallible(quotient:  2, remainder: -1))
        }   else {
            test.division( x7,  1 as T, Fallible(quotient:  7, remainder:  0))
            test.division( x7,  2 as T, Fallible(quotient:  3, remainder:  1))
            test.division( x7,  3 as T, Fallible(quotient:  2, remainder:  1))
            test.division( x7,  4 as T, Fallible(quotient:  1, remainder:  3))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func divisionAboutZeroDivisor(_ id: SystemsIntegerID) where T: SystemsInteger {
        //=--------------------------------------=
        self.divisionAboutZeroDivisor(BinaryIntegerID())
        //=--------------------------------------=
        let values: [T] = [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4]
        
        for high: T in values {
            for low: T.Magnitude in values.lazy.map(M.init(raw:)) {
                test.division(Doublet(low: low, high: high), T.zero, nil)
            }
        }
    }
    
    public func divisionAboutZeroDivisor(_ id: BinaryIntegerID) where T: BinaryInteger {
        for value: T in [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4] {
            test.division(value, T.zero, nil)
        }
        
        if  T.size > 128 || (T.size == 128 && !T.isSigned)  {
            let  small = T(0x0000000000000000000000000000007F)
            let xsmall = small.complement()
            let  large = T(0xFFFEFDFCFBFAF9F8F7F6F5F4F3F2F1F0)
            let xlarge = large.complement()
            
            for value in [small, xsmall, large, xlarge] {
                test.division(value, T.zero, nil)
            }
        }
    }
}
