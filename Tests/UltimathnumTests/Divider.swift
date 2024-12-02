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
        "Divider: examples",
        Tag.List.tags(.generic),
        ParallelizationTrait.serialized,
        arguments: Array<(any SystemsIntegerAsUnsigned, U64, Bool, U64)>.infer([
        
        (U8 ( 1), U64(                 255), true,  U64( 8 + 0)),
        (U16( 1), U64(               65535), true,  U64(16 + 0)),
        (U32( 1), U64(          4294967295), true,  U64(32 + 0)),
        (U64( 1), U64(18446744073709551615), true,  U64(64 + 0)),
        
        (U8 ( 2), U64(                 255), true,  U64( 8 + 1)),
        (U16( 2), U64(               65535), true,  U64(16 + 1)),
        (U32( 2), U64(          4294967295), true,  U64(32 + 1)),
        (U64( 2), U64(18446744073709551615), true,  U64(64 + 1)),
        
        (U8 ( 3), U64(                 171), false, U64( 8 + 1)),
        (U16( 3), U64(               43691), false, U64(16 + 1)),
        (U32( 3), U64(          2863311531), false, U64(32 + 1)),
        (U64( 3), U64(12297829382473034411), false, U64(64 + 1)),
        
        (U8 ( 4), U64(                 255), true,  U64( 8 + 2)),
        (U16( 4), U64(               65535), true,  U64(16 + 2)),
        (U32( 4), U64(          4294967295), true,  U64(32 + 2)),
        (U64( 4), U64(18446744073709551615), true,  U64(64 + 2)),
        
        (U8 ( 5), U64(                 205), false, U64( 8 + 2)),
        (U16( 5), U64(               52429), false, U64(16 + 2)),
        (U32( 5), U64(          3435973837), false, U64(32 + 2)),
        (U64( 5), U64(14757395258967641293), false, U64(64 + 2)),
        
        (U8 ( 6), U64(                 171), false, U64( 8 + 2)),
        (U16( 6), U64(               43691), false, U64(16 + 2)),
        (U32( 6), U64(          2863311531), false, U64(32 + 2)),
        (U64( 6), U64(12297829382473034411), false, U64(64 + 2)),
        
        (U8 ( 7), U64(                 146), true,  U64( 8 + 2)),
        (U16( 7), U64(               37449), true,  U64(16 + 2)),
        (U32( 7), U64(          2454267026), true,  U64(32 + 2)),
        (U64( 7), U64(10540996613548315209), true,  U64(64 + 2)),
        
        (U8 ( 8), U64(                 255), true,  U64( 8 + 3)),
        (U16( 8), U64(               65535), true,  U64(16 + 3)),
        (U32( 8), U64(          4294967295), true,  U64(32 + 3)),
        (U64( 8), U64(18446744073709551615), true,  U64(64 + 3)),
        
        (U8 ( 9), U64(                 227), true,  U64( 8 + 3)),
        (U16( 9), U64(               58254), true,  U64(16 + 3)),
        (U32( 9), U64(          3817748707), true,  U64(32 + 3)),
        (U64( 9), U64(16397105843297379214), true,  U64(64 + 3)),
        
        (U8 (10), U64(                 205), false, U64( 8 + 3)),
        (U16(10), U64(               52429), false, U64(16 + 3)),
        (U32(10), U64(          3435973837), false, U64(32 + 3)),
        (U64(10), U64(14757395258967641293), false, U64(64 + 3)),
        
        (U8 (11), U64(                 186), true,  U64( 8 + 3)),
        (U16(11), U64(               47662), true,  U64(16 + 3)),
        (U32(11), U64(          3123612579), false, U64(32 + 3)),
        (U64(11), U64(13415813871788764811), true,  U64(64 + 3)),
        
        (U8 (12), U64(                 171), false, U64( 8 + 3)),
        (U16(12), U64(               43691), false, U64(16 + 3)),
        (U32(12), U64(          2863311531), false, U64(32 + 3)),
        (U64(12), U64(12297829382473034411), false, U64(64 + 3)),
        
    ])) func examples(
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
        "Divider21: examples",
        Tag.List.tags(.generic),
        ParallelizationTrait.serialized,
        arguments: Array<(any SystemsIntegerAsUnsigned, Doublet<U64>, Bool, U64)>.infer([
            
        (U8 ( 1), Doublet<U64>(low:                  255, high:                  255), true,  U64( 16 + 0)),
        (U16( 1), Doublet<U64>(low:                65535, high:                65535), true,  U64( 32 + 0)),
        (U32( 1), Doublet<U64>(low:           4294967295, high:           4294967295), true,  U64( 64 + 0)),
        (U64( 1), Doublet<U64>(low: 18446744073709551615, high: 18446744073709551615), true,  U64(128 + 0)),
        
        (U8 ( 2), Doublet<U64>(low:                  255, high:                  255), true,  U64( 16 + 1)),
        (U16( 2), Doublet<U64>(low:                65535, high:                65535), true,  U64( 32 + 1)),
        (U32( 2), Doublet<U64>(low:           4294967295, high:           4294967295), true,  U64( 64 + 1)),
        (U64( 2), Doublet<U64>(low: 18446744073709551615, high: 18446744073709551615), true,  U64(128 + 1)),

        (U8 ( 3), Doublet<U64>(low:                  171, high:                  170), false, U64( 16 + 1)),
        (U16( 3), Doublet<U64>(low:                43691, high:                43690), false, U64( 32 + 1)),
        (U32( 3), Doublet<U64>(low:           2863311531, high:           2863311530), false, U64( 64 + 1)),
        (U64( 3), Doublet<U64>(low: 12297829382473034411, high: 12297829382473034410), false, U64(128 + 1)),
        
        (U8 ( 4), Doublet<U64>(low:                  255, high:                  255), true,  U64( 16 + 2)),
        (U16( 4), Doublet<U64>(low:                65535, high:                65535), true,  U64( 32 + 2)),
        (U32( 4), Doublet<U64>(low:           4294967295, high:           4294967295), true,  U64( 64 + 2)),
        (U64( 4), Doublet<U64>(low: 18446744073709551615, high: 18446744073709551615), true,  U64(128 + 2)),

        (U8 ( 5), Doublet<U64>(low:                  205, high:                  204), false, U64( 16 + 2)),
        (U16( 5), Doublet<U64>(low:                52429, high:                52428), false, U64( 32 + 2)),
        (U32( 5), Doublet<U64>(low:           3435973837, high:           3435973836), false, U64( 64 + 2)),
        (U64( 5), Doublet<U64>(low: 14757395258967641293, high: 14757395258967641292), false, U64(128 + 2)),
        
        (U8 ( 6), Doublet<U64>(low:                  171, high:                  170), false, U64( 16 + 2)),
        (U16( 6), Doublet<U64>(low:                43691, high:                43690), false, U64( 32 + 2)),
        (U32( 6), Doublet<U64>(low:           2863311531, high:           2863311530), false, U64( 64 + 2)),
        (U64( 6), Doublet<U64>(low: 12297829382473034411, high: 12297829382473034410), false, U64(128 + 2)),
        
        (U8 ( 7), Doublet<U64>(low:                   73, high:                  146), true,  U64( 16 + 2)),
        (U16( 7), Doublet<U64>(low:                 9362, high:                37449), true,  U64( 32 + 2)),
        (U32( 7), Doublet<U64>(low:           1227133513, high:           2454267026), true,  U64( 64 + 2)),
        (U64( 7), Doublet<U64>(low:  2635249153387078802, high: 10540996613548315209), true,  U64(128 + 2)),
        
        (U8 ( 8), Doublet<U64>(low:                  255, high:                  255), true,  U64( 16 + 3)),
        (U16( 8), Doublet<U64>(low:                65535, high:                65535), true,  U64( 32 + 3)),
        (U32( 8), Doublet<U64>(low:           4294967295, high:           4294967295), true,  U64( 64 + 3)),
        (U64( 8), Doublet<U64>(low: 18446744073709551615, high: 18446744073709551615), true,  U64(128 + 3)),
        
        (U8 ( 9), Doublet<U64>(low:                  142, high:                  227), true,  U64( 16 + 3)),
        (U16( 9), Doublet<U64>(low:                14563, high:                58254), true,  U64( 32 + 3)),
        (U32( 9), Doublet<U64>(low:           2386092942, high:           3817748707), true,  U64( 64 + 3)),
        (U64( 9), Doublet<U64>(low:  4099276460824344803, high: 16397105843297379214), true,  U64(128 + 3)),
        
        (U8 (10), Doublet<U64>(low:                  205, high:                  204), false, U64( 16 + 3)),
        (U16(10), Doublet<U64>(low:                52429, high:                52428), false, U64( 32 + 3)),
        (U32(10), Doublet<U64>(low:           3435973837, high:           3435973836), false, U64( 64 + 3)),
        (U64(10), Doublet<U64>(low: 14757395258967641293, high: 14757395258967641292), false, U64(128 + 3)),
        
        (U8 (11), Doublet<U64>(low:                   46, high:                  186), true,  U64( 16 + 3)),
        (U16(11), Doublet<U64>(low:                35747, high:                47662), false, U64( 32 + 3)),
        (U32(11), Doublet<U64>(low:           3904515723, high:           3123612578), true,  U64( 64 + 3)),
        (U64(11), Doublet<U64>(low: 11738837137815169210, high: 13415813871788764811), true,  U64(128 + 3)),
        
        (U8 (12), Doublet<U64>(low:                  171, high:                  170), false, U64( 16 + 3)),
        (U16(12), Doublet<U64>(low:                43691, high:                43690), false, U64( 32 + 3)),
        (U32(12), Doublet<U64>(low:           2863311531, high:           2863311530), false, U64( 64 + 3)),
        (U64(12), Doublet<U64>(low: 12297829382473034411, high: 12297829382473034410), false, U64(128 + 3)),
            
    ])) func examplesFrom1Through12(
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
