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
    
    public let divisor: Layout
    public let lhsCoefficient: Layout.Signitude
    public let rhsCoefficient: Layout.Signitude
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ lhs: consuming Finite<Layout>, _ rhs: consuming Finite<Layout>) {
        var lhs = (consume lhs).value
        var rhs = (consume rhs).value
        
        var lhsCoefficient = Extension(x: 1, y: 0)
        var rhsCoefficient = Extension(x: 0, y: 1)
        
        // note that the bit cast may overflow in the final iteration
        while let divisor = Nonzero(exactly: consume rhs) {
            (lhs, rhs) = (consume lhs).division(divisor).unchecked().components()
            let quotient = Layout.Signitude(raw: consume lhs)
            (lhs) = (consume divisor).value
            (lhsCoefficient).update(quotient)
            (rhsCoefficient).update(quotient)
        }
        
        self.divisor        = (consume lhs)
        self.lhsCoefficient = (consume lhsCoefficient).x
        self.rhsCoefficient = (consume rhsCoefficient).x
    }
    
    //*========================================================================*
    // MARK: * Extension
    //*========================================================================*
    
    @frozen @usableFromInline struct Extension {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var x: Layout.Signitude
        @usableFromInline var y: Layout.Signitude
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(x: consuming Layout.Signitude, y: consuming Layout.Signitude) {
            self.x = x
            self.y = y
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating func update(_ quotient: borrowing Layout.Signitude) {
            (self.x, self.y) = (self.y, self.x &- self.y &* quotient)
        }
    }
}
