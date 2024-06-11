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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBody() {
        func whereTheElementTypeIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Case = Extension<T>
            typealias Item = Extension<T>.Item
            
            Case([       ], repeating: nil).body(is:[       ] as [T])
            Case([1      ], repeating: nil).body(is:[1      ] as [T])
            Case([1, 2   ], repeating: nil).body(is:[1, 2   ] as [T])
            Case([1, 2, 3], repeating: nil).body(is:[1, 2, 3] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheElementTypeIs(type)
        }
    }
    
    func testNormalization() {
        func whereTheElementTypeIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Case = Extension<T>
            typealias Item = Extension<T>.Item
            
            for bit: Bit in [0, 1] {
                let a = T(repeating: bit), b = T(repeating: bit.toggled())
                
                Case([a, a, a], repeating: bit).normalized(is:[       ] as [T])
                Case([1, a, a], repeating: bit).normalized(is:[1      ] as [T])
                Case([1, 2, a], repeating: bit).normalized(is:[1, 2   ] as [T])
                Case([1, 2, 3], repeating: bit).normalized(is:[1, 2, 3] as [T])
                
                Case([b, b, b], repeating: bit).normalized(is:[b, b, b] as [T])
                Case([1, b, b], repeating: bit).normalized(is:[1, b, b] as [T])
                Case([1, 2, b], repeating: bit).normalized(is:[1, 2, b] as [T])
                Case([1, 2, 3], repeating: bit).normalized(is:[1, 2, 3] as [T])
            }
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheElementTypeIs(type)
        }
    }
    
    func testPrefix() {
        func whereTheElementTypeIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Case = Extension<T>
            typealias Item = Extension<T>.Item
            
            Case([1, 2, 3], repeating: nil).prefix(0, is:[             ] as [T])
            Case([1, 2, 3], repeating: nil).prefix(1, is:[1            ] as [T])
            Case([1, 2, 3], repeating: nil).prefix(2, is:[1, 2         ] as [T])
            Case([1, 2, 3], repeating: nil).prefix(3, is:[1, 2, 3      ] as [T])
            Case([1, 2, 3], repeating:   0).prefix(4, is:[1, 2, 3, .min] as [T])
            Case([1, 2, 3], repeating:   1).prefix(4, is:[1, 2, 3, .max] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheElementTypeIs(type)
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
    
    func normalized(is expectation: [Element]) {
        self.expect(expectation, read: {
            let elements = Array($0.normalized().buffer())
            test.same($0.isNormal, $0.count == IX(elements.count))
            return elements
        },  write: {
            let elements = Array($0.normalized().buffer())
            test.same($0.isNormal, $0.count == IX(elements.count))
            return elements
        })
        
        always: do {
            Self(expectation, test: test).expect(true, read: \.isNormal, write: \.isNormal)
        }
    }
    
    func split(clamping index: IX, low: [Element], high: [Element]) {
        self.split(unchecked: Swift.min(Swift.max(IX.zero, index), IX(self.body.count)), low: low, high: high)
    }

    func split(unchecked index: IX, low: [Element], high: [Element]) {
        self.expect(low, read:{
            Array($0.split(unchecked: index).low .buffer())
        },  write: {
            Array($0.split(unchecked: index).low .buffer())
        })
        
        self.expect(high, read:{
            Array($0.split(unchecked: index).high.buffer())
        },  write: {
            Array($0.split(unchecked: index).high.buffer())
        })
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions x Extension
//=----------------------------------------------------------------------------=

extension DataIntTests.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func body(is expectation: [Element]) {
        self.expect(expectation, read: {
            let elements = [Element]($0.body.buffer())
            test.same($0.body.count, IX(elements.count), "count [0]")
            return elements
        },  write: {
            let elements = [Element]($0.body.buffer())
            test.same($0.body.count, IX(elements.count), "count [1]")
            return elements
        })
    }
    
    func normalized(is expectation: [Element]) {
        self.expect(expectation, read: {
            let elements = [Element]($0.normalized().body.buffer())
            test.same($0.isNormal, $0.body.count == IX(elements.count), "isNormal [0]")
            return elements
        },  write: {
            let elements = [Element]($0.normalized().body.buffer())
            test.same($0.isNormal, $0.body.count == IX(elements.count), "isNormal [1]")
            return elements
        })
        
        always: do {
            Self(Item(expectation, item.appendix), test: test).expect(true, read: \.isNormal, write: \.isNormal)
        }
        
        if  item.appendix == 0 {
            DataIntTests.Body(item.body, test: test).normalized(is: expectation)
        }
    }
    
    func prefix(_ count: UX, is expectation: [Element]) {
        self.expect(expectation, read: {
            var elements = [Element]()
            for _ in 0 ..< count {
                elements.append($0.next())
            }
            return elements as [Element]
            
        },  write: {
            var elements = [Element]()
            for _ in 0 ..< count {
                elements.append($0.next())
            }
            return elements as [Element]
        })
    }
}
