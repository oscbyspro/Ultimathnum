//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit2

//*============================================================================*
// MARK: * Data Integer x Comparison
//*============================================================================*

@Suite struct DataIntegerTestsOnComparison {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/signum()", arguments: coreIntegersWhereIsUnsigned)
    func signum(_ type: any SystemsIntegerWhereIsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            for appendix in Bit.all {
                for mode in Signedness.all {
                    let expectation = Signum(appendix.isZero ? nil : Sign(raw: mode))
                    
                    Ɣexpect(DXL([       ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([0      ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([0, 0   ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([0, 0, 0] as [T], repeating: appendix, as: mode), signum: expectation)
                }
                
                for mode in Signedness.all {
                    let expectation = Signum(Sign(raw: !appendix.isZero && mode == .signed))
                    
                    Ɣexpect(DXL([1      ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([1, 2   ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([1, 2, 3] as [T], repeating: appendix, as: mode), signum: expectation)
                    
                    Ɣexpect(DXL([1      ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([0, 2   ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([0, 0, 3] as [T], repeating: appendix, as: mode), signum: expectation)
                    
                    Ɣexpect(DXL([1      ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([2, 0   ] as [T], repeating: appendix, as: mode), signum: expectation)
                    Ɣexpect(DXL([3, 0, 0] as [T], repeating: appendix, as: mode), signum: expectation)
                }
            }
        }
    }
    
    func Ɣexpect<T>(_ data: DXL<T>, signum expectation: Signum, at location: SourceLocation = #_sourceLocation) {
        data.perform { elements, mode in
            
            #expect(DataInt.signum(of: elements, mode: mode) == expectation, sourceLocation: location)
            
            if  expectation.isZero {
                #expect(elements     .isZero, sourceLocation: location)
                #expect(elements.body.isZero, sourceLocation: location)
            }
            
            if  elements.appendix == Bit.zero {
                #expect(elements.body.signum() == expectation, sourceLocation: location)
            }
            
        }   writing: { elements, mode in
            
            #expect(DataInt.signum(of: DataInt(elements), mode: mode) == expectation, sourceLocation: location)
            
            if  expectation.isZero {
                #expect(elements     .isZero, sourceLocation: location)
                #expect(elements.body.isZero, sourceLocation: location)
            }
            
            if  elements.appendix == Bit.zero {
                #expect(elements.body.signum() == expectation, sourceLocation: location)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/compared(to:) - ignores body appendix extensions", arguments: coreIntegersWhereIsUnsigned)
    func comparisonIgnoresBodyAppendixExtensions(_ type: any SystemsIntegerWhereIsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            for base: [T] in (T.zero ..< 4).lazy.map({ Array(0 ..< $0) }) {
                for bit in [Bit.zero, Bit.one] {
                    
                    var lhs = base
                    for _ in 0 ..< 4 {
                        
                        var rhs = base
                        for _ in 0 ..< 4 {
                            Ɣexpect(DXL(lhs, bit, .unsigned), vs: DXL(rhs,  bit, .unsigned), is:  Signum.zero) //...... ℕ vs ℕ | ∞ vs ∞
                            Ɣexpect(DXL(lhs, bit, .unsigned), vs: DXL(rhs,  bit,   .signed), is:  Signum(bit)) //...... ℕ vs ℕ | ∞ vs -
                            Ɣexpect(DXL(lhs, bit,   .signed), vs: DXL(rhs,  bit, .unsigned), is: -Signum(bit)) //...... ℕ vs ℕ | - vs ∞
                            Ɣexpect(DXL(lhs, bit,   .signed), vs: DXL(rhs,  bit,   .signed), is:  Signum.zero) //...... ℕ vs ℕ | - vs -
                            
                            Ɣexpect(DXL(lhs, bit, .unsigned), vs: DXL(rhs, ~bit, .unsigned), is: -Signum(Sign(bit))) // ℕ vs ∞ | ∞ vs ℕ
                            Ɣexpect(DXL(lhs, bit, .unsigned), vs: DXL(rhs, ~bit,   .signed), is:  Signum.positive)   // ℕ vs - | ∞ vs ℕ
                            Ɣexpect(DXL(lhs, bit,   .signed), vs: DXL(rhs, ~bit, .unsigned), is:  Signum.negative)   // ℕ vs ∞ | - vs ℕ
                            Ɣexpect(DXL(lhs, bit,   .signed), vs: DXL(rhs, ~bit,   .signed), is:  Signum(Sign(bit))) // ℕ vs - | - vs ℕ
                            
                            rhs.append(T(repeating: bit))
                        };  lhs.append(T(repeating: bit))
                    }
                }
            }
        }
    }
    
    func Ɣexpect<T>(_ lhs: DXL<T>, vs rhs: DXL<T>, is expectation: Signum, at location: SourceLocation = #_sourceLocation) {
        lhs.reading { lhsElements, lhsMode in
            rhs.reading { rhsElements, rhsMode in
                let result = DataInt.compare(lhs: lhsElements, mode: lhsMode, rhs: rhsElements, mode: rhsMode)
                #expect(result == expectation, sourceLocation: location)
            }
        }
    }
}
