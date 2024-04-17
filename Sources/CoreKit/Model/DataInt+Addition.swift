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
    
    @inlinable public consuming func increment(
        by bit: consuming Bool
    )   -> Fallible<Self> {
        //=--------------------------------------=
        // performance: compare index then bit
        //=--------------------------------------=
        while UX(bitPattern: self.count) > 0, copy bit {
            bit  = self[unchecked: Void()][{ 
                $0.incremented()
            }]
            
            self = (consume self)[unchecked: 1...]
        }
        //=--------------------------------------=
        return Fallible(consume self, error: bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some
//=----------------------------------------------------------------------------=

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @discardableResult @inlinable public consuming func increment(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self[{
            $0.incrementSubSequence(by: element)
        }]
        
        return self.increment(by: bit)
    }
    
    @discardableResult @inlinable public func incrementSubSequence(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self[unchecked: Void()][{
            $0.plus(element)
        }]
        
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
    
    @inlinable public consuming func increment(
        by increment: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        bit = self[{ 
            $0.incrementSubSequence(by: increment, plus: bit)
        }]
        
        return self.increment(by: bit)
    }
    
    @inlinable public func incrementSubSequence(
        by increment: consuming Element, 
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        if  (copy bit) {
            bit = increment[{ $0.incremented() }]
        }
        
        if !(copy bit) {
            bit = self[unchecked: Void()][{ $0.plus(increment) }]
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

    @inlinable public consuming func increment(
        by elements: Body, 
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        let bit = self[{
            $0.incrementSubSequence(by: elements, plus: bit)
        }]
        
        return self.increment(by: bit)
    }
    
    @inlinable public consuming func incrementSubSequence(
        by elements: borrowing Body,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            let element = elements[unchecked: index]
            
            bit = self[{
                $0.incrementSubSequence(by: element, plus: bit)
            }]
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
    
    @discardableResult @inlinable public consuming func increment(
        by elements: Body,
        times multiplier: consuming Element,
        plus increment: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self[{
            $0.incrementSubSequence(by: elements, times: multiplier, plus: increment)
        }]
        
        return self.increment(by: bit)
    }
    
    @discardableResult @inlinable public consuming func incrementSubSequence(
        by elements: borrowing Body,
        times multiplier: consuming Element,
        plus increment: Element
    )   -> Fallible<Self> {
        
        var increment = increment // consume: compiler bug...
        
        for index in elements.indices {
            // maximum: (low:  1, high: ~1) == max * max
            var product = elements[unchecked: index].multiplication(multiplier)
            // maximum: (low:  0, high: ~0) == max * max + max
            product.high &+= Element(Bit(product.low[{ $0.plus(increment) }]))
            // maximum: (low: ~0, high: ~0) == max * max + max + max
            product.high &+= Element(Bit(self[{ $0.incrementSubSequence(by: product.low) }]))
            // store the high part in the next iteration's increment
            increment = product.high
        }
        
        return self.incrementSubSequence(by: increment)
    }
}
