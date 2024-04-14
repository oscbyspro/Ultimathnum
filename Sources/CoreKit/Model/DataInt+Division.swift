//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Division x Body x Element
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `remainder` of dividing `self` by the `divisor`.
    ///
    /// - Requires: The `divisor` must be nonzero.
    ///
    /// - Returns: The `remainder` is returned. Note that the value of the `remainder` is less than the `divisor`.
    ///
    /// - Note: This operation does not need `write` access.
    ///
    /// - Important: This is `unsigned` and `finite`.
    ///
    @inlinable public func remainder(_ divisor: borrowing Nonzero<Element>) -> Element {
        var remainder = Element()
        
        for index in self.indices.reversed() {
            let dividend = Doublet(low: self[unchecked: index], high: remainder)
            remainder = Element.division(dividend, by: divisor.value).assert().remainder
        }
        
        return remainder as Element
    }
}

//*============================================================================*
// MARK: * Data Int x Division x Canvas x Element
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`.
    ///
    /// - Requires: The `divisor` must be nonzero.
    ///
    /// - Returns: The `remainder` is returned. Note that the value of the `remainder` is less than the `divisor`.
    ///
    /// - Note: This operation does not need `write` access.
    ///
    /// - Important: This is `unsigned` and `finite`.
    ///
    @inlinable public func remainder(_ divisor: borrowing Nonzero<Element>) -> Element {
        Body(self).remainder(divisor)
    }
    
    /// Returns the `quotient` and `remainder` of dividing `self` by the `divisor`.
    ///
    /// - Requires: The `divisor` must be nonzero.
    ///
    /// - Returns: The `quotient` is stored in `self` and the `remainder` is returned.
    ///   Note that the value of the `remainder` is less than the `divisor`.
    ///
    /// - Important: This is `unsigned` and `finite`.
    ///
    @inlinable public func divisionSetQuotientGetRemainder(_ divisor: borrowing Nonzero<Element>) -> Element {
        var remainder = Element()
        
        for index in self.indices.reversed() {
            let dividend = Doublet(low: self[unchecked: index], high: remainder)
            let division = Element.division(dividend, by: divisor.value).assert()
            (self[unchecked: index], remainder) = division.components
        }
        
        return remainder as Element
    }
}
