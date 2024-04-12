//=----------------------------------------------------------------------------=
// This source file is part of the Iltimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import TestKit

//*============================================================================*
// MARK: * Exchange Int x Appendix
//*============================================================================*

extension ExchangeIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubscriptAppendixExtension() {
        typealias X = SystemsInteger & UnsignedInteger
        
        func whereIs<A: X, B: X>(_ source: A.Type, _ destination: B.Type) {
            Array([0 as A]).withUnsafeBufferPointer {
                $0.withMemoryRebound(to: U8.self) {
                    Test().same(T($0, repeating: 0, as: B.self)![123456],  0 as B)
                    Test().same(T($0, repeating: 1, as: B.self)![123456], ~0 as B)
                    Test().same(T($0, repeating: 0, as: B.self)![UX.max],  0 as B)
                    Test().same(T($0, repeating: 1, as: B.self)![UX.max], ~0 as B)
                }
            }
        }
        
        for a in coreSystemsIntegersWhereIsUnsigned {
            for b in coreSystemsIntegersWhereIsUnsigned {
                whereIs(a, b)
            }
        }
    }
    
    func testMajorSequenceFromIncompleteMinorSequence() {
        checkOneWayOnly(Test(), [                          ] as [U32], [                       ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [ 1                        ] as [U32], [ 1                     ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [ 1,  0,  2                ] as [U32], [ 1,  2                 ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [ 1,  0,  2,  0,  3        ] as [U32], [ 1,  2,  3             ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [ 1,  0,  2,  0,  3,  0,  4] as [U32], [ 1,  2,  3,  4         ] as [U64], repeating: 0 as Bit)
        
        checkOneWayOnly(Test(), [                          ] as [U32], [                       ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [ 1                        ] as [U32], [ 1                     ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [ 1,  0,  2                ] as [U32], [ 1,  2                 ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [ 1,  0,  2,  0,  3        ] as [U32], [ 1,  2,  3             ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [ 1,  0,  2,  0,  3,  0,  4] as [U32], [ 1,  2,  3,  4         ] as [U64], repeating: 0 as Bit)
        
        checkOneWayOnly(Test(), [                          ] as [U32], [                       ] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [~1                        ] as [U32], [             0xfffffffe] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [~1, ~0, ~2                ] as [U32], [~1,          0xfffffffd] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [~1, ~0, ~2, ~0, ~3        ] as [U32], [~1, ~2,      0xfffffffc] as [U64], repeating: 0 as Bit)
        checkOneWayOnly(Test(), [~1, ~0, ~2, ~0, ~3, ~0, ~4] as [U32], [~1, ~2, ~3,  0xfffffffb] as [U64], repeating: 0 as Bit)
        
        checkOneWayOnly(Test(), [                          ] as [U32], [                       ] as [U64], repeating: 1 as Bit)
        checkOneWayOnly(Test(), [~1                        ] as [U32], [~1                     ] as [U64], repeating: 1 as Bit)
        checkOneWayOnly(Test(), [~1, ~0, ~2                ] as [U32], [~1, ~2                 ] as [U64], repeating: 1 as Bit)
        checkOneWayOnly(Test(), [~1, ~0, ~2, ~0, ~3        ] as [U32], [~1, ~2, ~3             ] as [U64], repeating: 1 as Bit)
        checkOneWayOnly(Test(), [~1, ~0, ~2, ~0, ~3, ~0, ~4] as [U32], [~1, ~2, ~3, ~4         ] as [U64], repeating: 1 as Bit)
    }
}
