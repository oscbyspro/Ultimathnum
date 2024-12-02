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
// MARK: * Fallible
//*============================================================================*

@Suite struct FallibleTests {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible: Optional<Self> has same memory layout",
        Tag.List.tags(.documentation, .important)
    )   func optionalInstanceHasSameMemoryLayout() {
        
        whereIs(Bool.self)
        whereIs(Void.self)
        
        for type in typesAsCoreInteger {
            whereIs(type)
        }
        
        func whereIs<T>(_ type: T.Type) {
            typealias A = MemoryLayout<Fallible<T>>
            typealias B = MemoryLayout<Optional<Fallible<T>>>
            Ɣexpect(A.self, equals: B.self)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    @Test(
        "Fallible: Self.init(_:)",
        Tag.List.tags(.exhaustive),
        arguments: Bit.all
    )   func fromValue(value: Bit) {
        #expect(Fallible(value).value == value)
        #expect(Fallible(value).error == false)
    }
    
    @Test(
        "Fallible: Self.init(_:error:)",
        Tag.List.tags(.exhaustive),
        arguments: Bit.all, Bool.all
    )   func fromValueWithError(value: Bit, error: Bool) {
        #expect(Fallible(value, error: error).value == value)
        #expect(Fallible(value, error: error).error == error)
    }
    
    @Test(
        "Fallible: Self.init(raw:)",
        Tag.List.tags(.exhaustive),
        arguments: Array<(Fallible<Bit>, Fallible<Sign>)>.infer([
            
        (Fallible(Bit.zero, error: false), Fallible(Sign.plus,  error: false)),
        (Fallible(Bit.zero, error: true ), Fallible(Sign.plus,  error: true )),
        (Fallible(Bit.one,  error: false), Fallible(Sign.minus, error: false)),
        (Fallible(Bit.one,  error: true ), Fallible(Sign.minus, error: true )),
            
    ])) func bitcasting(source: Fallible<Bit>, destination: Fallible<Sign>) {
        #expect(Fallible(raw: source) == destination)
        #expect(Fallible(raw: destination) == source)
    }
    
    @Test(
        "Fallible: Self/components()",
        Tag.List.tags(.exhaustive)
    )   func accessors() {
        var instance = Fallible(Bit.zero, error: false)
        
        #expect( instance.value.isZero)
        #expect(!instance.error)
        #expect( instance.components() == (Bit.zero, false))
        
        instance.value.toggle()
        instance.error.toggle()
        
        #expect(!instance.value.isZero)
        #expect( instance.error)
        #expect( instance.components() == (Bit.one,  true ))
    }
}
