//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Test x Validation
//*============================================================================*

extension Test {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    public func exactly<Input, Output>(
        _ input: Input,
        _ expectation: Fallible<Output>
    )   where Input: BinaryInteger, Output: BinaryInteger {
        //=--------------------------------------=
        same(Output.exactly(input), expectation, "T.exactly(some BinaryInteger)")
        //=--------------------------------------=
        always: do {
            let sign = Sign(input.isNegative)
            let magnitude = input.magnitude()
            same(Output.exactly(sign: sign, magnitude: magnitude), expectation, "T.exactly(sign:magnitude:)")
            
            if !expectation.error {
                same(Output(sign: sign, magnitude: magnitude), expectation.value, "T(sign:magnitude:)")
            }
        }
        //=--------------------------------------=
        input.withUnsafeBinaryIntegerBody {
            let body = Array($0.buffer())
            self.exactly(body, Input.mode, expectation)
        }
        
        input.withUnsafeBinaryIntegerElements {
            same(Output.exactly($0, mode: Input.mode), expectation, "Integer.exactly(_:mode:) [0]")
        }
        
        input.withUnsafeBinaryIntegerElementsAsBytes {
            same(Output.exactly($0, mode: Input.mode), expectation, "Integer.exactly(_:mode:) [1]")
        }
    }
}
