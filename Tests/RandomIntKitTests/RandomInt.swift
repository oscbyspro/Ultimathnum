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
// MARK: * Random Int
//*============================================================================*

final class RandomIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMetadata() {
        Test().yay(RandomInt.self as Any is any Randomness.Type)
        Test().yay(RandomInt.Stdlib.self as Any is any Swift.RandomNumberGenerator.Type)
    }
    
    func testStdlib() {
        let randomness = RandomInt(Swift.SystemRandomNumberGenerator())
        let stdlib: Swift.SystemRandomNumberGenerator = randomness.stdlib()
        Test().same(MemoryLayout.size(ofValue: randomness), Swift.Int.zero)
        Test().same(MemoryLayout.size(ofValue:     stdlib), Swift.Int.zero)
    }
}
