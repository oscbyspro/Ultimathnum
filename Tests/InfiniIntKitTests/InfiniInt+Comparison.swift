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
// MARK: * Infini Int x Comparison
//*============================================================================*

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparisonVersusToken() {
        func whereIs<S, M>(_ signed: S.Type, _ unsigned: M.Type) where S: ArbitraryInteger & SignedInteger, M: ArbitraryInteger & UnsignedInteger {
            Test().comparison(S(load: IX.min), IX(load: IX.min), Signum.zero)
            Test().comparison(S(load: IX.min), UX(load: IX.min), Signum.negative)
            Test().comparison(M(load: IX.min), IX(load: IX.min), Signum.positive)
            Test().comparison(M(load: IX.min), UX(load: IX.min), Signum.positive)
            
            Test().comparison(S(load: IX.min),  S(load: IX.min), Signum.zero)
            Test().comparison(S(load: IX.min),  M(load: IX.min), Signum.negative)
            Test().comparison(M(load: IX.min),  S(load: IX.min), Signum.positive)
            Test().comparison(M(load: IX.min),  M(load: IX.min), Signum.zero)
            
            Test().comparison(S(load: IX.max), IX(load: IX.max), Signum.zero)
            Test().comparison(S(load: IX.max), UX(load: IX.max), Signum.zero)
            Test().comparison(M(load: IX.max), IX(load: IX.max), Signum.zero)
            Test().comparison(M(load: IX.max), UX(load: IX.max), Signum.zero)
            
            Test().comparison(S(load: IX.max),  S(load: IX.max), Signum.zero)
            Test().comparison(S(load: IX.max),  M(load: IX.max), Signum.zero)
            Test().comparison(M(load: IX.max),  S(load: IX.max), Signum.zero)
            Test().comparison(M(load: IX.max),  M(load: IX.max), Signum.zero)
            
            let ixs: [IX] = [~2, ~1, ~0, 0, 1, 2]
            for lhs: (IX) in ixs {
                for rhs: (IX) in ixs {
                    Test().comparison(S(load: lhs),         rhs,  IX(load: lhs).compared(to: IX(load: rhs)))
                    Test().comparison(S(load: lhs), S(load: rhs), IX(load: lhs).compared(to: IX(load: rhs)))
                    Test().comparison(S(load: lhs), M(load: rhs), IX(load: lhs).compared(to: UX(load: rhs)))
                    Test().comparison(M(load: lhs),         rhs,  UX(load: lhs).compared(to: IX(load: rhs)))
                    Test().comparison(M(load: lhs), S(load: rhs), UX(load: lhs).compared(to: IX(load: rhs)))
                    Test().comparison(M(load: lhs), M(load: rhs), UX(load: lhs).compared(to: UX(load: rhs)))
                }
            }
            
            let uxs: [UX] = [~2, ~1, ~0, 0, 1, 2]
            for lhs: (UX) in uxs {
                for rhs: (UX) in uxs {
                    let expectation: Signum = lhs.compared(to: rhs)
                    Test().comparison(S(load: lhs),         rhs,  expectation)
                    Test().comparison(S(load: lhs), S(load: rhs), expectation)
                    Test().comparison(S(load: lhs), M(load: rhs), expectation)
                    Test().comparison(M(load: lhs),         rhs,  expectation)
                    Test().comparison(M(load: lhs), S(load: rhs), expectation)
                    Test().comparison(M(load: lhs), M(load: rhs), expectation)
                }
            }
        }
        
        for signed in Self.typesWhereIsSigned {
            for unsigned in Self.typesWhereIsUnsigned {
                whereIs(signed, unsigned)
            }
        }
    }
    
    func testComparisonVersusAnyButDifferentAppendix() {
        func whereIs<S, M>(_ signed: S.Type, _ unsigned: M.Type) where
        S: ArbitraryInteger & SignedInteger, M: ArbitraryInteger & UnsignedInteger {
            for x: UX in [~2, ~1,  1, 2] as [UX] {
                for y: UX in [~2, ~1, 1, 2] as [UX] {
                    for z: Bit in [Bit.zero, Bit.one] {
                        Test().comparison(S([x, x] as [UX], repeating: z), S([          ] as [UX], repeating: ~z),  Signum(Sign(raw: z)))
                        Test().comparison(S([x, x] as [UX], repeating: z), S([y         ] as [UX], repeating: ~z),  Signum(Sign(raw: z)))
                        Test().comparison(S([x, x] as [UX], repeating: z), S([y, y      ] as [UX], repeating: ~z),  Signum(Sign(raw: z)))
                        Test().comparison(S([x, x] as [UX], repeating: z), S([y, y, y   ] as [UX], repeating: ~z),  Signum(Sign(raw: z)))
                        Test().comparison(S([x, x] as [UX], repeating: z), S([y, y, y, y] as [UX], repeating: ~z),  Signum(Sign(raw: z)))
                        
                        Test().comparison(S([x, x] as [UX], repeating: z), M([          ] as [UX], repeating: ~z),  Signum.negative)
                        Test().comparison(S([x, x] as [UX], repeating: z), M([y         ] as [UX], repeating: ~z),  Signum.negative)
                        Test().comparison(S([x, x] as [UX], repeating: z), M([y, y      ] as [UX], repeating: ~z),  Signum.negative)
                        Test().comparison(S([x, x] as [UX], repeating: z), M([y, y, y   ] as [UX], repeating: ~z),  Signum.negative)
                        Test().comparison(S([x, x] as [UX], repeating: z), M([y, y, y, y] as [UX], repeating: ~z),  Signum.negative)
                        
                        Test().comparison(M([x, x] as [UX], repeating: z), S([          ] as [UX], repeating: ~z),  Signum.positive)
                        Test().comparison(M([x, x] as [UX], repeating: z), S([y         ] as [UX], repeating: ~z),  Signum.positive)
                        Test().comparison(M([x, x] as [UX], repeating: z), S([y, y      ] as [UX], repeating: ~z),  Signum.positive)
                        Test().comparison(M([x, x] as [UX], repeating: z), S([y, y, y   ] as [UX], repeating: ~z),  Signum.positive)
                        Test().comparison(M([x, x] as [UX], repeating: z), S([y, y, y, y] as [UX], repeating: ~z),  Signum.positive)
                        
                        Test().comparison(M([x, x] as [UX], repeating: z), M([          ] as [UX], repeating: ~z), -Signum(Sign(raw: z)))
                        Test().comparison(M([x, x] as [UX], repeating: z), M([y         ] as [UX], repeating: ~z), -Signum(Sign(raw: z)))
                        Test().comparison(M([x, x] as [UX], repeating: z), M([y, y      ] as [UX], repeating: ~z), -Signum(Sign(raw: z)))
                        Test().comparison(M([x, x] as [UX], repeating: z), M([y, y, y   ] as [UX], repeating: ~z), -Signum(Sign(raw: z)))
                        Test().comparison(M([x, x] as [UX], repeating: z), M([y, y, y, y] as [UX], repeating: ~z), -Signum(Sign(raw: z)))
                    }
                }
            }
        }
        
        for signed in Self.typesWhereIsSigned {
            for unsigned in Self.typesWhereIsUnsigned {
                whereIs(signed, unsigned)
            }
        }
    }
    
    func testComparisonVersusAnySameSignednessSameAppendixButDifferentSize() {
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) where T: ArbitraryInteger, U: ArbitraryInteger {
            precondition(T.isSigned == U.isSigned)
            
            for x: UX in [~2, ~1,  1, 2] as [UX] {
                for y: UX in [~2, ~1, 1, 2] as [UX] {
                    for z: Bit in [Bit.zero, Bit.one] {
                        Test().comparison(T([x, x] as [UX], repeating: z), U([          ] as [UX], repeating: z),  Signum(Sign(raw: z)))
                        Test().comparison(T([x, x] as [UX], repeating: z), U([y         ] as [UX], repeating: z),  Signum(Sign(raw: z)))
                        Test().comparison(T([x, x] as [UX], repeating: z), U([y, y      ] as [UX], repeating: z),  x.compared (to:  y))
                        Test().comparison(T([x, x] as [UX], repeating: z), U([y, y, y   ] as [UX], repeating: z), -Signum(Sign(raw: z)))
                        Test().comparison(T([x, x] as [UX], repeating: z), U([y, y, y, y] as [UX], repeating: z), -Signum(Sign(raw: z)))
                    }
                }
            }
        }
        
        for first in Self.types {
            for second in Self.types {
                if  first.isSigned == second.isSigned {
                    whereIs(first, second)
                }
            }
        }
    }
    
    func testComparisonVersusAnySameSignednessSameAppendixSameSizeButDifferentBody() {
        func whereIs<T, U>(_ first: T.Type, _ second: U.Type) where T: ArbitraryInteger, U: ArbitraryInteger {
            precondition(T.isSigned == U.isSigned)
            
            for z: Bit in [Bit.zero, Bit.one] {
                Test().comparison(T([1, 2] as [UX], repeating: z), U([0, 1] as [UX], repeating: z), Signum.positive)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([1, 1] as [UX], repeating: z), Signum.positive)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([2, 1] as [UX], repeating: z), Signum.positive)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([0, 2] as [UX], repeating: z), Signum.positive)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([1, 2] as [UX], repeating: z), Signum.zero)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([2, 2] as [UX], repeating: z), Signum.negative)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([0, 3] as [UX], repeating: z), Signum.negative)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([1, 3] as [UX], repeating: z), Signum.negative)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([2, 3] as [UX], repeating: z), Signum.negative)
            }
        }
        
        for first in Self.types {
            for second in Self.types {
                if  first.isSigned == second.isSigned {
                    whereIs(first, second)
                }
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Edge Cases
//=----------------------------------------------------------------------------=

extension InfiniIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// 2024-06-10: Checks the negative versus infinite path.
    func testNegativeValuesAreSmallerThanInfiniteValues() {
        Test().comparison(IXL(-1), UXL(~0), Signum.negative) // OK
        Test().comparison(IXL(-1), UXL(~1), Signum.negative) // :(
        Test().comparison(IXL(-1), UXL(~2), Signum.negative) // :(
        Test().comparison(IXL(-1), UXL(~3), Signum.negative) // :(
        
        Test().comparison(IXL(-2), UXL(~0), Signum.negative) // OK
        Test().comparison(IXL(-2), UXL(~1), Signum.negative) // OK
        Test().comparison(IXL(-2), UXL(~2), Signum.negative) // :(
        Test().comparison(IXL(-2), UXL(~3), Signum.negative) // :(
    }
}
