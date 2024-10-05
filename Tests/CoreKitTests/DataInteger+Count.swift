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
// MARK: * Data Integer x Count
//*============================================================================*

@Suite struct DataIntegerTestsOnCount {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test("DataInt/size()", arguments: coreIntegersWhereIsUnsigned)
    func size(type: any SystemsIntegerWhereIsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            whereIs(DXL([          ] as [T]), is: 0 * IX(size: T.self))
            whereIs(DXL([11        ] as [T]), is: 1 * IX(size: T.self))
            whereIs(DXL([11, 22    ] as [T]), is: 2 * IX(size: T.self))
            whereIs(DXL([11, 22, 33] as [T]), is: 3 * IX(size: T.self))
            
            whereIs(DXL([00, 00, 00] as [T]), is: 3 * IX(size: T.self))
            whereIs(DXL([11, 00, 00] as [T]), is: 3 * IX(size: T.self))
            whereIs(DXL([11, 22, 00] as [T]), is: 3 * IX(size: T.self))
            whereIs(DXL([11, 22, 33] as [T]), is: 3 * IX(size: T.self))
        }
         
        /// - Parameter expectation: The number of bits in its `body`.
        func whereIs<T>(_ data: DXL<T>, is expectation: IX) {
            data.perform { elements, _ in
                #expect(elements.size()      == Count.infinity)
                #expect(elements.body.size() == Count(expectation))
            }   writing: { elements, _ in
                #expect(elements.size()      == Count.infinity)
                #expect(elements.body.size() == Count(expectation))
            }
        }
    }
    
    @Test("DataInt/count(_:)", arguments: coreIntegersWhereIsUnsigned)
    func count(type: any SystemsIntegerWhereIsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            whereIs(DXL([          ] as [T]), is: 0 as IX)
            whereIs(DXL([11        ] as [T]), is: 3 as IX)
            whereIs(DXL([11, 22    ] as [T]), is: 6 as IX)
            whereIs(DXL([11, 22, 33] as [T]), is: 8 as IX)
            
            whereIs(DXL([00, 00, 00] as [T]), is: 0 as IX)
            whereIs(DXL([11, 00, 00] as [T]), is: 3 as IX)
            whereIs(DXL([11, 22, 00] as [T]), is: 6 as IX)
            whereIs(DXL([11, 22, 33] as [T]), is: 8 as IX)
        }
        
        /// - Parameter expectation: The number of `1s` in its `body`.
        func whereIs<T>(_ data: DXL<T>, is expectation: IX, at location: SourceLocation = #_sourceLocation) {
            data.perform { elements, _ in
                let size = IX(raw: elements.body.size())
                let extended = expectation - IX(elements.appendix)  *   (size + 1)
                #expect(elements     .count(Bit.one ) == Count(raw:      extended), sourceLocation: location)
                #expect(elements     .count(Bit.zero) == Count(raw:     ~extended), sourceLocation: location)
                #expect(elements.body.count(Bit.one ) == Count(       expectation), sourceLocation: location)
                #expect(elements.body.count(Bit.zero) == Count(size - expectation), sourceLocation: location)
            }   writing: { elements, _ in
                let size = IX(raw: elements.body.size())
                let extended = expectation - IX(elements.appendix)  *   (size + 1)
                #expect(elements     .count(Bit.one ) == Count(raw:      extended), sourceLocation: location)
                #expect(elements     .count(Bit.zero) == Count(raw:     ~extended), sourceLocation: location)
                #expect(elements.body.count(Bit.one ) == Count(       expectation), sourceLocation: location)
                #expect(elements.body.count(Bit.zero) == Count(size - expectation), sourceLocation: location)
            }
        }
    }
    
    @Test("DataInt/ascending(_:)", arguments: coreIntegersWhereIsUnsigned)
    func ascending(type: any SystemsIntegerWhereIsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            let size = IX(size: T.self)

            for bit in Bit.all {
                whereIs(DXL([          ] as [T]), counting:  bit, is: 0 as IX)
                whereIs(DXL([11        ] as [T]), counting:  bit, is: 2 as IX * IX(bit))
                whereIs(DXL([11, 22    ] as [T]), counting:  bit, is: 2 as IX * IX(bit))
                whereIs(DXL([11, 22, 33] as [T]), counting:  bit, is: 2 as IX * IX(bit))
            }
            
            for bit in Bit.all {
                let aa = T(repeating: bit)
                let bb = T(repeating: bit) ^ T(11).toggled()
                
                whereIs(DXL([bb        ] as [T]), counting:  bit, is: 2 as IX + (0 * size))
                whereIs(DXL([aa, bb    ] as [T]), counting:  bit, is: 2 as IX + (1 * size))
                whereIs(DXL([aa, aa, bb] as [T]), counting:  bit, is: 2 as IX + (2 * size))
                whereIs(DXL([aa, aa, aa] as [T]), counting:  bit, is: 0 as IX + (3 * size))

                whereIs(DXL([bb        ] as [T]), counting: ~bit, is: IX.zero)
                whereIs(DXL([aa, bb    ] as [T]), counting: ~bit, is: IX.zero)
                whereIs(DXL([aa, aa, bb] as [T]), counting: ~bit, is: IX.zero)
                whereIs(DXL([aa, aa, aa] as [T]), counting: ~bit, is: IX.zero)
            }
        }
        
        /// - Parameter expectation: The number of ascending `bit` in its `body`.
        func whereIs<T>(_ data: DXL<T>, counting bit: Bit, is expectation: IX, at location: SourceLocation = #_sourceLocation) {
            data.perform { elements, _ in
                let size = IX(raw: elements.body.size())
                let extended = expectation | IX(repeating: Bit(expectation == size && elements.appendix == bit))
                #expect(elements        .ascending(bit) == Count(raw:      extended), sourceLocation: location)
                #expect(elements     .nonascending(bit) == Count(raw:     ~extended), sourceLocation: location)
                #expect(elements.body   .ascending(bit) == Count(       expectation), sourceLocation: location)
                #expect(elements.body.nonascending(bit) == Count(size - expectation), sourceLocation: location)
            }   writing: { elements, _ in
                let size = IX(raw: elements.body.size())
                let extended = expectation | IX(repeating: Bit(expectation == size && elements.appendix == bit))
                #expect(elements        .ascending(bit) == Count(raw:      extended), sourceLocation: location)
                #expect(elements     .nonascending(bit) == Count(raw:     ~extended), sourceLocation: location)
                #expect(elements.body   .ascending(bit) == Count(       expectation), sourceLocation: location)
                #expect(elements.body.nonascending(bit) == Count(size - expectation), sourceLocation: location)
            }
        }
    }
    
    @Test("DataInt/descending(_:)", arguments: coreIntegersWhereIsUnsigned)
    func descending(type: any SystemsIntegerWhereIsUnsigned.Type) {
        whereIs(type)
        
        func whereIs<T>(_ type: T.Type) where T: SystemsIntegerWhereIsUnsigned {
            let size = IX(size: T.self)
            
            for bit in Bit.all {
                whereIs(DXL([          ] as [T]), counting: ~bit, is: IX(  ))
                whereIs(DXL([11        ] as [T]), counting: ~bit, is: IX(bit) * (size - 4))
                whereIs(DXL([11, 22    ] as [T]), counting: ~bit, is: IX(bit) * (size - 5))
                whereIs(DXL([11, 22, 33] as [T]), counting: ~bit, is: IX(bit) * (size - 6))
            }
            
            for bit in Bit.all {
                let aa = T(repeating: bit)
                let bb = T(repeating: bit) ^ T(13).toggled() << (size - 4)
                
                whereIs(DXL([bb        ] as [T]), counting:  bit, is: 2 as IX + (0 * size))
                whereIs(DXL([bb, aa    ] as [T]), counting:  bit, is: 2 as IX + (1 * size))
                whereIs(DXL([bb, aa, aa] as [T]), counting:  bit, is: 2 as IX + (2 * size))
                whereIs(DXL([aa, aa, aa] as [T]), counting:  bit, is: 0 as IX + (3 * size))
                
                whereIs(DXL([bb        ] as [T]), counting: ~bit, is: IX.zero)
                whereIs(DXL([bb, aa    ] as [T]), counting: ~bit, is: IX.zero)
                whereIs(DXL([bb, aa, aa] as [T]), counting: ~bit, is: IX.zero)
                whereIs(DXL([aa, aa, aa] as [T]), counting: ~bit, is: IX.zero)
            }
        }
        
        /// - Parameter expectation: The number of descending `bit` in its `body`.
        func whereIs<T>(_ data: DXL<T>, counting bit: Bit, is expectation: IX, at location: SourceLocation = #_sourceLocation) {
            data.perform { elements, _ in
                let size = IX(raw: elements.body.size())
                let extended = (-1 + expectation - size) &  IX(repeating: Bit(elements.appendix == bit))
                #expect(elements.body   .descending(bit) == Count(       expectation), sourceLocation: location)
                #expect(elements.body.nondescending(bit) == Count(size - expectation), sourceLocation: location)
                #expect(elements        .descending(bit) == Count(raw:      extended), sourceLocation: location)
                #expect(elements     .nondescending(bit) == Count(raw:     ~extended), sourceLocation: location)
            }   writing: { elements, _ in
                let size = IX(raw: elements.body.size())
                let extended = (-1 + expectation - size) &  IX(repeating: Bit(elements.appendix == bit))
                #expect(elements.body   .descending(bit) == Count(       expectation), sourceLocation: location)
                #expect(elements.body.nondescending(bit) == Count(size - expectation), sourceLocation: location)
                #expect(elements        .descending(bit) == Count(raw:      extended), sourceLocation: location)
                #expect(elements     .nondescending(bit) == Count(raw:     ~extended), sourceLocation: location)
            }
        }
    }
}
