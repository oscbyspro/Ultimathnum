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
// MARK: * Data Integer x Reinterpretation
//*============================================================================*

@Suite struct DataIntegerTestsOnReinterpretation {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt<U8>/load(as: U8.self)", .serialized, arguments: [
        
        (data: DXL([1, 2, 3] as [U8]                  ), index:  0 as UX, element: 0x01 as U8),
        (data: DXL([1, 2, 3] as [U8]                  ), index:  1 as UX, element: 0x02 as U8),
        (data: DXL([1, 2, 3] as [U8]                  ), index:  2 as UX, element: 0x03 as U8),
        (data: DXL([1, 2, 3] as [U8], repeating: .zero), index:  3 as UX, element: 0x00 as U8),
        (data: DXL([1, 2, 3] as [U8], repeating:  .one), index:  3 as UX, element: 0xff as U8),
        (data: DXL([1, 2, 3] as [U8], repeating: .zero), index: ~0 as UX, element: 0x00 as U8),
        (data: DXL([1, 2, 3] as [U8], repeating:  .one), index: ~0 as UX, element: 0xff as U8),

    ])  func load0808(data: DXL<U8>, index: UX, element: U8) {
        Ɣexpect(data, load: index, is: element)
    }
    
    @Test("DataInt<U8>/load(as: U16.self)", .serialized, arguments: [
        
        (data: DXL([1, 2, 3] as [U8]                  ), index:  0 as UX, element: 0x0201 as U16),
        (data: DXL([1, 2, 3] as [U8]                  ), index:  1 as UX, element: 0x0302 as U16),
        (data: DXL([1, 2, 3] as [U8], repeating: .zero), index:  2 as UX, element: 0x0003 as U16),
        (data: DXL([1, 2, 3] as [U8], repeating:  .one), index:  2 as UX, element: 0xff03 as U16),
        (data: DXL([1, 2, 3] as [U8], repeating: .zero), index:  3 as UX, element: 0x0000 as U16),
        (data: DXL([1, 2, 3] as [U8], repeating:  .one), index:  3 as UX, element: 0xffff as U16),
        (data: DXL([1, 2, 3] as [U8], repeating: .zero), index: ~0 as UX, element: 0x0000 as U16),
        (data: DXL([1, 2, 3] as [U8], repeating:  .one), index: ~0 as UX, element: 0xffff as U16),

    ])  func load0816(data: DXL<U8>, index: UX, element: U16) {
        Ɣexpect(data, load: index, is: element)
    }
    
    func Ɣexpect<T>(_ data: DXL<U8>, load index: UX, is expectation: T, at location: SourceLocation = #_sourceLocation)
    where T: SystemsInteger & UnsignedInteger {
        data.perform { elements, _ in
            #expect(elements[index...].load(as: T.self) == expectation, sourceLocation: location)
        }   writing: { elements, _ in
            #expect(elements[index...].load(as: T.self) == expectation, sourceLocation: location)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt<U8>/body(as: U8.self)", .serialized, arguments: [
        
        (data: DXL([       ] as [U8]), expectation: [       ] as [U8]),
        (data: DXL([1,     ] as [U8]), expectation: [1      ] as [U8]),
        (data: DXL([1, 2   ] as [U8]), expectation: [1, 2   ] as [U8]),
        (data: DXL([1, 2, 3] as [U8]), expectation: [1, 2, 3] as [U8]),

    ])  func body0808(data: DXL<U8>, expectation: [U8]) {
        Ɣexpect(data, body: expectation)
    }
    
    @Test("DataInt<U8>/body(as: U16.self)", .serialized, arguments: [
        
        (data: DXL([       ] as [U8]                     ), expectation: [              ] as [U16]),
        (data: DXL([1,     ] as [U8], repeating: Bit.zero), expectation: [0x0001        ] as [U16]),
        (data: DXL([1,     ] as [U8], repeating: Bit.one ), expectation: [0xff01        ] as [U16]),
        (data: DXL([1, 2   ] as [U8]                     ), expectation: [0x0201        ] as [U16]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.zero), expectation: [0x0201, 0x0003] as [U16]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.one ), expectation: [0x0201, 0xff03] as [U16]),
        
    ])  func body0816(data: DXL<U8>, expectation: [U16]) {
        Ɣexpect(data, body: expectation)
    }
    
    func Ɣexpect<T>(_ data: DXL<U8>, body expectation: [T], at location: SourceLocation = #_sourceLocation)
    where T: SystemsInteger & UnsignedInteger {
        data.perform { elements, _ in
            
            #expect(elements.body.count(as: T.self) == IX(expectation.count), sourceLocation: location)
            
            var result = [T]()
            
            while !elements.body.isEmpty {
                result.append(elements.next(as: T.self))
            }
            
            #expect(result == expectation, sourceLocation: location)
            
        }   writing: { elements, _ in

            #expect(elements.body.count(as: T.self) == IX(expectation.count), sourceLocation: location)
            
            var result = [T]()
            
            while !elements.body.isEmpty {
                result.append(elements.next(as: T.self))
            }
            
            #expect(result == expectation, sourceLocation: location)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt<U8>/normalized(as: U8.self)")
    func normalized0808() {
        
        for bit in [Bit.zero, Bit.one] {
            let a = U8(repeating: bit)
            let b = U8(repeating: bit.toggled())
            
            Ɣexpect(DXL([a, a, a], repeating: bit), normalized: [       ] as [U8])
            Ɣexpect(DXL([1, a, a], repeating: bit), normalized: [1      ] as [U8])
            Ɣexpect(DXL([1, 2, a], repeating: bit), normalized: [1, 2   ] as [U8])
            Ɣexpect(DXL([1, 2, 3], repeating: bit), normalized: [1, 2, 3] as [U8])
            
            Ɣexpect(DXL([b, b, b], repeating: bit), normalized: [b, b, b] as [U8])
            Ɣexpect(DXL([1, b, b], repeating: bit), normalized: [1, b, b] as [U8])
            Ɣexpect(DXL([1, 2, b], repeating: bit), normalized: [1, 2, b] as [U8])
            Ɣexpect(DXL([1, 2, 3], repeating: bit), normalized: [1, 2, 3] as [U8])
        }
    }
    
    @Test("DataInt<U8>/normalized(as: U16.self)")
    func normalized0816() {
        
        for bit in [Bit.zero, Bit.one] {
            let a = U8 (repeating: bit)
            let b = U8 (repeating: bit.toggled())
            let x = U16(repeating: bit)
            let y = U16(repeating: bit.toggled())
            
            Ɣexpect(DXL([a, a, a], repeating: bit), normalized: [                                    ] as [U16])
            Ɣexpect(DXL([1, a, a], repeating: bit), normalized: [(x << 8)|(0x0001)                   ] as [U16])
            Ɣexpect(DXL([1, 2, a], repeating: bit), normalized: [(0x0201)|(0x0000)                   ] as [U16])
            Ɣexpect(DXL([1, 2, 3], repeating: bit), normalized: [(0x0201)|(0x0000), (x << 8)|(0x0003)] as [U16])
            
            Ɣexpect(DXL([b, b, b], repeating: bit), normalized: [(y << 0)|(0x0000), (x << 8)|(y >> 8)] as [U16])
            Ɣexpect(DXL([1, b, b], repeating: bit), normalized: [(y << 8)|(0x0001), (x << 8)|(y >> 8)] as [U16])
            Ɣexpect(DXL([1, 2, b], repeating: bit), normalized: [(0x0201)|(0x0000), (x << 8)|(y >> 8)] as [U16])
            Ɣexpect(DXL([1, 2, 3], repeating: bit), normalized: [(0x0201)|(0x0000), (x << 8)|(0x0003)] as [U16])
        }
    }
    
    func Ɣexpect<T>(_ data: DXL<U8>, normalized expectation: [T], at location: SourceLocation = #_sourceLocation)
    where T: SystemsInteger & UnsignedInteger {
        data.perform { elements, _ in
            
            elements = elements.normalized()
            #expect(elements.body.count(as: T.self) == IX(expectation.count), sourceLocation: location)
            
            var result = [T]()
            
            while !elements.body.isEmpty {
                result.append(elements.next(as: T.self))
            }
            
            #expect(result == expectation, sourceLocation: location)
            
        }   writing: { elements, _ in
            
            elements = elements.normalized()
            #expect(elements.body.count(as: T.self) == IX(expectation.count), sourceLocation: location)
            
            var result = [T]()
            
            while !elements.body.isEmpty {
                result.append(elements.next(as: T.self))
            }
            
            #expect(result == expectation, sourceLocation: location)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt<U8>/prefix(_:as: U8.self)", .serialized, arguments: [
        
        (data: DXL([1, 2, 3] as [U8]                     ), expectation: [                      ] as [U8]),
        (data: DXL([1, 2, 3] as [U8]                     ), expectation: [0x01                  ] as [U8]),
        (data: DXL([1, 2, 3] as [U8]                     ), expectation: [0x01, 0x02            ] as [U8]),
        (data: DXL([1, 2, 3] as [U8]                     ), expectation: [0x01, 0x02, 0x03      ] as [U8]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.zero), expectation: [0x01, 0x02, 0x03, 0x00] as [U8]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.one ), expectation: [0x01, 0x02, 0x03, 0xff] as [U8]),

    ])  func prefix0808(data: DXL<U8>, expectation: [U8]) {
        Ɣexpect(data, prefix: expectation)
    }
    
    @Test("DataInt<U8>/prefix(_:as: U16.self)", .serialized, arguments: [
        
        (data: DXL([1, 2, 3] as [U8]                     ), expectation: [                              ] as [U16]),
        (data: DXL([1, 2, 3] as [U8]                     ), expectation: [0x0201                        ] as [U16]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.zero), expectation: [0x0201, 0x0003                ] as [U16]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.one ), expectation: [0x0201, 0xff03                ] as [U16]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.zero), expectation: [0x0201, 0x0003, 0x0000        ] as [U16]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.one ), expectation: [0x0201, 0xff03, 0xffff        ] as [U16]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.zero), expectation: [0x0201, 0x0003, 0x0000, 0x0000] as [U16]),
        (data: DXL([1, 2, 3] as [U8], repeating: Bit.one ), expectation: [0x0201, 0xff03, 0xffff, 0xffff] as [U16]),

    ])  func prefix0816(data: DXL<U8>, expectation: [U16]) {
        Ɣexpect(data, prefix: expectation)
    }
    
    func Ɣexpect<T>(_ data: DXL<U8>, prefix expectation: [T], at location: SourceLocation = #_sourceLocation)
    where T: SystemsInteger & UnsignedInteger {
        data.perform { elements, _ in
            
            var result = [T]()
            
            for _ in 0 ..< expectation.count {
                result.append(elements.next(as: T.self))
            }
            
            #expect(result == expectation, sourceLocation: location)
            
        }   writing: { elements, _ in
            
            var result = [T]()
            
            for _ in 0 ..< expectation.count {
                result.append(elements.next(as: T.self))
            }
            
            #expect(result == expectation, sourceLocation: location)
        }
    }
}
