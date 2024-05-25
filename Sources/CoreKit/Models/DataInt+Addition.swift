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
    
    /// Increments `self` by the given `bit`.
    @inlinable public consuming func increment(
        by bit: consuming Bool = true
    )   -> Fallible<Void> {
        //=--------------------------------------=
        // performance: compare index then bit
        //=--------------------------------------=
        while UX(raw: self.count) > .zero, copy bit {
            (self[unchecked: ()], bit) =
            (self[unchecked: ()]).incremented().components()
            (self) = (consume self)[unchecked: 1...]
        }
        
        return Fallible((), error: bit)
    }
    
    
    /// Decrements `self` by the given `bit`.
    @inlinable public consuming func decrement(
        by bit: consuming Bool = true
    )   -> Fallible<Void> {
        //=--------------------------------------=
        // performance: compare index then bit
        //=--------------------------------------=
        while UX(raw: self.count) > .zero, copy bit {
            (self[unchecked: ()], bit) =
            (self[unchecked: ()]).decremented().components()
            (self) = (consume self)[unchecked: 1...]
        }
        
        return Fallible((), error: bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Some
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func increment(
        by element: consuming Element
    )   -> Fallible<Void> {

        let result = self.incrementSubSequence(by: element)
        return result.value.increment(by: result.error)
    }
    
    @inlinable public consuming func incrementSubSequence(
        by element: consuming Element
    )   -> Fallible<Self> {
        
        let result = self[unchecked: ()].plus(element)
        self[unchecked: ()] = result.value
        return (consume self)[unchecked: 1...].veto(result.error)
    }
    
    @inlinable public consuming func decrement(
        by element: consuming Element
    )   -> Fallible<Void> {

        let result = self.decrementSubSequence(by: element)
        return result.value.decrement(by: result.error)
    }
    
    @inlinable public consuming func decrementSubSequence(
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
    
    @inlinable public consuming func increment(
        by increment: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Void> {

        let result = self.incrementSubSequence(by: increment, plus: bit)
        return result.value.increment(by: result.error)
    }
    
    @inlinable public consuming func incrementSubSequence(
        by increment: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        (self[unchecked: ()], bit) = self[unchecked: ()].plus(increment, plus: bit).components()
        return (consume self)[unchecked: 1...].veto(bit)
    }
    
    @inlinable public consuming func decrement(
        by decrement: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Void> {

        let result = self.decrementSubSequence(by: decrement, plus: bit)
        return result.value.decrement(by: result.error)
    }
    
    @inlinable public consuming func decrementSubSequence(
        by decrement: consuming Element,
        plus bit: consuming Bool
    )   -> Fallible<Self> {
        
        (self[unchecked: ()], bit) = self[unchecked: ()].minus(decrement, plus: bit).components()
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
    )   -> Fallible<Void> {

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
    
    @inlinable public consuming func decrement(
        by elements: Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Void> {

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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func increment(
        toggling elements: Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Void> {

        let result = self.incrementSubSequence(toggling: elements, plus: bit)
        return result.value.increment(by: result.error)
    }
    
    @inlinable public consuming func incrementSubSequence(
        toggling elements: borrowing Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            let element = elements[unchecked: index].toggled()
            (self, bit) = self.incrementSubSequence(by: element, plus: bit).components()
        }
        
        return self.veto(bit)
    }
    
    @inlinable public consuming func decrement(
        toggling elements: Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Void> {

        let result = self.decrementSubSequence(toggling: elements, plus: bit)
        return result.value.decrement(by: result.error)
    }

    @inlinable public consuming func decrementSubSequence(
        toggling elements: borrowing Immutable,
        plus bit: consuming Bool = false
    )   -> Fallible<Self> {
        
        for index in elements.indices {
            let element = elements[unchecked: index].toggled()
            (self, bit) = self.decrementSubSequence(by: element, plus: bit).components()
        }
        
        return self.veto(bit)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `self` by the given `bit` and the same-size `pattern`.
    @inlinable public consuming func incrementSameSize(
        repeating pattern: borrowing Bool,
        plus bit: consuming Bool = false
    )   -> Fallible<Void> {

        if (pattern != bit) {
            let predicate = copy bit
            let increment = copy bit ? 1 : Element(repeating: 1)
            
            while UX(raw: self.count) > .zero, copy bit ==  predicate {
                (self, bit) = self.incrementSubSequence(by: increment).components()
            }
        }
        
        return Fallible((), error: bit)
    }
    
    /// Decrements `self` by the given `bit` and the same-size `pattern`.
    @inlinable public consuming func decrementSameSize(
        repeating pattern: borrowing Bool,
        plus bit: consuming Bool = false
    )   -> Fallible<Void> {
        
        if (pattern != bit) {
            let predicate = copy bit
            let increment = copy bit ? 1 : Element(repeating: 1)
            
            while UX(raw: self.count) > .zero, copy bit ==  predicate {
                (self, bit) = self.decrementSubSequence(by: increment).components()
            }
        }
        
        return Fallible((), error: bit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Many × Some + Some
//=----------------------------------------------------------------------------=

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func increment(
        by elements: Immutable,
        times multiplier: consuming Element,
        plus increment: consuming Element = .zero
    )   -> Fallible<Void> {

        let result = self.incrementSubSequence(by: elements, times: multiplier, plus: increment)
        return result.value.increment(by: result.error)
    }
    
    @inlinable public consuming func incrementSubSequence(
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
    
    @inlinable public consuming func decrement(
        by elements: Immutable,
        times multiplier: consuming Element,
        plus decrement: consuming Element = .zero
    )   -> Fallible<Void> {

        let result = self.decrementSubSequence(by: elements, times: multiplier, plus: decrement)
        return result.value.decrement(by: result.error)
    }
    
    @inlinable public consuming func decrementSubSequence(
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
