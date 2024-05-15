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
// MARK: * Data Int x Partition
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSplitAt() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias C = DataIntTests.Body<T>
            typealias F = Fallible<[T]>
            
            C([       ]).split(clamping: 0, low:[       ], high:[       ])
            C([       ]).split(clamping: 1, low:[       ], high:[       ])
            C([       ]).split(clamping: 2, low:[       ], high:[       ])
            C([       ]).split(clamping: 3, low:[       ], high:[       ])
            
            C([1      ]).split(clamping: 0, low:[       ], high:[1      ])
            C([1      ]).split(clamping: 1, low:[1      ], high:[       ])
            C([1      ]).split(clamping: 2, low:[1      ], high:[       ])
            C([1      ]).split(clamping: 3, low:[1      ], high:[       ])
            
            C([1, 2   ]).split(clamping: 0, low:[       ], high:[1, 2   ])
            C([1, 2   ]).split(clamping: 1, low:[1      ], high:[   2   ])
            C([1, 2   ]).split(clamping: 2, low:[1, 2   ], high:[       ])
            C([1, 2   ]).split(clamping: 3, low:[1, 2   ], high:[       ])
            
            C([1, 2, 3]).split(clamping: 0, low:[       ], high:[1, 2, 3])
            C([1, 2, 3]).split(clamping: 1, low:[1      ], high:[   2, 3])
            C([1, 2, 3]).split(clamping: 2, low:[1, 2   ], high:[      3])
            C([1, 2, 3]).split(clamping: 3, low:[1, 2, 3], high:[       ])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereIs(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension DataIntTests.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func split(clamping index: IX, low: [Element], high: [Element]) {
        self.split(at: Swift.min(Swift.max(IX.zero, index), IX(self.body.count)), low: low, high: high)
    }

    func split(at index: IX, low: [Element], high: [Element]) {
        self.expect(low, read:{
            Array($0.split(at: index).low .buffer())
        },  write: {
            Array($0.split(at: index).low .buffer())
        })
        
        self.expect(high, read:{
            Array($0.split(at: index).high.buffer())
        },  write: {
            Array($0.split(at: index).high.buffer())
        })
    }
}
