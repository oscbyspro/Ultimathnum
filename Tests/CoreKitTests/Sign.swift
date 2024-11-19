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
// MARK: * Sign
//*============================================================================*

@Suite(.serialized) struct SignTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Sign: init()",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: CollectionOfOne(Sign.plus)
    )   func unspecified(expectation: Sign) {
        #expect(Sign() == expectation)
        #expect(Sign(raw: Bit.zero) == expectation)
    }
    
    @Test(
        "Sign: as Bit",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Sign, Bit)>.infer([
        
        (sign: Sign.plus,  bit: Bit.zero),
        (sign: Sign.minus, bit: Bit.one ),
        
    ])) func bit(source: Sign, destination: Bit) {
        #expect(type(of: destination).init(     source) == destination)
        #expect(type(of: destination).init(raw: source) == destination)
        #expect(type(of: source).init(     destination) == source)
        #expect(type(of: source).init(raw: destination) == source)
    }
    
    @Test(
        "Sign: as Bool",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Sign, Bool)>.infer([
        
        (sign: Sign.plus,  bool: false),
        (sign: Sign.minus, bool: true ),
        
    ])) func bool(source: Sign, destination: Bool) {
        #expect(type(of: destination).init(     source) == destination)
        #expect(type(of: destination).init(raw: source) == destination)
        #expect(type(of: source).init(     destination) == source)
        #expect(type(of: source).init(raw: destination) == source)
    }
    
    @Test(
        "Sign: as Stdlib",
        Tag.List.tags(.documentation, .exhaustive),
        arguments: Array<(Sign, FloatingPointSign)>.infer([
        
        (sign: Sign.plus,  stdlib: FloatingPointSign.plus ),
        (sign: Sign.minus, stdlib: FloatingPointSign.minus),
        
    ])) func stdlib(source: Sign,  destination: FloatingPointSign) {
        #expect(source.stdlib() == destination)
        #expect(type(of: destination).init(     source) == destination)
        #expect(type(of: destination).init(raw: source) == destination)
        #expect(type(of: source).init(     destination) == source)
        #expect(type(of: source).init(raw: destination) == source)
    }
}
