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
}

//*============================================================================*
// MARK: * Data Int x Addition x Assertions
//*============================================================================*

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
