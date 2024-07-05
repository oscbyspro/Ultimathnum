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
    
    func testComparison() {
        func whereIs<T>(_ type: T.Type) where T: BinaryInteger {
            IntegerInvariants(T.self).comparisonOfGenericLowEntropy()
            IntegerInvariants(T.self).comparisonOfGenericMinMaxEsque()
            IntegerInvariants(T.self).comparisonOfGenericRepeatingBit()
        }
        
        for type in Self.types {
            whereIs(type)
        }
    }
    
    /// - Note: Generic tests may depend on these results.
    func testComparisonOfSize() {
        for size: Count<IX> in [IXL.size, UXL.size] {
            Test().comparison(size, U8 .size, 1 as Signum, id: ComparableID())
            Test().comparison(size, U16.size, 1 as Signum, id: ComparableID())
            Test().comparison(size, U32.size, 1 as Signum, id: ComparableID())
            Test().comparison(size, U64.size, 1 as Signum, id: ComparableID())
        }
        
        func whereIsArbitrary<A, B>(_ lhs: A.Type, _ rhs: B.Type) where A: BinaryInteger, B: BinaryInteger {
            Test().yay(A.size.isInfinite)
            Test().yay(B.size.isInfinite)
            Test().comparison(A.size, B.size, Signum.same, id: ComparableID())
        }
        
        for lhs in Self.types {
            for rhs in Self.types {
                whereIsArbitrary(lhs, rhs)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testComparisonVersusToken() {
        func whereIs<S, M>(_ signed: S.Type, _ unsigned: M.Type) where S: SignedInteger, M: UnsignedInteger {
            Test().comparison(S(load: IX.min), IX(load: IX.min),  0 as Signum)
            Test().comparison(S(load: IX.min), UX(load: IX.min), -1 as Signum)
            Test().comparison(M(load: IX.min), IX(load: IX.min),  1 as Signum)
            Test().comparison(M(load: IX.min), UX(load: IX.min),  1 as Signum)
            
            Test().comparison(S(load: IX.min),  S(load: IX.min),  0 as Signum)
            Test().comparison(S(load: IX.min),  M(load: IX.min), -1 as Signum)
            Test().comparison(M(load: IX.min),  S(load: IX.min),  1 as Signum)
            Test().comparison(M(load: IX.min),  M(load: IX.min),  0 as Signum)
            
            Test().comparison(S(load: IX.max), IX(load: IX.max),  0 as Signum)
            Test().comparison(S(load: IX.max), UX(load: IX.max),  0 as Signum)
            Test().comparison(M(load: IX.max), IX(load: IX.max),  0 as Signum)
            Test().comparison(M(load: IX.max), UX(load: IX.max),  0 as Signum)
            
            Test().comparison(S(load: IX.max),  S(load: IX.max),  0 as Signum)
            Test().comparison(S(load: IX.max),  M(load: IX.max),  0 as Signum)
            Test().comparison(M(load: IX.max),  S(load: IX.max),  0 as Signum)
            Test().comparison(M(load: IX.max),  M(load: IX.max),  0 as Signum)
            
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
        func whereTheElementIs<SE, ME>(_ signed: SE.Type, _ unsigned: ME.Type) where
        SE: SystemsInteger & SignedInteger, ME: SystemsInteger & UnsignedInteger {
            
            typealias S = InfiniInt<SE>
            typealias M = InfiniInt<ME>
                        
            for x: UX in [~2, ~1,  1, 2] {
                for y: UX in [~2, ~1, 1, 2] {
                    for z: Bit in [0, 1] {
                        Test().comparison(S([x, x] as [UX], repeating: z), S([          ] as [UX], repeating: ~z),  Signum.one(Sign(z == 1)))
                        Test().comparison(S([x, x] as [UX], repeating: z), S([y         ] as [UX], repeating: ~z),  Signum.one(Sign(z == 1)))
                        Test().comparison(S([x, x] as [UX], repeating: z), S([y, y      ] as [UX], repeating: ~z),  Signum.one(Sign(z == 1)))
                        Test().comparison(S([x, x] as [UX], repeating: z), S([y, y, y   ] as [UX], repeating: ~z),  Signum.one(Sign(z == 1)))
                        Test().comparison(S([x, x] as [UX], repeating: z), S([y, y, y, y] as [UX], repeating: ~z),  Signum.one(Sign(z == 1)))
                        
                        Test().comparison(S([x, x] as [UX], repeating: z), M([          ] as [UX], repeating: ~z), -1 as Signum)
                        Test().comparison(S([x, x] as [UX], repeating: z), M([y         ] as [UX], repeating: ~z), -1 as Signum)
                        Test().comparison(S([x, x] as [UX], repeating: z), M([y, y      ] as [UX], repeating: ~z), -1 as Signum)
                        Test().comparison(S([x, x] as [UX], repeating: z), M([y, y, y   ] as [UX], repeating: ~z), -1 as Signum)
                        Test().comparison(S([x, x] as [UX], repeating: z), M([y, y, y, y] as [UX], repeating: ~z), -1 as Signum)
                        
                        Test().comparison(M([x, x] as [UX], repeating: z), S([          ] as [UX], repeating: ~z),  1 as Signum)
                        Test().comparison(M([x, x] as [UX], repeating: z), S([y         ] as [UX], repeating: ~z),  1 as Signum)
                        Test().comparison(M([x, x] as [UX], repeating: z), S([y, y      ] as [UX], repeating: ~z),  1 as Signum)
                        Test().comparison(M([x, x] as [UX], repeating: z), S([y, y, y   ] as [UX], repeating: ~z),  1 as Signum)
                        Test().comparison(M([x, x] as [UX], repeating: z), S([y, y, y, y] as [UX], repeating: ~z),  1 as Signum)
                        
                        Test().comparison(M([x, x] as [UX], repeating: z), M([          ] as [UX], repeating: ~z),  Signum.one(Sign(z == 0)))
                        Test().comparison(M([x, x] as [UX], repeating: z), M([y         ] as [UX], repeating: ~z),  Signum.one(Sign(z == 0)))
                        Test().comparison(M([x, x] as [UX], repeating: z), M([y, y      ] as [UX], repeating: ~z),  Signum.one(Sign(z == 0)))
                        Test().comparison(M([x, x] as [UX], repeating: z), M([y, y, y   ] as [UX], repeating: ~z),  Signum.one(Sign(z == 0)))
                        Test().comparison(M([x, x] as [UX], repeating: z), M([y, y, y, y] as [UX], repeating: ~z),  Signum.one(Sign(z == 0)))
                    }
                }
            }
        }
        
        for signed in Self.elementsWhereIsSigned {
            for unsigned in Self.elementsWhereIsUnsigned {
                whereTheElementIs(signed, unsigned)
            }
        }
    }
    
    func testComparisonVersusAnySameSignednessSameAppendixButDifferentSize() {
        func whereTheElementIs<AE, BE>(_ first: AE.Type, _ second: BE.Type) where AE: SystemsInteger, BE: SystemsInteger {
            precondition(AE.isSigned == BE.isSigned)
            
            typealias T = InfiniInt<AE>
            typealias U = InfiniInt<AE>
            
            for x: UX in [~2, ~1,  1, 2] {
                for y: UX in [~2, ~1, 1, 2] {
                    for z: Bit in [0, 1] {
                        Test().comparison(T([x, x] as [UX], repeating: z), U([          ] as [UX], repeating: z), Signum.one(Sign( z == 1)))
                        Test().comparison(T([x, x] as [UX], repeating: z), U([y         ] as [UX], repeating: z), Signum.one(Sign( z == 1)))
                        Test().comparison(T([x, x] as [UX], repeating: z), U([y, y      ] as [UX], repeating: z), x == y ? 0 : x < y ? -1 : 1)
                        Test().comparison(T([x, x] as [UX], repeating: z), U([y, y, y   ] as [UX], repeating: z), Signum.one(Sign( z == 0)))
                        Test().comparison(T([x, x] as [UX], repeating: z), U([y, y, y, y] as [UX], repeating: z), Signum.one(Sign( z == 0)))
                    }
                }
            }
        }
        
        for first in Self.elements {
            for second in Self.elements {
                if  first.isSigned == second.isSigned {
                    whereTheElementIs(first, second)
                }
            }
        }
    }
    
    func testComparisonVersusAnySameSignednessSameAppendixSameSizeButDifferentBody() {
        func whereTheElementIs<AE, BE>(_ first: AE.Type, _ second: BE.Type) where AE: SystemsInteger, BE: SystemsInteger {
            precondition(AE.isSigned == BE.isSigned)
            
            typealias T = InfiniInt<AE>
            typealias U = InfiniInt<AE>
            
            for z: Bit in [0, 1] {
                Test().comparison(T([1, 2] as [UX], repeating: z), U([0, 1] as [UX], repeating: z),  1 as Signum)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([1, 1] as [UX], repeating: z),  1 as Signum)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([2, 1] as [UX], repeating: z),  1 as Signum)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([0, 2] as [UX], repeating: z),  1 as Signum)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([1, 2] as [UX], repeating: z),  0 as Signum)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([2, 2] as [UX], repeating: z), -1 as Signum)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([0, 3] as [UX], repeating: z), -1 as Signum)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([1, 3] as [UX], repeating: z), -1 as Signum)
                Test().comparison(T([1, 2] as [UX], repeating: z), U([2, 3] as [UX], repeating: z), -1 as Signum)
            }
        }
        
        for first in Self.elements {
            for second in Self.elements {
                if  first.isSigned == second.isSigned {
                    whereTheElementIs(first, second)
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
        Test().comparison(IXL(-1), UXL(~0), -1 as Signum) // OK
        Test().comparison(IXL(-1), UXL(~1), -1 as Signum) // :(
        Test().comparison(IXL(-1), UXL(~2), -1 as Signum) // :(
        Test().comparison(IXL(-1), UXL(~3), -1 as Signum) // :(
        
        Test().comparison(IXL(-2), UXL(~0), -1 as Signum) // OK
        Test().comparison(IXL(-2), UXL(~1), -1 as Signum) // OK
        Test().comparison(IXL(-2), UXL(~2), -1 as Signum) // :(
        Test().comparison(IXL(-2), UXL(~3), -1 as Signum) // :(
    }
}
