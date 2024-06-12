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
// MARK: * Data Int x Comparison
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSignum() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Extension<T>
            typealias F = Fallible<[T]>
            
            for appendix: Bit in [0, 1] {
                for isSigned: Bool in [false, true] {
                    let expectation = (appendix == 0) ? Signum.same : Signum.one(Sign(isSigned))
                    C([       ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([0      ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([0, 0   ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([0, 0, 0] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                }
                
                for isSigned: Bool in [false, true] {
                    let expectation = (appendix == 0) ? Signum.more : Signum.one(Sign(isSigned))
                    C([1      ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([1, 2   ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([1, 2, 3] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([1      ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([0, 2   ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([0, 0, 3] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([1      ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([2, 0   ] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                    C([3, 0, 0] as [T], repeating: appendix).signum(is: expectation, isSigned: isSigned)
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
    
    func testComparisonIgnoresBodyAppendixExtensions() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            func result(
                _ lhs: [T], _ lhsAppendix: Bit, _ lhsIsSigned: Bool,
                _ rhs: [T], _ rhsAppendix: Bit, _ rhsIsSigned: Bool
            )   -> Signum {
                
                lhs.withUnsafeBufferPointer { lhs in
                    rhs.withUnsafeBufferPointer { rhs in
                        DataInt.compare(
                            lhs: DataInt(lhs, repeating: lhsAppendix)!, lhsIsSigned: lhsIsSigned,
                            rhs: DataInt(rhs, repeating: rhsAppendix)!, rhsIsSigned: rhsIsSigned
                        )
                    }
                }
            }
            
            for base: [T] in (T.zero ..< 4).lazy.map({ Array(0 ..< $0) }) {
                for bit: Bit in [0, 1] {
                    
                    var lhs = base
                    for _ in 0 ..< 4 {
                        
                        var rhs = base
                        for _ in 0 ..< 4 {
                            Test().same(result(lhs, bit, false, rhs,  bit, false), !Bool(bit) ?  0 :  0) // ℕ vs ℕ | ∞ vs ∞
                            Test().same(result(lhs, bit, false, rhs,  bit, true ), !Bool(bit) ?  0 :  1) // ℕ vs ℕ | ∞ vs -
                            Test().same(result(lhs, bit, true,  rhs,  bit, false), !Bool(bit) ?  0 : -1) // ℕ vs ℕ | - vs ∞
                            Test().same(result(lhs, bit, true,  rhs,  bit, true ), !Bool(bit) ?  0 :  0) // ℕ vs ℕ | - vs -
                            
                            Test().same(result(lhs, bit, false, rhs, ~bit, false), !Bool(bit) ? -1 :  1) // ℕ vs ∞ | ∞ vs ℕ
                            Test().same(result(lhs, bit, false, rhs, ~bit, true ), !Bool(bit) ?  1 :  1) // ℕ vs - | ∞ vs ℕ
                            Test().same(result(lhs, bit, true,  rhs, ~bit, false), !Bool(bit) ? -1 : -1) // ℕ vs ∞ | - vs ℕ
                            Test().same(result(lhs, bit, true,  rhs, ~bit, true ), !Bool(bit) ?  1 : -1) // ℕ vs - | - vs ℕ
                            
                            rhs.append(T(repeating: bit))
                        };  lhs.append(T(repeating: bit))
                    }
                }
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions x Body
//=----------------------------------------------------------------------------=

extension DataIntTests.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func signum(is  expectation: Signum) {
        self.expect(expectation) {
            $0.signum()
        }   write: {
            $0.signum()
        }
        
        self.expect(expectation == Signum.same) {
            $0.isZero
        }   write: {
            $0.isZero
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions x Extension
//=----------------------------------------------------------------------------=

extension DataIntTests.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func signum(is  expectation: Signum, isSigned: Bool) {
        self.expect(expectation) {
            DataInt.signum(of: $0, isSigned: isSigned)
        }   write: {
            DataInt.signum(of: DataInt($0), isSigned: isSigned)
        }
        
        self.expect(expectation == Signum.same) {
            $0.isZero
        }   write: {
            $0.isZero
        }
        
        if !isSigned, item.appendix == 0 {
            let other = DataIntTests.Body(item.body, test: test)
            other.signum(is: expectation)
        }
    }
}
