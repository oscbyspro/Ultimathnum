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
// MARK: * Data Int x Elements
//*============================================================================*

extension DataIntTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testElement() {
        func whereTheElementTypeIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Case = Extension<T>
            typealias Item = Extension<T>.Item
            
            for bit: Bit in [0, 1] {
                for index: UX in [~2, ~1, ~0, 1, 2, 3] {
                    Case([], repeating: bit).element(at: index, is: T(repeating: bit))
                }
            }
            
            Case([1, 2, 3], repeating: nil).element(at: 000000, is:  0x01)
            Case([1, 2, 3], repeating: nil).element(at: 000001, is:  0x02)
            Case([1, 2, 3], repeating: nil).element(at: 000002, is:  0x03)
            Case([1, 2, 3], repeating:   0).element(at: 123456, is:  0x00)
            Case([1, 2, 3], repeating:   1).element(at: 123456, is: ~0x00)
            Case([1, 2, 3], repeating:   0).element(at: UX.max, is:  0x00)
            Case([1, 2, 3], repeating:   1).element(at: UX.max, is: ~0x00)
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheElementTypeIs(type)
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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPrefix() {
        func whereTheElementTypeIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            typealias Case = Extension<T>
            typealias Item = Extension<T>.Item
            
            Case([1, 2, 3], repeating: nil).prefix(0, is:[                      ] as [T])
            Case([1, 2, 3], repeating: nil).prefix(1, is:[0x01                  ] as [T])
            Case([1, 2, 3], repeating: nil).prefix(2, is:[0x01, 0x02            ] as [T])
            Case([1, 2, 3], repeating: nil).prefix(3, is:[0x01, 0x02, 0x03      ] as [T])
            Case([1, 2, 3], repeating:   0).prefix(4, is:[0x01, 0x02, 0x03, .min] as [T])
            Case([1, 2, 3], repeating:   1).prefix(4, is:[0x01, 0x02, 0x03, .max] as [T])
        }
        
        for type in coreSystemsIntegersWhereIsUnsigned {
            whereTheElementTypeIs(type)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Assertions
//=----------------------------------------------------------------------------=

extension DataIntTests.Extension {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    func element(at index: UX, is expectation: Element) {
        self.expect(expectation, read: {
            $0[index]
        },  write: {
            $0[index]
        })
        
        self.expect(expectation, read: {
            $0[index...][UX.zero]
        },  write: {
            $0[index...][UX.zero]
        })
        
        self.expect(expectation, read: {
            $0[index...].load()
        },  write: {
            $0[index...].load()
        })
        
        if let index = IX.exactly(index).optional(), index < IX(self.item.body.count) {
            DataIntTests.Body(self.item.body, test: self.test).expect(expectation, read: {
                $0[unchecked: index]
            },  write: {
                $0[unchecked: index]
            })
            
            DataIntTests.Body(self.item.body, test: self.test).expect(expectation, read: {
                $0[unchecked: index...][unchecked: ()]
            },  write: {
                $0[unchecked: index...][unchecked: ()]
            })
            
            DataIntTests.Body(self.item.body, test: self.test).expect(expectation, read: {
                $0[unchecked: index...].load()
            },  write: {
                $0[unchecked: index...].load()
            })
        }
        
        if  index == .zero, self.item.body.isEmpty {
            DataIntTests.Body(self.item.body, test: self.test).expect(00000000000, read: {
                $0.load()
            },  write: {
                $0.load()
            })
        }
    }
    
    func body(is expectation: [Element]) {
        self.expect(expectation, read: {
            let count = $0.body.count
            var elements = [Element]()
            
            while !$0.body.isEmpty {
                elements.append($0.next())
            }
            
            test.same(count, IX(elements.count), "count [0]")
            return elements
        },  write: {
            let count = $0.body.count
            var elements = [Element]()
            
            while !$0.body.isEmpty {
                elements.append($0.next())
            }
            
            test.same(count, IX(elements.count), "count [1]")
            return elements
        })
    }
    
    func normalized(is expectation: [Element]) {
        self.expect(expectation, read: {
            var elements = [Element]()
            $0 = $0.normalized()
            
            while !$0.body.isEmpty {
                elements.append($0.next())
            }
            
            return elements
        },  write: {
            var elements = [Element]()
            $0 = $0.normalized()
            
            while !$0.body.isEmpty {
                elements.append($0.next())
            }
            
            return elements
        })
    }
    
    func prefix(_ count: UX, is expectation: [Element]) {
        self.expect(expectation, read: {
            var elements = [Element]()
            
            for _ in 0 ..< count {
                elements.append($0.next())
            }
            
            return elements
        },  write: {
            var elements = [Element]()
            
            for _ in 0 ..< count {
                elements.append($0.next())
            }
            
            return elements
        })
    }
}
