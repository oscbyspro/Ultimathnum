//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Subtraction x Read|Write|Body
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func decrement(
        by bit: consuming Bool
    )   -> Fallible<Self> {
        //=--------------------------------------=
        // performance: compare index then bit
        //=--------------------------------------=
        while UX(raw: self.count) > 0, copy bit {
            (self[unchecked: ()], bit) =
            (self[unchecked: ()]).decremented().components()
            (self) = (consume self)[unchecked: 1...]
        }
        //=--------------------------------------=
        return self.veto(bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @discardableResult @inlinable public consuming func decrement(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let result = self.decrementSubSequence(by: element)
        return result.value.decrement(by: result.error)
    }
    
    @discardableResult @inlinable public consuming func decrementSubSequence(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let result = self[unchecked: ()].minus(element)
        self[unchecked: ()] = result.value
        return (consume self)[unchecked: 1...].veto(result.error)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some + Bit
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func decrement(
        by decrement: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        let result = self.decrementSubSequence(by: decrement, plus: bit)
        return result.value.decrement(by: result.error)
    }
    
    @inlinable public consuming func decrementSubSequence(
        by decrement: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        if  (copy bit) {
            (decrement, bit) = decrement.incremented().components()
        }
        
        if !(copy bit) {
            (self[unchecked: ()], bit) = self[unchecked: ()].minus(decrement).components()
        }
        
        return (consume self)[unchecked: 1...].veto(bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Many + Bit
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable public consuming func decrement(
        by elements: Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Self> {
        
        let result = self.decrementSubSequence(by: elements, plus: bit)
        return result.value.decrement(by: result.error)
    }
    
    @inlinable public consuming func decrementSubSequence(
        by elements: borrowing Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            let element = elements[unchecked: index]
            (self, bit) = self.decrementSubSequence(by: element, plus: bit).components()
        }
        
        return self.veto(bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Many × Some + Some
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @discardableResult @inlinable public consuming func decrement(
        by elements: Immutable,
        times multiplier: consuming Element,
        plus decrement: consuming Element = .zero
    )   -> Fallible<Self> {
        
        let result = self.decrementSubSequence(by: elements, times: multiplier, plus: decrement)
        return result.value.decrement(by: result.error)
    }
    
    @discardableResult @inlinable public consuming func decrementSubSequence(
        by elements: borrowing Immutable,
        times multiplier: consuming Element,
        plus decrement: Element = .zero
    )   -> Fallible<Self> {
        
        var bit: Bool
        var decrement = decrement // consume: compiler bug...
        
        for index in elements.indices {
            let product = elements[unchecked: index].multiplication(multiplier, plus: decrement)
            (self[unchecked: index], bit) = (self[unchecked: index]).minus(product.low).components()
            (decrement) = product.high.plus(Element(Bit(bit))).unchecked()
        }
        
        return (consume self)[unchecked: elements.count...].decrementSubSequence(by: decrement)
    }
}
