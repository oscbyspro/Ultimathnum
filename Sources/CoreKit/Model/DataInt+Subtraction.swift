//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Subtraction x Canvas
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func decrement(
        by bit: consuming Bool
    )   -> Fallible<Self> {
        //=--------------------------------------=
        // performance: compare index then bit
        //=--------------------------------------=
        while UX(bitPattern: self.count) > 0, copy bit {
            bit  = self[unchecked: Void()][{
                $0.decremented()
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
    
    @discardableResult @inlinable public consuming func decrement(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self[{
            $0.decrementSubSequence(by: element)
        }]
        
        return self.decrement(by: bit)
    }
    
    @discardableResult @inlinable public func decrementSubSequence(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self[unchecked: Void()][{
            $0.minus(element)
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
    
    @inlinable public consuming func decrement(
        by decrement: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        bit = self[{
            $0.decrementSubSequence(by: decrement, plus: bit)
        }]
        
        return self.decrement(by: bit)
    }
    
    @inlinable public func decrementSubSequence(
        by decrement: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        if  (copy bit) {
            bit = decrement[{ $0.incremented() }]
        }
        
        if !(copy bit) {
            bit = self[unchecked: Void()][{ $0.minus(decrement) }]
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

    @inlinable public consuming func decrement(
        by elements: Body,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        let bit = self[{
            $0.decrementSubSequence(by: elements, plus: bit)
        }]
        
        return self.decrement(by: bit)
    }
    
    @inlinable public consuming func decrementSubSequence(
        by elements: borrowing Body,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            let element = elements[unchecked: index]
            
            bit = self[{
                $0.decrementSubSequence(by: element, plus: bit)
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
    
    @discardableResult @inlinable public consuming func decrement(
        by elements: Body,
        times multiplier: consuming Element,
        plus decrement: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self[{
            $0.decrementSubSequence(by: elements, times: multiplier, plus: decrement)
        }]
        
        return self.decrement(by: bit)
    }
    
    @discardableResult @inlinable public consuming func decrementSubSequence(
        by elements: borrowing Body,
        times multiplier: consuming Element,
        plus decrement: consuming Element
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            // maximum: (low:  1, high: ~1) == max * max
            var product = elements[unchecked: index].multiplication(multiplier)
            // maximum: (low:  0, high: ~0) == max * max + max
            product.high &+= Element(Bit(product.low[{ $0.plus(decrement) }]))
            // maximum: (low:  0, high: ~0) == max * max + max - min
            product.high &+= Element(Bit(self[{ $0.decrementSubSequence(by: product.low) }]))
            // store the high part in the next iteration's decrement
            decrement = product.high
        }
        
        return self.decrementSubSequence(by: decrement)
    }
}
