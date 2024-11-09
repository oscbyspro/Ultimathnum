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
// MARK: * Bit
//*============================================================================*

@Suite(.serialized) struct BitTests {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Bit: as Bit",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bit)>([
        
        (Bit.zero, Bit.zero),
        (Bit.one,  Bit.one ),
        
    ])) func bit(source: Bit, destination: Bit) {
        
        #expect(type(of: source).init(     destination) == source)
        #expect(type(of: source).init(raw: destination) == source)
        
        #expect(type(of: destination).init(     source) == destination)
        #expect(type(of: destination).init(raw: source) == destination)
    }
    
    @Test(
        "Bit: as Bool",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Bool)>([
        
        (Bit.zero, false),
        (Bit.one,  true ),
        
    ])) func bool(source: Bit, destination: Bool) {
        
        #expect(type(of: source).init(     destination) == source)
        #expect(type(of: source).init(raw: destination) == source)
        
        #expect(type(of: destination).init(     source) == destination)
        #expect(type(of: destination).init(raw: source) == destination)
    }
    
    @Test(
        "Bit: as Order",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Order)>([
        
        (Bit.zero, Order.ascending ),
        (Bit.one,  Order.descending),
        
    ])) func sign(source: Bit, destination: Order) {
        
        #expect(type(of: source).init(     destination) == source)
        #expect(type(of: source).init(raw: destination) == source)
        
        #warning("todo")
//      #expect(type(of: destination).init(     source) == destination)
        #expect(type(of: destination).init(raw: source) == destination)
    }
    
    @Test(
        "Bit: as Sign",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Sign)>([
        
        (Bit.zero, Sign.plus ),
        (Bit.one,  Sign.minus),
        
    ])) func sign(source: Bit, destination: Sign) {
        
        #expect(type(of: source).init(     destination) == source)
        #expect(type(of: source).init(raw: destination) == source)
        
        #expect(type(of: destination).init(     source) == destination)
        #expect(type(of: destination).init(raw: source) == destination)
    }
    
    @Test(
        "Bit: as Signedness",
        Tag.List.tags(.documentation, .exhaustive),
        ParallelizationTrait.serialized,
        arguments: Array<(Bit, Signedness)>([
        
        (Bit.zero, Signedness.unsigned),
        (Bit.one,  Signedness  .signed),
        
    ])) func signedness(source: Bit, destination: Signedness) {
        
        #expect(type(of: source).init(     destination) == source)
        #expect(type(of: source).init(raw: destination) == source)
        
        #warning("todo")
//      #expect(type(of: destination).init(     source) == destination)
        #expect(type(of: destination).init(raw: source) == destination)
    }
}
