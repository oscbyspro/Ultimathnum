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

final class BenchmarksAboutDoubleInt: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// ###### 2024-07-05 (MacBook Pro, 13-inch, M1, 2020):
    ///
    /// - `1.665 seconds`
    /// - `0.881 seconds` with pointer-bit shifts
    /// - `0.308 seconds` with pointer-bit shifts and literals
    ///
    func testGreatestCommonDivisorOfFibonacciSequencePair369() throws {
        #if DEBUG
        throw XCTSkip("benchmark")
        #else
        let fib369 = U256("58472848379039952684853851736901133239741266891456844557261755914039063645794")!
        let fib370 = U256("94611056096305838013295371573764256526437182762229865607320618320601813254535")!
        
        for _ in 0 ..< 369 * 100 {
            var lhs = blackHoleIdentity(fib369)
            var rhs = blackHoleIdentity(fib370)
            var counter = 0
            
            dividing: while !rhs.isZero {
                counter += 1
                (lhs, rhs) = (rhs, lhs.remainder(Divisor(unchecked: rhs)))
            }
            
            precondition(lhs == 1)
            precondition(rhs == 0)
            precondition(counter == 369)
        }
        #endif
    }
}
