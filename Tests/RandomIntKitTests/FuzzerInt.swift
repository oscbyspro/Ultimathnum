//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import RandomIntKit
import TestKit

//*============================================================================*
// MARK: * Fuzzer Int
//*============================================================================*

final class FuzzerIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSeeds() {
        var randomness: FuzzerInt
        
        randomness = .init(seed:  0)
        Test().same(randomness.next(), 16294208416658607535)
        Test().same(randomness.next(), 07960286522194355700)
        Test().same(randomness.next(), 00487617019471545679)
        Test().same(randomness.next(), 17909611376780542444)
        
        randomness = .init(seed:  1)
        Test().same(randomness.next(), 10451216379200822465)
        Test().same(randomness.next(), 13757245211066428519)
        Test().same(randomness.next(), 17911839290282890590)
        Test().same(randomness.next(), 08196980753821780235)
        
        randomness = .init(seed: ~1)
        Test().same(randomness.next(), 17519071339639777313)
        Test().same(randomness.next(), 13427082724269423081)
        Test().same(randomness.next(), 15047954047655532813)
        Test().same(randomness.next(), 02229658653670313015)
        
        randomness = .init(seed: ~0)
        Test().same(randomness.next(), 16490336266968443936)
        Test().same(randomness.next(), 16834447057089888969)
        Test().same(randomness.next(), 04048727598324417001)
        Test().same(randomness.next(), 07862637804313477842)
        
        randomness = .init(seed:  0)
        var unique = Set<U64>()
        
        for _ in 0 ..< 10000 {
            unique.insert(randomness.next())
        }
        
        Test().same(unique.count, 0000000000000000000010000)
    }
}
