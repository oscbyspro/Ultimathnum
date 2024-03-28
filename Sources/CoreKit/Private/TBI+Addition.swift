//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Addition x Unsigned
//*============================================================================*

extension Namespace.TupleBinaryInteger where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `sum` of `lhs` and `rhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────── → ───────────┬──────────┐
    /// │ lhs        │ rhs    │ sum        │ overflow │
    /// ├────────────┼─────── → ───────────┼──────────┤
    /// │  0,  0,  0 │ ~4, ~5 │  0, ~4, ~5 │ false    │
    /// │  1,  2,  3 │ ~4, ~5 │  1, ~2, ~2 │ false    │
    /// │ ~1, ~2, ~3 │  4,  5 │ ~0,  2,  1 │ false    │
    /// │ ~0, ~0, ~0 │  4,  5 │  0,  4,  4 │ true     │
    /// └────────────┴─────── → ───────────┴──────────┘
    /// ```
    ///
    @inlinable package static func increment32B(_ lhs: inout TripleIntLayout<Base>, by rhs: DoubleIntLayout<Base>) -> Bool {
        let a = Overflow.capture(&lhs.low, map:{ try $0.plus(rhs.low ) })
        let b = Overflow.capture(&lhs.mid, map:{ try $0.plus(rhs.high) })
        
        let x = (a     ) && Overflow.capture(&lhs.mid,  map:{ try $0.plus(1) })
        let y = (b || x) && Overflow.capture(&lhs.high, map:{ try $0.plus(1) })
        return  (     y) as Bool
    }
    
    /// Forms the `sum` of `lhs` and `rhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ sum        │ overflow │
    /// ├────────────┼─────────── → ───────────┼──────────┤
    /// │  0,  0,  0 │ ~4, ~5, ~6 │ ~4, ~5, ~6 │ false    │
    /// │  1,  2,  3 │ ~4, ~5, ~6 │ ~3, ~3, ~3 │ false    │
    /// │ ~1, ~2, ~3 │  4,  5,  6 │  3,  3,  2 │ true     │
    /// │ ~0, ~0, ~0 │  4,  5,  6 │  4,  5,  5 │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    @inlinable package static func increment33B(_ lhs: inout TripleIntLayout<Base>, by rhs: TripleIntLayout<Base>) -> Bool {
        let a = Overflow.capture(&lhs.low,  map:{ try $0.plus(rhs.low ) })
        let b = Overflow.capture(&lhs.mid,  map:{ try $0.plus(rhs.mid ) })
        let c = Overflow.capture(&lhs.high, map:{ try $0.plus(rhs.high) })
        
        let x = (a     ) && Overflow.capture(&lhs.mid,  map:{ try $0.plus(1) })
        let y = (b || x) && Overflow.capture(&lhs.high, map:{ try $0.plus(1) })
        return  (c || y) as Bool
    }
}
