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
    
    func testUnsafeBufferPointer() {
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            Test().none(DataInt<T>(UnsafeBufferPointer(start: nil, count: 0)))
            Test().none(DataInt<T>.Body(UnsafeBufferPointer(start: nil, count: 0)))
            Test().none(MutableDataInt<T>(UnsafeMutableBufferPointer(start: nil, count: 0)))
            Test().none(MutableDataInt<T>.Body(UnsafeMutableBufferPointer(start: nil, count: 0)))
            
            var body = Array(repeating: T.zero, count: 3)
            body.withUnsafeMutableBufferPointer {
                let start =  $0.baseAddress!
                for count in IX.zero ..< IX($0.count) {
                    always: do {
                        let body = DataInt.Body(start, count: count)
                        Test().same(body.start, start)
                        Test().same(body.count, count)
                        Test().same(body.count.isZero, body.isEmpty)
                        Test().same(body.appendix, Bit.zero)
                        Test().same(Array(body.buffer()), Array($0.prefix(Int(count))))
                    }
                        
                    always: do {
                        let body = MutableDataInt.Body(start, count: count)
                        Test().same(body.start, start)
                        Test().same(body.count, count)
                        Test().same(body.count.isZero, body.isEmpty)
                        Test().same(body.appendix, Bit.zero)
                        Test().same(Array(body.buffer()), Array($0.prefix(Int(count))))
                    }
                    
                    for bit: Bit in [0, 1] {
                        let elements = DataInt(start, count: count, repeating: bit)
                        Test().same(elements.body.start, start)
                        Test().same(elements.body.count, count)
                        Test().same(elements.appendix, ((bit)))
                    }
                    
                    for bit: Bit in [0, 1] {
                        let elements = MutableDataInt(start, count: count, repeating: bit)
                        Test().same(elements.body.start, start)
                        Test().same(elements.body.count, count)
                        Test().same(elements.appendix, ((bit)))
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
        
        if  index.isZero {
            DataIntTests.Body(self.item.body, test: self.test).expect(expectation, read: {
                $0.first
            },  write: {
                $0.first
            })
        }
        
        if  index == IX(self.item.body.count) - 1 {
            DataIntTests.Body(self.item.body, test: self.test).expect(expectation, read: {
                $0.last
            },  write: {
                $0.last
            })
        }
        
        if  let index = IX.exactly(index).optional(), index < IX(self.item.body.count) {
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
                $0[exactly: index]
            },  write: {
                $0[exactly: index]
            })
            
        }   else {
            DataIntTests.Body(self.item.body, test: self.test).expect(((((nil)))), read: {
                $0[exactly: IX(raw: index)]
            },  write: {
                $0[exactly: IX(raw: index)]
            })
        }
    }
}
