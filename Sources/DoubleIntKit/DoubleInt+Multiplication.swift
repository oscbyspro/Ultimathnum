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
        var result = Fallible<Self>(bitPattern: self.magnitude._times(other.magnitude))
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
    
    @inlinable public static func multiplying(_ lhs: Self, by rhs: Self) -> DoubleIntLayout<Self> {
        let lhsIsLessThanZero: Bool = (lhs).isLessThanZero
        let rhsIsLessThanZero: Bool = (rhs).isLessThanZero
        var minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var product = Magnitude._multiplying(lhs.magnitude, by: rhs.magnitude)
        //=--------------------------------------=
        if  minus {
            minus = product.low .capture({ (~$0).plus(Magnitude(Bit(bitPattern: minus))) })
            minus = product.high.capture({ (~$0).plus(Magnitude(Bit(bitPattern: minus))) })
        }
        //=--------------------------------------=
        return DoubleIntLayout(bitPattern: product)
    }
}

//*============================================================================*
// MARK: * Double Int x Multiplication x Unsigned
//*============================================================================*

extension DoubleInt where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inline(__always) @inlinable internal consuming func _times(_ other: Self) -> Fallible<Self> {
        var ax = Base.multiplying(self.low, by: other.low)
        let ay = self.low .times(other.high)
        let bx = self.high.times(other.low )
        let by = !(self.high == 0 as Base || other.high == 0 as Base)
        //=--------------------------------------=
        let o0 = ax.high.capture({ $0.plus(ay.value) })
        let o1 = ax.high.capture({ $0.plus(bx.value) })
        //=--------------------------------------=
        return Fallible(Self(ax), error: by || ay.error || bx.error || o0 || o1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inline(__always) @inlinable internal static func _multiplying(_ lhs: consuming Self, by rhs: Self) -> DoubleIntLayout<Self> {
        var ax = Base.multiplying(lhs.low,  by: rhs.low ) as Storage
        let ay = Base.multiplying(lhs.low,  by: rhs.high) as Storage
        let bx = Base.multiplying(lhs.high, by: rhs.low ) as Storage
        var by = Base.multiplying(lhs.high, by: rhs.high) as Storage
        //=--------------------------------------=
        let a0 = ax.high.capture({ $0.plus(ay.low ) })
        let a1 = ax.high.capture({ $0.plus(bx.low ) })
        let a2 = Base(Bit(bitPattern: a0)) &+ Base(Bit(bitPattern: a1))
        
        let b0 = by.low .capture({ $0.plus(ay.high) })
        let b1 = by.low .capture({ $0.plus(bx.high) })
        let b2 = Base(Bit(bitPattern: b0)) &+ Base(Bit(bitPattern: b1))
        //=--------------------------------------=
        let o0 = by.low .capture({ $0.plus(a2) })
        let _  = by.high.capture({ $0.plus(b2  &+ Base(Bit(bitPattern: o0))) })
        //=--------------------------------------=
        return DoubleIntLayout(low: Magnitude(ax), high: Magnitude(by))
    }
}
