//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Text Int x Metadata
//*============================================================================*

extension TextInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// Magic constants for capacity estimations.
    ///
    ///     000000: 32 // multiplier
    ///     000001: 05 // multiplier shift
    ///     2...32: floor(32 * log2(radix))
    ///
    /// - Note: The `multiplier` adds `5` bits of precision.
    ///
    /// - Note: Using `floor` gives pessimistic estimations.
    ///
    /// - Note: `37` bytes is a good price for good results.
    ///
    /// - Note: Good results let us fit more (small) numbers on the stack.
    ///
    /// ### Capacity
    ///
    /// ```swift
    /// ceil(32 * length / magicLog2x32[radix]) // floating-point
    /// ```
    ///
    /// ### Comments
    ///
    /// Google's open source JavaScript engine, V8, does something similar but
    /// with different numbers. I believe they use `ceil(x)` instead of `floor(x)`
    /// at the time of writing. In any case, the equivalent run-time computation
    /// is straightforward (but less performant).
    ///
    @usableFromInline package static let magicLog2x32: [U8] = [
        032, 005, 032, 050, 064, 074, 082, 089,
        096, 101, 106, 110, 114, 118, 121, 125,
        128, 130, 133, 135, 138, 140, 142, 144,
        146, 148, 150, 152, 153, 155, 157, 158,
        160, 161, 162, 164, 165
    ]
    
    /// Estimates the `capacity` for the given `radix` and `length`.
    ///
    /// - Note: It may fail early due to 1-by-1-as-1 arithmetic (performance).
    ///
    /// ### Development
    ///
    /// - Todo: Consider double-width arithmetic (it is probably unnecessary).
    ///
    @inlinable package static func capacity(_ radix: IX, length: Natural<IX>) -> Optional<IX> {
        Swift.assert(radix >= 02)
        Swift.assert(radix <= 36)

        if  length.value.isZero { return 1 }
        let dividend = length.value.times(IX(Self.magicLog2x32[Swift.Int(00000)]))
        guard let dividend = dividend.optional() else { return nil }
        let divisor  = Nonzero(unchecked: IX(Self.magicLog2x32[Swift.Int(radix)]))
        return dividend.division(divisor).unchecked().ceil().unchecked()
    }
}
