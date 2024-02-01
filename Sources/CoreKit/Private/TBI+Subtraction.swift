//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Subtraction x Unsigned
//*============================================================================*

extension Namespace.TupleBinaryInteger where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `difference` of `lhs` and `rhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────── → ───────────┬──────────┐
    /// │ lhs        │ rhs    │ difference │ overflow │
    /// ├────────────┼─────── → ───────────┼──────────┤
    /// │  0,  0,  0 │ ~4, ~5 │ ~0,  4,  6 │ true     │
    /// │  1,  2,  3 │ ~4, ~5 │  0,  6,  9 │ false    │
    /// │ ~1, ~2, ~3 │  4,  5 │ ~1, ~6, ~8 │ false    │
    /// │ ~0, ~0, ~0 │  4,  5 │ ~0, ~4, ~5 │ false    │
    /// └────────────┴─────── → ───────────┴──────────┘
    /// ```
    ///
    @inlinable package static func decrement32B(_ lhs: inout Triplet<Base>, by rhs: Doublet<Base>) -> Bool {
        let a = Overflow.capture(&lhs.low, map:{ try $0.minus(rhs.low ) })
        let b = Overflow.capture(&lhs.mid, map:{ try $0.minus(rhs.high) })
        
        let x = (a     ) && Overflow.capture(&lhs.mid,  map:{ try $0.minus(1) })
        let y = (b || x) && Overflow.capture(&lhs.high, map:{ try $0.minus(1) })
        return  (     y) as Bool
    }
    
    /// Forms the `difference` of `lhs` and `rhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ difference │ overflow │
    /// ├────────────┼─────────── → ───────────┼──────────┤
    /// │  0,  0,  0 │ ~4, ~5, ~6 │  4,  5,  7 │ true     │
    /// │  1,  2,  3 │ ~4, ~5, ~6 │  5,  7, 10 │ true     │
    /// │ ~1, ~2, ~3 │  4,  5,  6 │ ~5, ~7, ~9 │ false    │
    /// │ ~0, ~0, ~0 │  4,  5,  6 │ ~4, ~5, ~6 │ false    │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    @inlinable package static func decrement33B(_ lhs: inout Triplet<Base>, by rhs: Triplet<Base>) -> Bool {
        let a = Overflow.capture(&lhs.low,  map:{ try $0.minus(rhs.low ) })
        let b = Overflow.capture(&lhs.mid,  map:{ try $0.minus(rhs.mid ) })
        let c = Overflow.capture(&lhs.high, map:{ try $0.minus(rhs.high) })
        
        let x = (a     ) && Overflow.capture(&lhs.mid,  map:{ try $0.minus(1) })
        let y = (b || x) && Overflow.capture(&lhs.high, map:{ try $0.minus(1) })
        return  (c || y) as Bool
    }
}
