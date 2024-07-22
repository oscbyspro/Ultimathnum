//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Random
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Generates random bits through the given `index`.
    ///
    /// Signed integers are extended by the most significant bit wheras unsigned
    /// integer are extended by zero. You may bit cast a different type to adopt
    /// its behavior.
    ///
    ///                ┌──────────┬──────────┬──────────┐
    ///                │ index: 0 │ index: 1 │ index: 2 │
    ///     ┌──────────┼──────────┤──────────┤──────────┤
    ///     │   Signed │ -1 ... 0 │ -2 ... 1 │ -4 ... 3 │
    ///     ├──────────┼──────────┤──────────┤──────────┤
    ///     │ Unsigned │  0 ... 1 │  0 ... 3 │  0 ... 7 │
    ///     └──────────┴──────────┴──────────┴──────────┘
    ///
    /// - Note: The result is always finite.
    ///
    /// - Note: The default randomness is `RandomInt`.
    ///
    /// - Requires: The request must not exceed the entropy limit.
    ///
    @inlinable public static func random(through index: Shift<Magnitude>, using randomness: inout some Randomness) -> Self {
        guard let index = index.natural().optional() else {
            Swift.preconditionFailure(String.indexOutOfBounds())
        }
        
        if  let size = IX(size: Self.self) {
            var instance: Self
            //  fast path
            if  size == IX(size: Element.self) {
                instance = Self(load: randomness.next(as: Element.Magnitude.self))
            }   else {
                instance = Self.zero
                instance.withUnsafeMutableBinaryIntegerBody { body -> Void in
                    randomness.fill(body.bytes())
                }
            }
            
            let mask = size.decremented().unchecked()
            let down = Count(unchecked: mask & index.toggled())
            return instance.down(Shift(unchecked: down))
            
        }   else {
            var division = index.division(Divisor(size: Element.self)).unchecked()
            //  finite unsigned behavior
            increment: if !Self.isSigned {
                division.remainder &+= 1
                guard division.remainder == IX(size: Element.self) else { break increment }
                division.quotient  &+= 1
                division.remainder   = 0
            }
            
            let down = Shift<Element.Magnitude>(masking: division.remainder.complement())
            let last = Element.Magnitude(raw: Element(raw: randomness.next(as: Element.Magnitude.self)).down(down))

            let capacity = division.ceil().unchecked()
            let appendix = Element(raw: last).appendix
            
            return Self.arbitrary(uninitialized: capacity, repeating: appendix) { body -> Void in
                guard !capacity.isZero else { return }
                let lastIndex = capacity.decremented().unchecked()
                randomness.fill(body[unchecked: ..<lastIndex].bytes())
                body[unchecked: lastIndex] = last
            }!
        }
    }
}
