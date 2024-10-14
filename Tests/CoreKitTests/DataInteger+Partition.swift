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
// MARK: * Data Integer x Partition
//*============================================================================*

@Suite struct DataIntegerTestsOnPartition {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/split(at:)", arguments: typesAsCoreIntegersAsUnsigned)
    func split(_ type: any SystemsIntegerAsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            Ɣexpect(split: [       ] as [T], clamping: 0, low: [       ] as [T], high: [       ] as [T])
            Ɣexpect(split: [       ] as [T], clamping: 1, low: [       ] as [T], high: [       ] as [T])
            Ɣexpect(split: [       ] as [T], clamping: 2, low: [       ] as [T], high: [       ] as [T])
            Ɣexpect(split: [       ] as [T], clamping: 3, low: [       ] as [T], high: [       ] as [T])
            
            Ɣexpect(split: [1      ] as [T], clamping: 0, low: [       ] as [T], high: [1      ] as [T])
            Ɣexpect(split: [1      ] as [T], clamping: 1, low: [1      ] as [T], high: [       ] as [T])
            Ɣexpect(split: [1      ] as [T], clamping: 2, low: [1      ] as [T], high: [       ] as [T])
            Ɣexpect(split: [1      ] as [T], clamping: 3, low: [1      ] as [T], high: [       ] as [T])
            
            Ɣexpect(split: [1, 2   ] as [T], clamping: 0, low: [       ] as [T], high: [1, 2   ] as [T])
            Ɣexpect(split: [1, 2   ] as [T], clamping: 1, low: [1      ] as [T], high: [   2   ] as [T])
            Ɣexpect(split: [1, 2   ] as [T], clamping: 2, low: [1, 2   ] as [T], high: [       ] as [T])
            Ɣexpect(split: [1, 2   ] as [T], clamping: 3, low: [1, 2   ] as [T], high: [       ] as [T])
            
            Ɣexpect(split: [1, 2, 3] as [T], clamping: 0, low: [       ] as [T], high: [1, 2, 3] as [T])
            Ɣexpect(split: [1, 2, 3] as [T], clamping: 1, low: [1      ] as [T], high: [   2, 3] as [T])
            Ɣexpect(split: [1, 2, 3] as [T], clamping: 2, low: [1, 2   ] as [T], high: [      3] as [T])
            Ɣexpect(split: [1, 2, 3] as [T], clamping: 3, low: [1, 2, 3] as [T], high: [       ] as [T])
        }
    }
    
    func Ɣexpect<T>(split body: [T], clamping index: IX, low: [T], high: [T], at location: SourceLocation = #_sourceLocation)
    where T: SystemsIntegerAsUnsigned {
        let index = Swift.min(Swift.max(IX.zero, index), IX(body.count))
        
        DXL(body, repeating: Bit.zero, as: Signedness.unsigned).perform { elements, _ in
            #expect(elements.body.split(unchecked: index).low .buffer().elementsEqual(low ), sourceLocation: location)
            #expect(elements.body.split(unchecked: index).high.buffer().elementsEqual(high), sourceLocation: location)
        }   writing: { elements, _ in
            #expect(elements.body.split(unchecked: index).low .buffer().elementsEqual(low ), sourceLocation: location)
            #expect(elements.body.split(unchecked: index).high.buffer().elementsEqual(high), sourceLocation: location)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/body", arguments: typesAsCoreIntegersAsUnsigned)
    func body(_ type: any SystemsIntegerAsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerAsUnsigned {
            Ɣexpect(DXL([       ]), body: [       ] as [T])
            Ɣexpect(DXL([1      ]), body: [1      ] as [T])
            Ɣexpect(DXL([1, 2   ]), body: [1, 2   ] as [T])
            Ɣexpect(DXL([1, 2, 3]), body: [1, 2, 3] as [T])
        }
    }
    
    func Ɣexpect<T>(_ data: DXL<T>, body expectation: [T], at location: SourceLocation = #_sourceLocation) {
        data.perform { elements, _ in
            #expect(elements.body.buffer().elementsEqual(expectation), sourceLocation: location)
        }   writing: { elements, _ in
            #expect(elements.body.buffer().elementsEqual(expectation), sourceLocation: location)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/normalized()", arguments: typesAsCoreIntegersAsUnsigned)
    func normalized(_ type: any SystemsIntegerAsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            for bit in Bit.all {
                let a = T(repeating: bit)
                let b = T(repeating: bit.toggled())
                
                Ɣexpect(DXL([       ] as [T], repeating: bit), normalized: [       ] as [T])
                Ɣexpect(DXL([1      ] as [T], repeating: bit), normalized: [1      ] as [T])
                Ɣexpect(DXL([1, 2   ] as [T], repeating: bit), normalized: [1, 2   ] as [T])
                Ɣexpect(DXL([1, 2, 3] as [T], repeating: bit), normalized: [1, 2, 3] as [T])
                
                Ɣexpect(DXL([a, a, a] as [T], repeating: bit), normalized: [       ] as [T])
                Ɣexpect(DXL([1, a, a] as [T], repeating: bit), normalized: [1      ] as [T])
                Ɣexpect(DXL([1, 2, a] as [T], repeating: bit), normalized: [1, 2   ] as [T])
                Ɣexpect(DXL([1, 2, 3] as [T], repeating: bit), normalized: [1, 2, 3] as [T])
                
                Ɣexpect(DXL([b, b, b] as [T], repeating: bit), normalized: [b, b, b] as [T])
                Ɣexpect(DXL([1, b, b] as [T], repeating: bit), normalized: [1, b, b] as [T])
                Ɣexpect(DXL([1, 2, b] as [T], repeating: bit), normalized: [1, 2, b] as [T])
                Ɣexpect(DXL([1, 2, 3] as [T], repeating: bit), normalized: [1, 2, 3] as [T])
            }
        }
    }
    
    func Ɣexpect<T>(_ data: DXL<T>, normalized expectation: [T], at location: SourceLocation = #_sourceLocation) {
        data.perform { elements, _ in
            
            let result = [T](elements.normalized().body.buffer())
            #expect(elements.isNormal == (elements.body.count == IX(result.count)), sourceLocation: location)
            #expect(result == expectation, sourceLocation: location)
            
            if  elements.appendix == Bit.zero {
                let result = [T](elements.body.normalized().buffer())
                #expect(elements.body.isNormal == (elements.body.count == IX(result.count)), sourceLocation: location)
                #expect(result == expectation, sourceLocation: location)
            }
            
        }   writing: { elements, _ in
            
            let result = [T](elements.normalized().body.buffer())
            #expect(elements.isNormal == (elements.body.count == IX(result.count)), sourceLocation: location)
            #expect(result == expectation, sourceLocation: location)
            
            if  elements.appendix == Bit.zero {
                let result = [T](elements.body.normalized().buffer())
                #expect(elements.body.isNormal == (elements.body.count == IX(result.count)), sourceLocation: location)
                #expect(result == expectation, sourceLocation: location)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/prefix(_:)", .serialized, arguments: typesAsCoreIntegersAsUnsigned)
    func prefix(_ type: any SystemsIntegerAsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsInteger & UnsignedInteger {
            for count in 0 ... 8 {
                let body = Array(1 ..< T(IX(count+1)))
                Ɣexpect(DXL(body, repeating: Bit.zero), prefix: body + [T](repeating: T.min, count: 8 - count))
                Ɣexpect(DXL(body, repeating: Bit.one ), prefix: body + [T](repeating: T.max, count: 8 - count))
            }
        }
    }
    
    func Ɣexpect<T>(_ data: DXL<T>, prefix expectation: [T], at location: SourceLocation = #_sourceLocation) {
        data.perform { elements, _ in
            #expect(expectation.reduce(true) { $0 && $1 == elements.next() }, sourceLocation: location)
        }   writing: { elements, _ in
            #expect(expectation.reduce(true) { $0 && $1 == elements.next() }, sourceLocation: location)
        }
    }
}
