//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Addition x Canvas
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(_ increment: consuming Bool) -> Fallible<Self> {
        //=--------------------------------------=
        // performance: compare index then bit
        //=--------------------------------------=
        while UX(bitPattern: self.count) > 0, copy increment {
            increment = self[unchecked: Void()].capture {
                $0.incremented()
            }
            
            self = (consume self)[unchecked: 1...]
        }
        //=--------------------------------------=
        return Fallible(consume self, error: increment)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some
//=----------------------------------------------------------------------------=

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @discardableResult @inlinable public consuming func plus(
        _ element: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self.capture {
            $0.plusSubSequence(element)
        }
        
        return self.plus(bit)
    }
    
    @discardableResult @inlinable public func plusSubSequence(
        _ element: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self[unchecked: Void()].capture {
            $0.plus(element)
        }
        
        return Fallible(self[unchecked: 1...], error: bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some + Bit
//=----------------------------------------------------------------------------=

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func plus(
        _ increment: consuming Element, and bit: consuming Bool
    )   -> Fallible<Self> {
        
        bit = self.capture {
            $0.plusSubSequence(increment, and: bit)
        }
        
        return self.plus(bit)
    }
    
    @inlinable public func plusSubSequence(
        _ increment: consuming Element, and bit: consuming Bool
    )   -> Fallible<Self> {
        
        if  (copy bit) {
            bit = increment.capture {
                $0.incremented()
            }
        }
        
        if !(copy bit) {
            bit = self[unchecked: Void()].capture {
                $0.plus(increment)
            }
        }
        
        return Fallible(self[unchecked: 1...], error: bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Many + Bit
//=----------------------------------------------------------------------------=

extension DataInt.Canvas {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public consuming func plus(
        _ elements: borrowing Body, and bit: consuming Bool
    )   -> Fallible<Self> {
        
        let bit = self.capture(elements) {
            $0.plusSubSequence($1, and: bit)
        }
        
        return self.plus(bit)
    }
    
    @inlinable public consuming func plusSubSequence(
        _ elements: borrowing Body, and bit: consuming Bool
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            bit = self.capture(elements[unchecked: index]) {
                $0.plusSubSequence($1, and: bit)
            }
        }
        
        return Fallible(self, error: bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Many × Some + Some
//=----------------------------------------------------------------------------=

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @discardableResult @inlinable public consuming func plus(
        _ elements: borrowing Body, times multiplier: consuming Element, and increment: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self.capture(elements) {
            $0.plusSubSequence($1, times: multiplier, and: increment)
        }
        
        return self.plus(bit)
    }
    
    @discardableResult @inlinable public consuming func plusSubSequence(
        _ elements: borrowing Body, times multiplier: consuming Element, and increment: consuming Element
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            //  maximum == (high: ~1, low: 1)
            var subproduct = elements[unchecked: index].multiplication(multiplier)
            //  maximum == (high: ~0, low: 0)
            increment = subproduct.high &+ Element(Bit(subproduct.low.capture({ $0.plus(increment) })))
            //  this cannot overflow because low == 0 when high == ~0
            increment = increment &+ Element(Bit(self.capture({ $0.plusSubSequence(subproduct.low) })))
        }
        
        return self.plusSubSequence(increment)
    }
}
