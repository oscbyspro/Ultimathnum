//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit2

//*============================================================================*
// MARK: * Data Integer x Elements
//*============================================================================*

@Suite struct DataIntegerTestsOnElements {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/buffer()", arguments: typesAsCoreIntegersAsUnsigned)
    func buffer(type: any CoreIntegerAsUnsigned.Type) throws {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: CoreIntegerAsUnsigned {
            #expect(DataInt<T>(UnsafeBufferPointer(start: nil, count: 0)) == nil)
            #expect(DataInt<T>.Body(UnsafeBufferPointer(start: nil, count: 0)) == nil)
            #expect(MutableDataInt<T>(UnsafeMutableBufferPointer(start: nil, count: 0)) == nil)
            #expect(MutableDataInt<T>.Body(UnsafeMutableBufferPointer(start: nil, count: 0)) == nil)
            
            var body: [T] = [1, 2, 3, 4]
            body.withUnsafeMutableBufferPointer {
                let start =  $0.baseAddress!
                for count in IX.zero ..< IX($0.count) {
                    let prefix = UnsafeBufferPointer(rebasing: $0.prefix(Int(count)))
                    
                    always: do {
                        let body = DataInt.Body(start, count: count)
                        #expect(body.start == start)
                        #expect(body.count == count)
                        #expect(body.count.isZero == body.isEmpty)
                        #expect(body.appendix == Bit.zero)
                        #expect(Array(body.buffer()) == Array(prefix))
                        #expect(Array(body.bytes ()) == Array(UnsafeRawBufferPointer(prefix)))
                    }
                    
                    always: do {
                        let body = MutableDataInt.Body(start, count: count)
                        #expect(body.start == start)
                        #expect(body.count == count)
                        #expect(body.count.isZero == body.isEmpty)
                        #expect(body.appendix == Bit.zero)
                        #expect(Array(body.buffer()) == Array(prefix))
                        #expect(Array(body.bytes ()) == Array(UnsafeRawBufferPointer(prefix)))
                    }
                    
                    for bit in [Bit.zero, Bit.one] {
                        let elements = DataInt(start, count: count, repeating: bit)
                        #expect(elements.body.start == start)
                        #expect(elements.body.count == count)
                        #expect(elements.appendix   == (bit))
                    }
                    
                    for bit in [Bit.zero, Bit.one] {
                        let elements = MutableDataInt(start, count: count, repeating: bit)
                        #expect(elements.body.start == start)
                        #expect(elements.body.count == count)
                        #expect(elements.appendix   == (bit))
                    }
                }
            }
        }
    }
    
    @Test("DataInt/subscript(_:) - [uniform]", arguments: typesAsCoreIntegersAsUnsigned, fuzzers)
    func element(type: any CoreIntegerAsUnsigned.Type, randomness: consuming FuzzerInt) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: CoreIntegerAsUnsigned {
            for count in UX.zero..<8 {
                let body = [T](count: Swift.Int(IX(count))) {
                    T.random(using: &randomness)
                }
                
                for index in UX.zero..<count {
                    whereIs(DXL(body), index: index, element: body[Int(IX(index))])
                }
                
                for bit in Bit.all {
                    whereIs(DXL(body, repeating: bit), index:  count, element: T(repeating: bit))
                    whereIs(DXL(body, repeating: bit), index: UX.max, element: T(repeating: bit))

                    for _ in IX.zero ..< 16 {
                        let index = UX.random(in: count...UX.max, using: &randomness)
                        whereIs(DXL(body, repeating: bit), index: index, element: T(repeating: bit))
                    }
                }
            }
        }
        
        func whereIs<T>(_ data: DXL<T>, index: UX, element: T, at location: SourceLocation = #_sourceLocation) {
            data.perform { elements, _  in
                #expect(elements[index]          == element, sourceLocation: location)
                #expect(elements[index...][0000] == element, sourceLocation: location)
                #expect(elements[index...].first == element, sourceLocation: location)
                
                if  index <  IX(data.body.count) {
                    let after = index + 1
                    #expect(elements.body[unchecked: IX(index)]          == element, sourceLocation: location)
                    #expect(elements.body[unchecked: IX(index)...].first == element, sourceLocation: location)
                    #expect(elements.body[unchecked: ..<IX(after)].last  == element, sourceLocation: location)
                    #expect(elements.body[unchecked: IX(index)...][unchecked: ()] == element, sourceLocation: location)
                }
                
                if  index >= IX(data.body.count) {
                    #expect(elements.last == element)
                }
                
                if  let index = IX.exactly(index).optional(), let result = elements.body[exactly: index] {
                    #expect(result == element, sourceLocation: location)
                }
                
            }   writing: { elements, _  in
                #expect(elements[index]          == element, sourceLocation: location)
                #expect(elements[index...][0000] == element, sourceLocation: location)
                #expect(elements[index...].first == element, sourceLocation: location)
                
                if  index <  IX(data.body.count) {
                    let after = index + 1
                    #expect(elements.body[unchecked: IX(index)]          == element, sourceLocation: location)
                    #expect(elements.body[unchecked: IX(index)...].first == element, sourceLocation: location)
                    #expect(elements.body[unchecked: ..<IX(after)].last  == element, sourceLocation: location)
                    #expect(elements.body[unchecked: IX(index)...][unchecked: ()] == element, sourceLocation: location)
                }
                
                if  index >= IX(data.body.count) {
                    #expect(elements.last == element)
                }
                
                if  let index = IX.exactly(index).optional(), let result = elements.body[exactly: index] {
                    #expect(result == element, sourceLocation: location)
                }
            }
        }
    }
}
