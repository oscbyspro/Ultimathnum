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
        by increment: consuming Bool
    )   -> Fallible<Self> {
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
    
    @discardableResult @inlinable public consuming func increment(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self.capture {
            $0.incrementSubSequence(by: element)
        }
        
        return self.increment(by: bit)
    }
    
    @discardableResult @inlinable public func incrementSubSequence(
        by element: consuming Element
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
    
    @inlinable public consuming func increment(
        by increment: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        bit = self.capture {
            $0.incrementSubSequence(by: increment, plus: bit)
        }
        
        return self.increment(by: bit)
    }
    
    @inlinable public func incrementSubSequence(
        by increment: consuming Element, 
        plus bit: consuming Bool
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

    @inlinable public consuming func increment(
        by elements: borrowing Body, 
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        let bit = self.capture(elements) {
            $0.incrementSubSequence(by: $1, plus: bit)
        }
        
        return self.increment(by: bit)
    }
    
    @inlinable public consuming func incrementSubSequence(
        by elements: borrowing Body, 
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            bit = self.capture(elements[unchecked: index]) {
                $0.incrementSubSequence(by: $1, plus: bit)
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
    
    @discardableResult @inlinable public consuming func increment(
        by elements: borrowing Body, 
        times multiplier: consuming Element,
        plus increment: consuming Element
    )   -> Fallible<Self> {
        
        let bit = self.capture(elements) {
            $0.incrementSubSequence(by: $1, times: multiplier, plus: increment)
        }
        
        return self.increment(by: bit)
    }
    
    @discardableResult @inlinable public consuming func incrementSubSequence(
        by elements: borrowing Body,
        times multiplier: consuming Element,
        plus increment: consuming Element
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            //  maximum == (low:  1, high: ~1)
            var product = elements[unchecked: index].multiplication(multiplier)
            //  maximum == (low:  2, high: ~1)
            increment   = Element(Bit(product.low.capture({ $0.plus(increment) })))
            //  maximum == (low:  1, high: ~0)
            increment &+= Element(Bit(self.capture({ $0.incrementSubSequence(by: product.low) })))
            //  maximum == (low: ~0, high: ~0) because low == 0 when high == ~0
            increment &+= product.high
        }
        
        return self.incrementSubSequence(by: increment)
    }
}
