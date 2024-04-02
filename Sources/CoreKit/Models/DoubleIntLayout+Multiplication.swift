//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Double Int Layout x Multiplication x Unsigned
//*============================================================================*

extension DoubleIntLayout {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func multiplication(_ multiplier: Base) -> TripleIntLayout<Base> {
        let lhsIsLessThanZero: Bool = (self.high .isLessThanZero)
        let rhsIsLessThanZero: Bool = (multiplier.isLessThanZero)
        let minus: Bool = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        let result = TripleIntLayout<Base>(bitPattern: self.magnitude._multiplication(multiplier.magnitude))
        return minus ? result.negated().value : result
    }
}

//*============================================================================*
// MARK: * Double Int Layout x Multiplication x Unsigned
//*============================================================================*

extension DoubleIntLayout where Base == Base.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func _multiplication(_ multiplier: Base) -> TripleIntLayout<Base> {
        let ax = self.low .multiplication(multiplier)
        var bx = self.high.multiplication(multiplier)
        
        bx = bx.plus(ax.high).assert()
        
        return TripleIntLayout(low: ax.low, high: bx)
    }
}
