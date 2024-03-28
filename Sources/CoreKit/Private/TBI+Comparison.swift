//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Tuple Binary Integer x Comparison
//*============================================================================*

extension Namespace.TupleBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```
    /// ┌─────────── → ────────┐
    /// │ lhs vs rhs │ signum  │
    /// ├─────────── → ────────┤
    /// │ lhs <  rhs | Int(-1) | - less
    /// │ lhs == rhs | Int( 0) | - same
    /// │ lhs >  rhs | Int( 1) | - more
    /// └─────────── → ────────┘
    /// ```
    ///
    @inlinable package static func compare22S(_ lhs: DoubleIntLayout<Base>, to rhs: DoubleIntLayout<Base>) -> Signum {
        let a = lhs.high.compared(to: rhs.high); if a != Signum.same { return a }
        return  lhs.low .compared(to: rhs.low );
    }
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```
    /// ┌─────────── → ────────┐
    /// │ lhs vs rhs │ signum  │
    /// ├─────────── → ────────┤
    /// │ lhs <  rhs | Int(-1) | - less
    /// │ lhs == rhs | Int( 0) | - same
    /// │ lhs >  rhs | Int( 1) | - more
    /// └─────────── → ────────┘
    /// ```
    ///
    @inlinable package static func compare33S(_ lhs: TripleIntLayout<Base>, to rhs: TripleIntLayout<Base>) -> Signum {
        let a = lhs.high.compared(to: rhs.high); if a != Signum.same { return a }
        let b = lhs.mid .compared(to: rhs.mid ); if b != Signum.same { return b }
        return  lhs.low .compared(to: rhs.low );
    }
}
