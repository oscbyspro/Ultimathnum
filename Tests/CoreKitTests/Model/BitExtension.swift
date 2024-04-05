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
// MARK: * Bit x Extension
//*============================================================================*

final class BitExtensionTests: XCTestCase {
    
    typealias T = BitExtension
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInvariants() {
        Test().invariants(T<IX>.self, BitCastableID())
        Test().invariants(T<UX>.self, BitCastableID())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitOtherInstance() {
        for bit: Bit in [0, 1] {
            Test().same(T<I64>(repeating: T<U64>(repeating: bit)), T(repeating: bit))
            Test().same(T<I64>(repeating: T<I64>(repeating: bit)), T(repeating: bit))
            Test().same(T<U64>(repeating: T<U64>(repeating: bit)), T(repeating: bit))
            Test().same(T<U64>(repeating: T<I64>(repeating: bit)), T(repeating: bit))
            
            Test().same(T<I64>(repeating: T<U32>(repeating: bit)), T(repeating: bit))
            Test().same(T<I64>(repeating: T<I32>(repeating: bit)), T(repeating: bit))
            Test().same(T<U64>(repeating: T<U32>(repeating: bit)), T(repeating: bit))
            Test().same(T<U64>(repeating: T<I32>(repeating: bit)), T(repeating: bit))
            
            Test().same(T<I32>(repeating: T<U64>(repeating: bit)), T(repeating: bit))
            Test().same(T<I32>(repeating: T<I64>(repeating: bit)), T(repeating: bit))
            Test().same(T<U32>(repeating: T<U64>(repeating: bit)), T(repeating: bit))
            Test().same(T<U32>(repeating: T<I64>(repeating: bit)), T(repeating: bit))
            
            Test().same(T<I32>(repeating: T<U32>(repeating: bit)), T(repeating: bit))
            Test().same(T<I32>(repeating: T<I32>(repeating: bit)), T(repeating: bit))
            Test().same(T<U32>(repeating: T<U32>(repeating: bit)), T(repeating: bit))
            Test().same(T<U32>(repeating: T<I32>(repeating: bit)), T(repeating: bit))
        }
    }
}
