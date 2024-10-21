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
/// - Note: `Finite<T>` guarantees nonoptional results.
///
/// ### Greatest common divisor 
///
///     1. gcd(a, 0) == abs( a)
///     2. gcd(a, b) == gcd(±a, ±b)
///     3. gcd(a, b) == gcd( a,  b % a)
///     4. gcd(a, b) == gcd( b,  a)
///
/// ### Bézout's identity
///
///     divisor == lhs * lhsCoefficient + rhs * rhsCoefficient
///
/// - Note: This equation is subject to overflow.
///
@frozen public struct Bezout<Layout>: Equatable where Layout: UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Note: I wish `@inlinable` did not break `private(set)` access.
    ///
    @usableFromInline var storage: (
        divisor: Layout,
        lhsCoefficient: Layout.Signitude,
        rhsCoefficient: Layout.Signitude
    )
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from `unsigned` arguments.
    @inlinable public init(
        _ lhs: consuming Finite<Layout>,
        _ rhs: consuming Finite<Layout>
    ) {
        
        var lhs = (consume lhs).value
        var rhs = (consume rhs).value
        
        var lhsCoefficient = Extension(x: 1, y: 0)
        var rhsCoefficient = Extension(x: 0, y: 1)
        //=--------------------------------------=
        // micro: T.predicate(x) then T(unsafe: x)
        //=--------------------------------------=
        dividing: while   Nonzero.predicate( rhs) {
            let divisor = Nonzero(unsafe:    rhs)
            (lhs,  rhs) = Natural(unchecked: consume lhs).division(divisor).components()
            // bit cast may overflow in the final iteration
            let quotient = Layout.Signitude(raw: consume lhs)
            (lhs) = (consume divisor).value
            (lhsCoefficient).update(quotient)
            (rhsCoefficient).update(quotient)
        }
        
        self.storage.divisor        = (consume lhs)
        self.storage.lhsCoefficient = (consume lhsCoefficient).x
        self.storage.rhsCoefficient = (consume rhsCoefficient).x
    }
    
    /// Creates a new instance from `signed` or `unsigned` arguments.
    @inlinable public init<T>(
        _ lhs: consuming Finite<T>,
        _ rhs: consuming Finite<T>
    ) where T: BinaryInteger, T.Magnitude == Layout {
        
        let lhsIsNegative = lhs.value.isNegative
        let rhsIsNegative = rhs.value.isNegative
        
        self.init(
            lhs.magnitude(),
            rhs.magnitude()
        )
        
        if  lhsIsNegative {
            self.storage.lhsCoefficient.negate().unchecked()
        }
        
        if  rhsIsNegative {
            self.storage.rhsCoefficient.negate().unchecked()
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
        guard lhs.storage.divisor == rhs.storage.divisor else { return false }
        guard lhs.storage.lhsCoefficient == rhs.storage.lhsCoefficient  else { return false }
        guard lhs.storage.rhsCoefficient == rhs.storage.rhsCoefficient  else { return false }
        return true
    }
    
    //*========================================================================*
    // MARK: * Extension
    //*========================================================================*
    
    /// The extension part of the extended `euclidean(_:)` algorithm.
    ///
    /// - Seealso: https://en.wikipedia.org/wiki/extended_euclidean_algorithm
    ///
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
            (x, y) = (y, x &- y &* quotient)
        }
    }
}
