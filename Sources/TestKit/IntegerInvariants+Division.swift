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
    
    public func divisionOfMsbEsque() where T: BinaryInteger {
        typealias D = Division<T, T>
        typealias F = Fallible<D>
        //=--------------------------------------=
        let size = IX(raw: T.size)
        //=--------------------------------------=
        let msb: T = Self.msbEsque
        let bot: T = Self.botEsque
        //=--------------------------------------=
        if  T.isSigned {
            test.division(msb, msb >> 1, F(D(quotient:  2, remainder: 0)))
            test.division(bot, msb >> 1, F(D(quotient: -1, remainder: (msb >> 1 + 1).complement())))
        }   else {
            test.division(msb, msb >> 1, F(D(quotient:  2, remainder: 0)))
            test.division(bot, msb >> 1, F(D(quotient:  1, remainder: (msb >> 1 - 1))))
        }
        
        if  T.isSigned {
            test.division(bot, ~3 as T, F(D(quotient: msb >> 2 + 1, remainder: 3)))
            test.division(bot, ~1 as T, F(D(quotient: msb >> 1 + 1, remainder: 1)))
            test.division(bot, ~0 as T, F(D(quotient: msb >> 0 + 1, remainder: 0)))
            test.division(bot,  0 as T, nil)
            test.division(bot,  1 as T, F(D(quotient: bot,          remainder: 0)))
            test.division(bot,  2 as T, F(D(quotient: bot >> 1,     remainder: 1)))
            test.division(bot,  4 as T, F(D(quotient: bot >> 2,     remainder: 3)))
            
            test.division(msb, ~3 as T, F(D(quotient: (msb >> 2).complement(), remainder: 0)))
            test.division(msb, ~1 as T, F(D(quotient: (msb >> 1).complement(), remainder: 0)))
            test.division(msb, ~0 as T, F(D(quotient: (msb >> 0).complement(), remainder: 0), error: msb.ascending(0) == Count(raw: size - 1)))
            test.division(msb,  0 as T, nil)
            test.division(msb,  1 as T, F(D(quotient: msb,          remainder: 0)))
            test.division(msb,  2 as T, F(D(quotient: msb >> 1,     remainder: 0)))
            test.division(msb,  4 as T, F(D(quotient: msb >> 2,     remainder: 0)))
        }   else {
            test.division(bot, ~3 as T, F(D(quotient: T.zero,       remainder: bot)))
            test.division(bot, ~1 as T, F(D(quotient: T.zero,       remainder: bot)))
            test.division(bot, ~0 as T, F(D(quotient: T.zero,       remainder: bot)))
            test.division(bot,  0 as T, nil)
            test.division(bot,  1 as T, F(D(quotient: bot,          remainder: 0)))
            test.division(bot,  2 as T, F(D(quotient: bot >> 1,     remainder: 1)))
            
            test.division(msb, ~1 as T, F(D(quotient: T.zero,       remainder: msb)))
            test.division(msb, ~0 as T, F(D(quotient: T.zero,       remainder: msb)))
            test.division(msb,  0 as T, nil)
            test.division(msb,  1 as T, F(D(quotient: msb,          remainder: 0)))
            test.division(msb,  2 as T, F(D(quotient: msb >> 1,     remainder: 0)))
            test.division(msb,  4 as T, F(D(quotient: msb >> 2,     remainder: 0)))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func divisionOfSmallBySmall() where T: BinaryInteger {
        typealias D = Division<T, T>
        typealias F = Fallible<D>
        //=--------------------------------------=
        let x0 = 0 as T
        let x7 = 7 as T
        //=--------------------------------------=
        for divisor:  T in [4, 3, 2, 1, ~0, ~1, ~2, ~3, ~4] {
            test.division( x0, divisor, F(D(quotient: x0, remainder: x0)))
        }
        
        if  T.isSigned {
            test.division( x7,  3 as T, F(D(quotient:  2, remainder:  1)))
            test.division( x7, -3 as T, F(D(quotient: -2, remainder:  1)))
            test.division(-x7,  3 as T, F(D(quotient: -2, remainder: -1)))
            test.division(-x7, -3 as T, F(D(quotient:  2, remainder: -1)))
        }   else {
            test.division( x7,  1 as T, F(D(quotient:  7, remainder:  0)))
            test.division( x7,  2 as T, F(D(quotient:  3, remainder:  1)))
            test.division( x7,  3 as T, F(D(quotient:  2, remainder:  1)))
            test.division( x7,  4 as T, F(D(quotient:  1, remainder:  3)))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public func divisionByZero(_ id: SystemsIntegerID) where T: SystemsInteger {
        //=--------------------------------------=
        self.divisionByZero(BinaryIntegerID())
        //=--------------------------------------=
        let values: [T] = [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4]
        
        for high: T in values {
            for low: T.Magnitude in values.lazy.map(M.init(raw:)) {
                test.division(Doublet(low: low, high: high), T.zero, nil)
            }
        }
    }
    
    public func divisionByZero(_ id: BinaryIntegerID) where T: BinaryInteger {
        for value: T in [4, 3, 2, 1, 0, ~0, ~1, ~2, ~3, ~4] {
            test.division(value, T.zero, nil)
        }
        
        if  T.size > Count(128) || (T.size == Count(128) && !T.isSigned)  {
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

//*============================================================================*
// MARK: * Integer Invariants x Division x Unsigned
//*============================================================================*

extension IntegerInvariants where T: UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    public func divisionLongCodeCoverage(_ id: SystemsIntegerID) where T: SystemsInteger {
        typealias M = T.Magnitude
        typealias D = Division<T, T>
        typealias F = Fallible<D>
        //=----------------------------------=
        self.divisionLongCodeCoverage(BinaryIntegerID())
        //=----------------------------------=
        var dividend = Doublet<T>(low: M.zero, high: T.zero)
        var divisor: T, quotient: T, remainder: T
        //=----------------------------------=
        // dividend: [ 0,  0,  0,  0,  0, ~0, ~0, ~0]
        // divisor:  [~0, ~0, ~0, ~0,  0,  0,  0,  0]
        //=----------------------------------=
        dividend.high  = T.max << T(load: UX(size: T.self) >> 2)
        dividend.low   = M.min
        divisor        = T.max
        quotient       = dividend.high
        remainder      = dividend.high
        
        Test().division(dividend, divisor, F(D(quotient: quotient, remainder: remainder)))
        
        dividend.low   = M.max
        quotient      += 1
        
        Test().division(dividend, divisor, F(D(quotient: quotient, remainder: remainder)))
        
        dividend.low   = M.min
        dividend.high += 1
        remainder     += 1
        
        Test().division(dividend, divisor, F(D(quotient: quotient, remainder: remainder)))
    }
    
    public func divisionLongCodeCoverage(_ id: BinaryIntegerID) where T: BinaryInteger {
        typealias M = T.Magnitude
        typealias D = Division<T, T>
        typealias F = Fallible<D>
        //=----------------------------------=
        let size = (Self.shlEsque + 1)
        let max  = (T(repeating: 0001) << size).toggled()
        //=----------------------------------=
        var dividend: T, divisor: T, quotient: T, remainder: T
        //=----------------------------------=
        precondition(T.size >= U8.size, "this test splits integers into parts of 1/8")
        
        dividend   = (max      << ((size *  5) >> 3)) & max // [ 0,  0,  0,  0,  0, ~0, ~0, ~0]
        divisor    = (max      >> ((size >> 1))) //........... [~0, ~0, ~0, ~0,  0,  0,  0,  0]
        quotient   = (dividend >> ((size >> 1))) //........... [ 0, ~0, ~0, ~0,  0,  0,  0,  0]
        remainder  = (quotient)   //.......................... [ 0, ~0, ~0, ~0,  0,  0,  0,  0]
                
        test.division(dividend, divisor, quotient, remainder)
        
        dividend  += divisor
        quotient  += 1
        
        test.division(dividend, divisor, quotient, remainder)

        dividend  += 1
        remainder += 1
        
        if  T.size == U8.size {
            test.same(remainder, divisor)
            quotient  += 1
            remainder  = 0
        }
        
        test.division(dividend, divisor, quotient, remainder)
    }
}
