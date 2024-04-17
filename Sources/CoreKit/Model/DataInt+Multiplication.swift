//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Multiplication x Element x Canvas
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `low` part and returns the `high` part of multiplying `self`
    /// by `multiplier` then adding `increment`.
    ///
    /// - Returns: The `low` part is stored in `self` and the `high` part is returned.
    ///   Note that the largest result is `(low: [0] * count, high: ~0)`.
    ///
    /// - Important: This is `unsigned` and `finite`.
    ///
    @inlinable public consuming func multiply(
        by multiplier: borrowing Element,
        add increment: Element = .zero
    )   -> Element {
        
        var increment = increment // consume: compiler bug...
        
        while UX(bitPattern: self.count) > 0 {
            var product = self[unchecked: Void()].multiplication(multiplier)
            product.high &+= Element(Bit(product.low[{ $0.plus(increment) }]))
            increment = product.high
            self[unchecked: Void()] = product.low
            self = (consume self)[unchecked: 1...] // consume: compiler bug...
        }
        
        return increment as Element
    }
}

//*============================================================================*
// MARK: * Data Int x Multiplication x Long x Canvas
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Initializes `self` to the product of `lhs` and `rhs` plus `increment`.
    ///
    /// - Requires: The `body` must be of size `lhs.count` + `rhs.count`.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inlinable public consuming func initialize(to lhs: Body, times rhs: Body) {
        self.initializeByLongAlgorithm(to: lhs, times: rhs, plus: Element.zero)
    }
    
    /// Initializes `base` to the square product of `elements` plus `increment`.
    ///
    /// - Parameter base: A buffer of size `2 * elements`.
    ///
    @inlinable public consuming func initialize(toSquareProductOf elements: Body) {
        self.initializeByLongAlgorithm(toSquareProductOf: elements, plus: Element.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Initializes `self` to the [long][algorithm] product of `lhs` and `rhs` plus `increment`.
    ///
    /// - Requires: The `body` must be of size `lhs.count` + `rhs.count`.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inline(never) @inlinable public consuming func initializeByLongAlgorithm(
        to lhs: Body, times rhs: Body, plus increment: Element = .zero
    ) {
        //=--------------------------------------=
        Swift.assert(self.count >= 1 || increment == 0, String.indexOutOfBounds())
        Swift.assert(self.count == lhs.count+rhs.count, String.indexOutOfBounds())
        //=--------------------------------------=
        var pointer = self.start
        //=--------------------------------------=
        // pointee: initialization 1
        //=--------------------------------------=
        var carry: Element = increment
        let first: Element = rhs.count > 0 ? rhs[unchecked: Void()] : Element()
        
        for index in lhs.indices {
            // maximum: (low:  1, high: ~1) == max * max
            var product = lhs[unchecked: index].multiplication(first)
            // maximum: (low:  0, high: ~0) == max * max + max
            carry = product.high.plus(Element(Bit(product.low[{ $0.plus(carry) }]))).assert()
            pointer.initialize(to: product.low)
            pointer = pointer.successor()
        }
        
        if  rhs.count != 0 {
            pointer.initialize(to: carry)
            pointer = pointer.successor()
        }
        //=--------------------------------------=
        // pointee: initialization 2
        //=--------------------------------------=
        for index in rhs.indices.dropFirst() {
            pointer.initialize(to: 00000)
            pointer = pointer.successor()
            (copy self)[unchecked: index...].incrementSubSequence(by: lhs, times: rhs[unchecked: index], plus: 0)
        }
        
        Swift.assert(IX(self.start.distance(to: pointer)) == self.count)
    }
    
    /// Initializes `base` to the square [long][algorithm] product of `elements` plus `increment`.
    ///
    /// - Parameter base: A buffer of size `2 * elements`.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inline(never) @inlinable public consuming func initializeByLongAlgorithm(
         toSquareProductOf elements: Body, plus increment: Element = .zero
    ) {
        //=--------------------------------------=
        Swift.assert(self.count >= 1 || increment == 0, String.indexOutOfBounds())
        Swift.assert(self.count == 2 *  elements.count, String.indexOutOfBounds())
        //=--------------------------------------=
        // pointee: initialization
        //=--------------------------------------=
        self.start.initialize(repeating: 0, count: Int(self.count))
        //=--------------------------------------=
        var index = 000 as IX
        var carry = increment
        //=--------------------------------------=
        while UX(bitPattern: self.count) > 0 {
            let multiplier = Body(elements.start + Int(index), count: 1)
            index = index.incremented().assert()
            //=----------------------------------=
            // add non-diagonal products
            //=----------------------------------=
            (copy self)[unchecked: 1...].incrementSubSequence(
                by:    elements[unchecked: index...],
                times: multiplier[unchecked: Void()],
                plus:  Element.zero
            )
            //=----------------------------------=
            // partially double non-diagonal
            //=----------------------------------=
            carry = (copy self)[unchecked: ..<2].multiply(by: 2, add: carry)
            //=----------------------------------=
            // add this iteration's diagonal
            //=----------------------------------=
            carry &+=  Element(Bit(self[{$0.incrementSubSequence(
                by:    multiplier,
                times: multiplier[unchecked: Void()],
                plus:  Element.zero
            )}])) //   note that this advances self by two steps
        }
    }
}
