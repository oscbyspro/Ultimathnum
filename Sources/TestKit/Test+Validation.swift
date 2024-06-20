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
        // path: binary integer
        //=--------------------------------------=
        always: do {
            same(Output.exactly(input), expectation, "T.exactly(_:)")

            if !expectation.error {
                same(Output(input), expectation.value, "T.init(_:)")
            }
        }
            
        clamping: if let clamped = Output(clamping: input) {
            if !expectation.error {
                same(clamped, expectation.value, "T.init(clamping:)")
            }   else if input.isNegative {
                yay(clamped.decremented().error, "T.init(clamping:) - min")
            }   else {
                yay(clamped.incremented().error, "T.init(clamping:) - max")
            }
        }   else {
            yay(Output.isSigned && input.isInfinite, "arbitrary signed integers cannot clamp infinite values")
        }
        //=--------------------------------------=
        // path: sign and magnitude
        //=--------------------------------------=
        always: do {
            let sign = Sign(input.isNegative)
            let magnitude = input.magnitude()
            same(Output.exactly(sign: sign, magnitude: magnitude), expectation, "T.exactly(sign:magnitude:)")
            
            if !expectation.error {
                same(Output(sign: sign, magnitude: magnitude), expectation.value,  "T.init(sign:magnitude:)")
            }
        }
        
        if !input.isNegative {
            let magnitude = Input.Magnitude(input)
            same(Output.exactly(magnitude: magnitude), expectation, "T.exactly(magnitude:)")
            
            if !expectation.error {
                same(Output(magnitude: magnitude), expectation.value,  "T.init(magnitude:)")
            }
        }
        //=--------------------------------------=
        // path: elements
        //=--------------------------------------=
        input.withUnsafeBinaryIntegerElements {
            same(Output.exactly($0, mode: Input.mode), expectation, "T.exactly(_:mode:) [0]")
        }
        
        input.withUnsafeBinaryIntegerElements(as: U8.self) {
            same(Output.exactly($0, mode: Input.mode), expectation, "T.exactly(_:mode:) [1]")
        }
        //=--------------------------------------=
        // path: body when compact or no appendix
        //=--------------------------------------=
        if !Input.size.isInfinite || !Bool(input.appendix) {
            input.withUnsafeBinaryIntegerBody {
                self.exactly(Array($0.buffer()), Input.mode, expectation)
            }
        }
    }
}
