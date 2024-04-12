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
// MARK: * Exchange Int x Perfect Inputs
//*============================================================================*

extension ExchangeIntTests {
            
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSizeIsSame() {
        typealias X = SystemsInteger & UnsignedInteger
        
        func whereIs<A: X, B: X>(_ source: A.Type, _ destination: B.Type) {
            guard UX(size: source) == UX(size: destination) else { return }
            
            for bit in [Bit.zero, Bit.one] {
                check(Test(), [              ] as [A], [              ] as [B], repeating: bit)
                check(Test(), [ 1            ] as [A], [ 1            ] as [B], repeating: bit)
                check(Test(), [ 1,  2        ] as [A], [ 1,  2        ] as [B], repeating: bit)
                check(Test(), [ 1,  2,  3    ] as [A], [ 1,  2,  3    ] as [B], repeating: bit)
                check(Test(), [ 1,  2,  3,  4] as [A], [ 1,  2,  3,  4] as [B], repeating: bit)
                
                check(Test(), [              ] as [A], [              ] as [B], repeating: bit)
                check(Test(), [~1            ] as [A], [~1            ] as [B], repeating: bit)
                check(Test(), [~1, ~2        ] as [A], [~1, ~2        ] as [B], repeating: bit)
                check(Test(), [~1, ~2, ~3    ] as [A], [~1, ~2, ~3    ] as [B], repeating: bit)
                check(Test(), [~1, ~2, ~3, ~4] as [A], [~1, ~2, ~3, ~4] as [B], repeating: bit)
            }
        }
        
        for source in coreSystemsIntegersWhereIsUnsigned {
            for destination in coreSystemsIntegersWhereIsUnsigned {
                whereIs(source, destination)
            }
        }
    }
    
    func testSizeIsLess() {
        typealias X = SystemsInteger & UnsignedInteger
        
        func whereIs<A: X, B: X>(_ source: A.Type, _ destination: B.Type) {
            guard UX(size: source) == 2 * UX(size: destination) else { return }
            
            for bit in [Bit.zero, Bit.one] {
                check(Test(), [              ] as [A], [                              ] as [B], repeating: bit)
                check(Test(), [ 1            ] as [A], [ 1,  0                        ] as [B], repeating: bit)
                check(Test(), [ 1,  2        ] as [A], [ 1,  0,  2,  0                ] as [B], repeating: bit)
                check(Test(), [ 1,  2,  3    ] as [A], [ 1,  0,  2,  0,  3,  0        ] as [B], repeating: bit)
                check(Test(), [ 1,  2,  3,  4] as [A], [ 1,  0,  2,  0,  3,  0,  4,  0] as [B], repeating: bit)
                
                check(Test(), [              ] as [A], [                              ] as [B], repeating: bit)
                check(Test(), [~1            ] as [A], [~1, ~0                        ] as [B], repeating: bit)
                check(Test(), [~1, ~2        ] as [A], [~1, ~0, ~2, ~0                ] as [B], repeating: bit)
                check(Test(), [~1, ~2, ~3    ] as [A], [~1, ~0, ~2, ~0, ~3, ~0        ] as [B], repeating: bit)
                check(Test(), [~1, ~2, ~3, ~4] as [A], [~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as [B], repeating: bit)
            }
        }
        
        for source in coreSystemsIntegersWhereIsUnsigned {
            for destination in coreSystemsIntegersWhereIsUnsigned {
                whereIs(source, destination)
            }
        }
    }
    
    func testSizeIsMore() {
        typealias X = SystemsInteger & UnsignedInteger
        
        func whereIs<A: X, B: X>(_ source: A.Type, _ destination: B.Type) {
            guard 2 * UX(size: source) == UX(size: destination) else { return }
            
            for bit in [Bit.zero, Bit.one] {
                check(Test(), [                              ] as [A], [              ] as [B], repeating: bit)
                check(Test(), [ 1,  0                        ] as [A], [ 1            ] as [B], repeating: bit)
                check(Test(), [ 1,  0,  2,  0                ] as [A], [ 1,  2        ] as [B], repeating: bit)
                check(Test(), [ 1,  0,  2,  0,  3,  0        ] as [A], [ 1,  2,  3    ] as [B], repeating: bit)
                check(Test(), [ 1,  0,  2,  0,  3,  0,  4,  0] as [A], [ 1,  2,  3,  4] as [B], repeating: bit)
                
                check(Test(), [                              ] as [A], [              ] as [B], repeating: bit)
                check(Test(), [~1, ~0                        ] as [A], [~1            ] as [B], repeating: bit)
                check(Test(), [~1, ~0, ~2, ~0                ] as [A], [~1, ~2        ] as [B], repeating: bit)
                check(Test(), [~1, ~0, ~2, ~0, ~3, ~0        ] as [A], [~1, ~2, ~3    ] as [B], repeating: bit)
                check(Test(), [~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as [A], [~1, ~2, ~3, ~4] as [B], repeating: bit)
            }
        }
        
        for source in coreSystemsIntegersWhereIsUnsigned {
            for destination in coreSystemsIntegersWhereIsUnsigned {
                whereIs(source, destination)
            }
        }
    }
}
