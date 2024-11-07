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
// MARK: * Divider
//*============================================================================*

@Suite struct DividerTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test func instances() {
        Ɣdivider(07 as U8,  mul: 00000000000000000146, add: true,  shr: 08 + 2) // shr: 10
        Ɣdivider(07 as U16, mul: 00000000000000037449, add: true,  shr: 16 + 2) // shr: 18
        Ɣdivider(07 as U32, mul: 00000000002454267026, add: true,  shr: 32 + 2) // shr: 34
        Ɣdivider(07 as U64, mul: 10540996613548315209, add: true,  shr: 64 + 2) // shr: 66
        
        Ɣdivider(10 as U8,  mul: 00000000000000000205, add: false, shr: 08 + 3) // shr: 11
        Ɣdivider(10 as U16, mul: 00000000000000052429, add: false, shr: 16 + 3) // shr: 19
        Ɣdivider(10 as U32, mul: 00000000003435973837, add: false, shr: 32 + 3) // shr: 35
        Ɣdivider(10 as U64, mul: 14757395258967641293, add: false, shr: 64 + 3) // shr: 67
        
        for distance: IX in 0 ..< 8 {
            Ɣdivider(U8 .lsb << distance, mul: U8 .max, add: true,  shr: 08 + U8 (distance))
            Ɣdivider(U16.lsb << distance, mul: U16.max, add: true,  shr: 16 + U16(distance))
            Ɣdivider(U32.lsb << distance, mul: U32.max, add: true,  shr: 32 + U32(distance))
            Ɣdivider(U64.lsb << distance, mul: U64.max, add: true,  shr: 64 + U64(distance))
        }
        
        func Ɣdivider<T>(_ divisor: T, mul: T, add: Bool, shr: T, location: SourceLocation = #_sourceLocation) where T: SystemsInteger & UnsignedInteger {
            let divider = Divider(exactly: divisor)!
            #expect(divider.mul == (mul),                sourceLocation: location)
            #expect(divider.add == (add ? mul : T.zero), sourceLocation: location)
            #expect(divider.shr == (shr),                sourceLocation: location)
        }
    }
}

//*============================================================================*
// MARK: * Divider x 2-by-1
//*============================================================================*

@Suite struct DividerTests21 {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test func instances() throws {
        Ɣdivider21(07 as U8,  mul: Doublet(low: 00000000000000000073, high: 00000000000000000146), add: true,  shr: 2 * 08 + 2) // shr:  18
        Ɣdivider21(07 as U16, mul: Doublet(low: 00000000000000009362, high: 00000000000000037449), add: true,  shr: 2 * 16 + 2) // shr:  34
        Ɣdivider21(07 as U32, mul: Doublet(low: 00000000001227133513, high: 00000000002454267026), add: true,  shr: 2 * 32 + 2) // shr:  66
        Ɣdivider21(07 as U64, mul: Doublet(low: 02635249153387078802, high: 10540996613548315209), add: true,  shr: 2 * 64 + 2) // shr: 130
        
        Ɣdivider21(10 as U8,  mul: Doublet(low: 00000000000000000205, high: 00000000000000000204), add: false, shr: 2 * 08 + 3) // shr:  21
        Ɣdivider21(10 as U16, mul: Doublet(low: 00000000000000052429, high: 00000000000000052428), add: false, shr: 2 * 16 + 3) // shr:  35
        Ɣdivider21(10 as U32, mul: Doublet(low: 00000000003435973837, high: 00000000003435973836), add: false, shr: 2 * 32 + 3) // shr:  67
        Ɣdivider21(10 as U64, mul: Doublet(low: 14757395258967641293, high: 14757395258967641292), add: false, shr: 2 * 64 + 3) // shr: 131
        
        for distance: IX in 0 ..< 8 {
            Ɣdivider21(U8 .lsb << distance, mul: Doublet(low: U8 .max, high: U8 .max), add: true, shr: 2 * 08 + U8 (distance))
            Ɣdivider21(U16.lsb << distance, mul: Doublet(low: U16.max, high: U16.max), add: true, shr: 2 * 16 + U16(distance))
            Ɣdivider21(U32.lsb << distance, mul: Doublet(low: U32.max, high: U32.max), add: true, shr: 2 * 32 + U32(distance))
            Ɣdivider21(U64.lsb << distance, mul: Doublet(low: U64.max, high: U64.max), add: true, shr: 2 * 64 + U64(distance))
        }
                
        func Ɣdivider21<T>(_ divisor: T, mul: Doublet<T>, add: Bool, shr: T, location: SourceLocation = #_sourceLocation) where T: SystemsInteger & UnsignedInteger {
            let divider = Divider21(exactly: divisor)!
            #expect(divider.mul == (mul),                   sourceLocation: location)
            #expect(divider.add == (add ? mul : Doublet()), sourceLocation: location)
            #expect(divider.shr == (shr),                   sourceLocation: location)
        }
    }
}
