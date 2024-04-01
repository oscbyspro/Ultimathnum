//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Double Int x Multiplication
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func squared() -> Fallible<Self> {
        self.times(copy self)
    }
    
    @inlinable public func times(_ other: Self) -> Fallible<Self> {
        let lhsIsLessThanZero: Bool = self .isLessThanZero
        let rhsIsLessThanZero: Bool = other.isLessThanZero
        let minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var result: Fallible<Self> = { ab, xy in
            
            var ax = Base.Magnitude.multiplication(ab.low, by: xy.low)
            let ay = ab.low .times(xy.high)
            let bx = ab.high.times(xy.low )
            let by = !(ab.high == 0 || xy.high == 0)
            
            let o0 = ax.high.capture({ $0.plus(ay.value) })
            let o1 = ax.high.capture({ $0.plus(bx.value) })
            
            let overflow = by || ay.error || bx.error || o0 || o1
            return Fallible(Self(bitPattern: ax), error: overflow)
            
        }(self.magnitude, other.magnitude)
        //=--------------------------------------=
        var suboverflow = (result.value.isLessThanZero)
        if  minus {
            suboverflow = !result.value.capture({ $0.negated() }) && suboverflow
        }
        //=--------------------------------------=
        return result.combine(suboverflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func multiplication(_ lhs: Self, by rhs: Self) -> DoubleIntLayout<Self> {
        let lhsIsLessThanZero: Bool = (lhs).isLessThanZero
        let rhsIsLessThanZero: Bool = (rhs).isLessThanZero
        var minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var product: DoubleIntLayout<Magnitude> = { ab, xy in
            
            var ax = Low.multiplication(ab.low,  by: xy.low )
            let ay = Low.multiplication(ab.low,  by: xy.high)
            let bx = Low.multiplication(ab.high, by: xy.low )
            var by = Low.multiplication(ab.high, by: xy.high)
            
            let a0 = ax.high.capture({ $0.plus(ay.low ) })
            let a1 = ax.high.capture({ $0.plus(bx.low ) })
            let a2 = Low(Bit(bitPattern: a0)) &+ Low(Bit(bitPattern: a1))
            
            let b0 = by.low .capture({ $0.plus(ay.high) })
            let b1 = by.low .capture({ $0.plus(bx.high) })
            let b2 = Low(Bit(bitPattern: b0)) &+ Low(Bit(bitPattern: b1))
            
            let o0 = by.low .capture({ $0.plus(a2) })
            let _  = by.high.capture({ $0.plus(b2  &+  Low(Bit(bitPattern: o0))) })
            return DoubleIntLayout(low: Magnitude(ax), high: Magnitude(by))
            
        }(lhs.magnitude, rhs.magnitude)
        //=--------------------------------------=
        if  minus {
            minus = product.low .capture({ (~$0).plus(Magnitude(Bit(bitPattern: minus))) })
            minus = product.high.capture({ (~$0).plus(Magnitude(Bit(bitPattern: minus))) })
        }
        //=--------------------------------------=
        return DoubleIntLayout(bitPattern: product)
    }
}
