//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Addition x Read|Write|Body
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func increment(
        by bit: consuming Bool
    )   -> Fallible<Self> {
        //=--------------------------------------=
        // performance: compare index then bit
        //=--------------------------------------=
        while UX(raw: self.count) > 0, copy bit {
            (self[unchecked: ()], bit) =
            (self[unchecked: ()]).incremented().components()
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
    
    @discardableResult @inlinable public consuming func increment(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let result = self.incrementSubSequence(by: element)
        return result.value.increment(by: result.error)
    }
    
    @discardableResult @inlinable public consuming func incrementSubSequence(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let result = self[unchecked: ()].plus(element)
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
    
    @inlinable public consuming func increment(
        by increment: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        let result = self.incrementSubSequence(by: increment, plus: bit)
        return result.value.increment(by: result.error)
    }
    
    @inlinable public consuming func incrementSubSequence(
        by increment: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        if  (copy bit) {
            (increment, bit) = increment.incremented().components()
        }
        
        if !(copy bit) {
            (self[unchecked: ()], bit) = self[unchecked: ()].plus(increment).components()
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

    @inlinable public consuming func increment(
        by elements: Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Self> {
        
        let result = self.incrementSubSequence(by: elements, plus: bit)
        return result.value.increment(by: result.error)
    }
    
    @inlinable public consuming func incrementSubSequence(
        by elements: borrowing Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            let element = elements[unchecked: index]
            (self, bit) = self.incrementSubSequence(by: element, plus: bit).components()
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
    
    @discardableResult @inlinable public consuming func increment(
        by elements: Immutable,
        times multiplier: consuming Element,
        plus increment: consuming Element = .zero
    )   -> Fallible<Self> {
        
        let result = self.incrementSubSequence(by: elements, times: multiplier, plus: increment)
        return result.value.increment(by: result.error)
    }
    
    @discardableResult @inlinable public consuming func incrementSubSequence(
        by elements: borrowing Immutable,
        times multiplier: consuming Element,
        plus increment: Element = .zero
    )   -> Fallible<Self> {
        
        var bit: Bool
        var increment = increment // consume: compiler bug...
        
        for index in elements.indices {
            let product = elements[unchecked: index].multiplication(multiplier, plus: increment)
            (self[unchecked: index], bit) = (self[unchecked: index]).plus(product.low).components()
            (increment) = product.high.plus(Element(Bit(bit))).unchecked()
        }
        
        return (consume self)[unchecked: elements.count...].incrementSubSequence(by: increment)
    }
}
