//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bezout
//*============================================================================*

/// The greatest common divisor and `2` Bézout coefficients.
///
/// - Note: The greatest common divisor of `(0, 0)` is zero.
///
/// - Note: The `XGCD` algorithm behaves well for all finite unsigned inputs.
///
/// - Note: `Finite<T>` guarantees nonoptional results.
///
/// ### Bézout's identity
///
/// ```swift
/// divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
/// ```
///
/// - Note: This equation is mathematical and subject to overflow.
///
@frozen public struct Bezout<Layout>: Equatable where Layout: UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: (
        divisor: Layout,
        lhsCoefficient: Layout.Signitude,
        rhsCoefficient: Layout.Signitude
    )
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(
        _ lhs: consuming Finite<Layout>,
        _ rhs: consuming Finite<Layout>
    ) {
        
        var lhs = (consume lhs).value
        var rhs = (consume rhs).value
        
        var lhsCoefficient = (Layout.Signitude.lsb,  Layout.Signitude.zero)
        var rhsCoefficient = (Layout.Signitude.zero, Layout.Signitude.lsb )
        // the bit cast may overflow in the final iteration
        while let divisor = Nonzero(exactly: consume rhs) {
            (lhs, rhs) = (consume lhs).division(divisor).unchecked().components()
            let quotient = Layout.Signitude(raw: consume lhs)
            (lhs) = (consume divisor).value
            (lhsCoefficient) = (lhsCoefficient.1, lhsCoefficient.0 &- lhsCoefficient.1 &* quotient)
            (rhsCoefficient) = (rhsCoefficient.1, rhsCoefficient.0 &- rhsCoefficient.1 &* quotient)
        }
        
        self.storage.divisor = (consume lhs)
        self.storage.lhsCoefficient = lhsCoefficient.0
        self.storage.rhsCoefficient = rhsCoefficient.0
    }
    
    @inlinable init<T>(
        _ lhs: consuming Finite<T>,
        _ rhs: consuming Finite<T>
    ) where T: BinaryInteger, T.Magnitude == Layout {
        
        let lhsIsNegative = lhs.value.isNegative
        let rhsIsNegative = rhs.value.isNegative
        
        self.init(
            Finite(unchecked: Layout(raw: lhsIsNegative ? lhs.value.complement() : lhs.value)),
            Finite(unchecked: Layout(raw: rhsIsNegative ? rhs.value.complement() : rhs.value))
        )
        
        if  lhsIsNegative {
            self.storage.lhsCoefficient = self.lhsCoefficient.complement(true).unchecked()
        }
        
        if  rhsIsNegative {
            self.storage.rhsCoefficient = self.rhsCoefficient.complement(true).unchecked()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var divisor: Layout {
        self.storage.divisor
    }
    
    @inlinable public var lhsCoefficient: Layout.Signitude {
        self.storage.lhsCoefficient
    }
    
    @inlinable public var rhsCoefficient: Layout.Signitude {
        self.storage.rhsCoefficient
    }
    
    @inlinable public static func ==(lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        guard lhs.storage.divisor        == rhs.storage.divisor        else { return false }
        guard lhs.storage.lhsCoefficient == rhs.storage.lhsCoefficient else { return false }
        guard lhs.storage.rhsCoefficient == rhs.storage.rhsCoefficient else { return false }
        return true
    }
}
