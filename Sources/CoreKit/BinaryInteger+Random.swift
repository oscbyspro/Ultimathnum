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
    // MARK: Initializers
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
    /// - Requires: The request must not exceed the entropy limit.
    ///
    @inlinable public static func random(through index: Shift<Magnitude>, using randomness: inout some Randomness) -> Self {
        guard let index: IX = index.natural().optional() else {
            Swift.preconditionFailure(String.indexOutOfBounds())
        }
        
        if  let size = IX(size: Self.self) {
            let instance = if size == IX(size: Element.self) {
                Self(load: randomness.next(as: Element.Magnitude.self))
            }   else {
                Self.systems { randomness.fill($0.bytes()) }!
            }
            
            let mask = size.decremented().unchecked()
            let down = Count(unchecked: mask & index.toggled())
            return instance.down(Shift(unchecked: down))
            
        }   else {
            let divisor  = Divisor<IX>(size: Element.self)
            var division = index.division(divisor).unchecked()
            //  finite unsigned behavior
            increment: if !Self.isSigned {
                division.remainder &+= 1
                guard division.remainder == divisor.value else { break increment }
                division.quotient  &+= 1
                division.remainder   = 0
            }
            
            let down = Shift<Element.Magnitude>(masking: division.remainder.complement())
            let last = Element(raw:  randomness.next(as: Element.Magnitude.self)).down(down)
            return Self.arbitrary(uninitialized: division.ceil().unchecked(), repeating: last.appendix) {
                guard !$0.isEmpty else { return }
                let lastIndex: IX = $0.count.decremented().unchecked()
                randomness.fill($0[unchecked:   ..<lastIndex].bytes())
                $0[unchecked: lastIndex] = Element.Magnitude(raw: last)
            }!
        }
    }
}

//*============================================================================*
// MARK: * Binary Integer x Random x Systems
//*============================================================================*
//=----------------------------------------------------------------------------=
// TODO: + Hoist to Binary Integer
//=----------------------------------------------------------------------------=

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Generates a random value from the given source of `randomness`.
    @inlinable public static func random(using randomness: inout some Randomness) -> Self {
        Self(raw: randomness.next(as: Magnitude.self))
    }
    
    /// Generates a random value in the given `range` from the given source of `randomness`.
    @inlinable public static func random(in range: ClosedRange<Self>, using randomness: inout some Randomness) -> Self {
        let distance = Magnitude(raw: range.upperBound &- range.lowerBound)
        return range.lowerBound &+ Self(raw: randomness.next(through: distance))
    }
    
    /// Generates a random value in the given `range` from the given source of `randomness`.
    @inlinable public static func random(in range: Range<Self>, using randomness: inout some Randomness) -> Optional<Self> {
        let distance = Magnitude(raw: range.upperBound &- range.lowerBound)
        guard let distance = Divisor(exactly: distance) else { return nil }
        return range.lowerBound &+ Self(raw: randomness.next(upTo: distance))
    }
}
