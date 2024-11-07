//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit
import DoubleIntKit
import TestKit

//*============================================================================*
// MARK: * Double Int
//*============================================================================*

final class DoubleIntBenchmarks: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// ###### 2024-07-05 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `1.67 seconds`
    /// - `0.88 seconds` with pointer-bit shifts
    /// - `0.30 seconds` with pointer-bit shifts and literals
    ///
    func testGreatestCommonDivisorOfFibonacciSequencePair369() {
        let fib369 = U256("58472848379039952684853851736901133239741266891456844557261755914039063645794")!
        let fib370 = U256("94611056096305838013295371573764256526437182762229865607320618320601813254535")!
        
        for _ in 0 ..< 369 * 100 {
            let lhs = blackHoleIdentity(fib369)
            let rhs = blackHoleIdentity(fib370)
            blackHole(lhs.euclidean(rhs))
        }
    }
}
