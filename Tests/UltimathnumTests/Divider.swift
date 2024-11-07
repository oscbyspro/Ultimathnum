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
    
    @Test(
        "Divider: exampels from 1 through 12",
        ParallelizationTrait.serialized,
        arguments: [
            
            (div: U8 ( 1), mul: U64(                 255), add: true,  shr: U64( 8 + 0)),
            (div: U16( 1), mul: U64(               65535), add: true,  shr: U64(16 + 0)),
            (div: U32( 1), mul: U64(          4294967295), add: true,  shr: U64(32 + 0)),
            (div: U64( 1), mul: U64(18446744073709551615), add: true,  shr: U64(64 + 0)),
            
            (div: U8 ( 2), mul: U64(                 255), add: true,  shr: U64( 8 + 1)),
            (div: U16( 2), mul: U64(               65535), add: true,  shr: U64(16 + 1)),
            (div: U32( 2), mul: U64(          4294967295), add: true,  shr: U64(32 + 1)),
            (div: U64( 2), mul: U64(18446744073709551615), add: true,  shr: U64(64 + 1)),
            
            (div: U8 ( 3), mul: U64(                 171), add: false, shr: U64( 8 + 1)),
            (div: U16( 3), mul: U64(               43691), add: false, shr: U64(16 + 1)),
            (div: U32( 3), mul: U64(          2863311531), add: false, shr: U64(32 + 1)),
            (div: U64( 3), mul: U64(12297829382473034411), add: false, shr: U64(64 + 1)),
            
            (div: U8 ( 4), mul: U64(                 255), add: true,  shr: U64( 8 + 2)),
            (div: U16( 4), mul: U64(               65535), add: true,  shr: U64(16 + 2)),
            (div: U32( 4), mul: U64(          4294967295), add: true,  shr: U64(32 + 2)),
            (div: U64( 4), mul: U64(18446744073709551615), add: true,  shr: U64(64 + 2)),
            
            (div: U8 ( 5), mul: U64(                 205), add: false, shr: U64( 8 + 2)),
            (div: U16( 5), mul: U64(               52429), add: false, shr: U64(16 + 2)),
            (div: U32( 5), mul: U64(          3435973837), add: false, shr: U64(32 + 2)),
            (div: U64( 5), mul: U64(14757395258967641293), add: false, shr: U64(64 + 2)),
            
            (div: U8 ( 6), mul: U64(                 171), add: false, shr: U64( 8 + 2)),
            (div: U16( 6), mul: U64(               43691), add: false, shr: U64(16 + 2)),
            (div: U32( 6), mul: U64(          2863311531), add: false, shr: U64(32 + 2)),
            (div: U64( 6), mul: U64(12297829382473034411), add: false, shr: U64(64 + 2)),
            
            (div: U8 ( 7), mul: U64(                 146), add: true,  shr: U64( 8 + 2)),
            (div: U16( 7), mul: U64(               37449), add: true,  shr: U64(16 + 2)),
            (div: U32( 7), mul: U64(          2454267026), add: true,  shr: U64(32 + 2)),
            (div: U64( 7), mul: U64(10540996613548315209), add: true,  shr: U64(64 + 2)),
            
            (div: U8 ( 8), mul: U64(                 255), add: true,  shr: U64( 8 + 3)),
            (div: U16( 8), mul: U64(               65535), add: true,  shr: U64(16 + 3)),
            (div: U32( 8), mul: U64(          4294967295), add: true,  shr: U64(32 + 3)),
            (div: U64( 8), mul: U64(18446744073709551615), add: true,  shr: U64(64 + 3)),
            
            (div: U8 ( 9), mul: U64(                 227), add: true,  shr: U64( 8 + 3)),
            (div: U16( 9), mul: U64(               58254), add: true,  shr: U64(16 + 3)),
            (div: U32( 9), mul: U64(          3817748707), add: true,  shr: U64(32 + 3)),
            (div: U64( 9), mul: U64(16397105843297379214), add: true,  shr: U64(64 + 3)),
            
            (div: U8 (10), mul: U64(                 205), add: false, shr: U64( 8 + 3)),
            (div: U16(10), mul: U64(               52429), add: false, shr: U64(16 + 3)),
            (div: U32(10), mul: U64(          3435973837), add: false, shr: U64(32 + 3)),
            (div: U64(10), mul: U64(14757395258967641293), add: false, shr: U64(64 + 3)),
            
            (div: U8 (11), mul: U64(                 186), add: true,  shr: U64( 8 + 3)),
            (div: U16(11), mul: U64(               47662), add: true,  shr: U64(16 + 3)),
            (div: U32(11), mul: U64(          3123612579), add: false, shr: U64(32 + 3)),
            (div: U64(11), mul: U64(13415813871788764811), add: true,  shr: U64(64 + 3)),
            
            (div: U8 (12), mul: U64(                 171), add: false, shr: U64( 8 + 3)),
            (div: U16(12), mul: U64(               43691), add: false, shr: U64(16 + 3)),
            (div: U32(12), mul: U64(          2863311531), add: false, shr: U64(32 + 3)),
            (div: U64(12), mul: U64(12297829382473034411), add: false, shr: U64(64 + 3)),
            
        ] as [(
        div: any SystemsIntegerAsUnsigned, mul: U64, add: Bool, shr: U64
    )]) func examplesFrom1Through12(
        div: any SystemsIntegerAsUnsigned, mul: U64, add: Bool, shr: U64
    )   throws {
        
        try  whereIs(div)
        func whereIs<T>(_ div: T) throws where T: SystemsIntegerAsUnsigned {
            let divider = try #require(Divider(exactly: div))
            
            #expect(divider.div == (div))
            #expect(divider.mul == (mul))
            #expect(divider.add == (add ? mul : 0))
            #expect(divider.shr == (shr))
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
    
    @Test(
        "Divider: exampels from 1 through 12",
        ParallelizationTrait.serialized,
        arguments: [
            
            (div: U8 ( 1), mul: Doublet<U64>(low:                  255, high:                  255), add: true,  shr: U64( 16 + 0)),
            (div: U16( 1), mul: Doublet<U64>(low:                65535, high:                65535), add: true,  shr: U64( 32 + 0)),
            (div: U32( 1), mul: Doublet<U64>(low:           4294967295, high:           4294967295), add: true,  shr: U64( 64 + 0)),
            (div: U64( 1), mul: Doublet<U64>(low: 18446744073709551615, high: 18446744073709551615), add: true,  shr: U64(128 + 0)),
            
            (div: U8 ( 2), mul: Doublet<U64>(low:                  255, high:                  255), add: true,  shr: U64( 16 + 1)),
            (div: U16( 2), mul: Doublet<U64>(low:                65535, high:                65535), add: true,  shr: U64( 32 + 1)),
            (div: U32( 2), mul: Doublet<U64>(low:           4294967295, high:           4294967295), add: true,  shr: U64( 64 + 1)),
            (div: U64( 2), mul: Doublet<U64>(low: 18446744073709551615, high: 18446744073709551615), add: true,  shr: U64(128 + 1)),

            (div: U8 ( 3), mul: Doublet<U64>(low:                  171, high:                  170), add: false, shr: U64( 16 + 1)),
            (div: U16( 3), mul: Doublet<U64>(low:                43691, high:                43690), add: false, shr: U64( 32 + 1)),
            (div: U32( 3), mul: Doublet<U64>(low:           2863311531, high:           2863311530), add: false, shr: U64( 64 + 1)),
            (div: U64( 3), mul: Doublet<U64>(low: 12297829382473034411, high: 12297829382473034410), add: false, shr: U64(128 + 1)),
            
            (div: U8 ( 4), mul: Doublet<U64>(low:                  255, high:                  255), add: true,  shr: U64( 16 + 2)),
            (div: U16( 4), mul: Doublet<U64>(low:                65535, high:                65535), add: true,  shr: U64( 32 + 2)),
            (div: U32( 4), mul: Doublet<U64>(low:           4294967295, high:           4294967295), add: true,  shr: U64( 64 + 2)),
            (div: U64( 4), mul: Doublet<U64>(low: 18446744073709551615, high: 18446744073709551615), add: true,  shr: U64(128 + 2)),

            (div: U8 ( 5), mul: Doublet<U64>(low:                  205, high:                  204), add: false, shr: U64( 16 + 2)),
            (div: U16( 5), mul: Doublet<U64>(low:                52429, high:                52428), add: false, shr: U64( 32 + 2)),
            (div: U32( 5), mul: Doublet<U64>(low:           3435973837, high:           3435973836), add: false, shr: U64( 64 + 2)),
            (div: U64( 5), mul: Doublet<U64>(low: 14757395258967641293, high: 14757395258967641292), add: false, shr: U64(128 + 2)),
            
            (div: U8 ( 6), mul: Doublet<U64>(low:                  171, high:                  170), add: false, shr: U64( 16 + 2)),
            (div: U16( 6), mul: Doublet<U64>(low:                43691, high:                43690), add: false, shr: U64( 32 + 2)),
            (div: U32( 6), mul: Doublet<U64>(low:           2863311531, high:           2863311530), add: false, shr: U64( 64 + 2)),
            (div: U64( 6), mul: Doublet<U64>(low: 12297829382473034411, high: 12297829382473034410), add: false, shr: U64(128 + 2)),
            
            (div: U8 ( 7), mul: Doublet<U64>(low:                   73, high:                  146), add: true,  shr: U64( 16 + 2)),
            (div: U16( 7), mul: Doublet<U64>(low:                 9362, high:                37449), add: true,  shr: U64( 32 + 2)),
            (div: U32( 7), mul: Doublet<U64>(low:           1227133513, high:           2454267026), add: true,  shr: U64( 64 + 2)),
            (div: U64( 7), mul: Doublet<U64>(low:  2635249153387078802, high: 10540996613548315209), add: true,  shr: U64(128 + 2)),
            
            (div: U8 ( 8), mul: Doublet<U64>(low:                  255, high:                  255), add: true,  shr: U64( 16 + 3)),
            (div: U16( 8), mul: Doublet<U64>(low:                65535, high:                65535), add: true,  shr: U64( 32 + 3)),
            (div: U32( 8), mul: Doublet<U64>(low:           4294967295, high:           4294967295), add: true,  shr: U64( 64 + 3)),
            (div: U64( 8), mul: Doublet<U64>(low: 18446744073709551615, high: 18446744073709551615), add: true,  shr: U64(128 + 3)),
            
            (div: U8 ( 9), mul: Doublet<U64>(low:                  142, high:                  227), add: true,  shr: U64( 16 + 3)),
            (div: U16( 9), mul: Doublet<U64>(low:                14563, high:                58254), add: true,  shr: U64( 32 + 3)),
            (div: U32( 9), mul: Doublet<U64>(low:           2386092942, high:           3817748707), add: true,  shr: U64( 64 + 3)),
            (div: U64( 9), mul: Doublet<U64>(low:  4099276460824344803, high: 16397105843297379214), add: true,  shr: U64(128 + 3)),
            
            (div: U8 (10), mul: Doublet<U64>(low:                  205, high:                  204), add: false, shr: U64( 16 + 3)),
            (div: U16(10), mul: Doublet<U64>(low:                52429, high:                52428), add: false, shr: U64( 32 + 3)),
            (div: U32(10), mul: Doublet<U64>(low:           3435973837, high:           3435973836), add: false, shr: U64( 64 + 3)),
            (div: U64(10), mul: Doublet<U64>(low: 14757395258967641293, high: 14757395258967641292), add: false, shr: U64(128 + 3)),
            
            (div: U8 (11), mul: Doublet<U64>(low:                   46, high:                  186), add: true,  shr: U64( 16 + 3)),
            (div: U16(11), mul: Doublet<U64>(low:                35747, high:                47662), add: false, shr: U64( 32 + 3)),
            (div: U32(11), mul: Doublet<U64>(low:           3904515723, high:           3123612578), add: true,  shr: U64( 64 + 3)),
            (div: U64(11), mul: Doublet<U64>(low: 11738837137815169210, high: 13415813871788764811), add: true,  shr: U64(128 + 3)),
            
            (div: U8 (12), mul: Doublet<U64>(low:                  171, high:                  170), add: false, shr: U64( 16 + 3)),
            (div: U16(12), mul: Doublet<U64>(low:                43691, high:                43690), add: false, shr: U64( 32 + 3)),
            (div: U32(12), mul: Doublet<U64>(low:           2863311531, high:           2863311530), add: false, shr: U64( 64 + 3)),
            (div: U64(12), mul: Doublet<U64>(low: 12297829382473034411, high: 12297829382473034410), add: false, shr: U64(128 + 3)),
            
        ] as [(
        div: any SystemsIntegerAsUnsigned, mul: Doublet<U64>, add: Bool, shr: U64
    )]) func examplesFrom1Through12(
        div: any SystemsIntegerAsUnsigned, mul: Doublet<U64>, add: Bool, shr: U64
    )   throws {
        
        try  whereIs(div)
        func whereIs<T>(_ div: T) throws where T: SystemsIntegerAsUnsigned {
            let divider = try #require(Divider21(exactly: div))
            
            #expect(divider.div      == (div))
            #expect(divider.mul.low  == (mul).low )
            #expect(divider.mul.high == (mul).high)
            #expect(divider.add.low  == (add ? mul.low  : 0))
            #expect(divider.add.high == (add ? mul.high : 0))
            #expect(divider.shr      == (shr))
        }
    }
}
