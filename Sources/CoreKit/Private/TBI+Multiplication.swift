//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Multiplication x Unsigned
//*============================================================================*

extension Namespace.TupleBinaryInteger where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `product` of multiplying `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────┬──── → ───────────┐
    /// │ lhs    │ rhs │ product    │
    /// ├────────┼──── → ───────────┤
    /// │  1,  2 │  3, │  0,  3,  6 │
    /// │ ~1, ~2 │ ~3, │ ~4,  1, 12 │
    /// │ ~0, ~0 │ ~0, │ ~1, ~0,  1 │
    /// └────────┴──── → ───────────┘
    /// ```
    ///
    @inlinable package static func multiplying213(_ lhs: Doublet<Base>, by rhs: Base) -> Triplet<Base> {
        let a = Base.multiplying(lhs.low,  by: rhs)
        var b = Base.multiplying(lhs.high, by: rhs)
        
        let x =      Overflow.capture(&b.low,  map:{ try $0.plus(a.high) })
        let _ = x && Overflow.capture(&b.high, map:{ try $0.plus(000001) })
        
        return Triplet(high: b.high, mid: b.low, low: a.low)
    }
}