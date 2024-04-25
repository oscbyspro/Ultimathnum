//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Multiplication x Read|Write|Body x Some
//*============================================================================*

extension MutableDataInt.Body {
    
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
// MARK: * Data Int x Multiplication x Read|Write|Body x Many
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `self` to the product of `lhs` and `rhs` plus `increment`.
    ///
    /// - Requires: The `body` must be of size `lhs.count` + `rhs.count`.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inlinable public consuming func initialize(to lhs: Immutable, times rhs: Immutable) {
        if  16 > Swift.min(lhs.count, rhs.count) {
            self.initializeByLongAlgorithm(to: lhs, times: rhs, plus: Element.zero)
        }   else {
            self.initializeByKaratsubaAlgorithm(to: lhs, times: rhs)
        }
    }
    
    /// Initializes `self` to the square product of `elements` plus `increment`.
    ///
    /// - Parameter self: A buffer of size `2 * elements`.
    ///
    @inlinable public consuming func initialize(toSquareProductOf elements: Immutable) {
        if  16 > elements.count {
            self.initializeByLongAlgorithm(toSquareProductOf: elements, plus: Element.zero)
        }   else {
            self.initializeByKaratsubaAlgorithm(toSquareProductOf: elements)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Multiplication x Read|Write|Body x Long
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `self` to the [long][algorithm] product of `lhs` and `rhs` plus `increment`.
    ///
    /// - Requires: The `body` must be of size `lhs.count` + `rhs.count`.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inline(never) @inlinable public consuming func initializeByLongAlgorithm(
        to lhs: Immutable, times rhs: Immutable, plus increment: Element = .zero
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
    
    /// Initializes `self` to the square [long][algorithm] product of `elements` plus `increment`.
    ///
    /// - Parameter self: A buffer of size `2 * elements`.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inline(never) @inlinable public consuming func initializeByLongAlgorithm(
         toSquareProductOf elements: Immutable, plus increment: Element = .zero
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
            let multiplier = Immutable(elements.start + Int(index), count: 1)
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

//*============================================================================*
// MARK: * Data Int x Multiplication x Read|Write|Body x Karatsuba
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `self` to the [Karatsuba][algorithm] product of `lhs` and `rhs`.
    ///
    ///
    ///                 i         j
    ///       ┌─────────┴─────╌╌╌╌┴───────────────╌╌╌╌┐
    ///       │       a * x       │       b * y       ->
    ///       └─────────┬─────╌╌╌╌┴─────────┬─────╌╌╌╌┘
    ///             add │       a * x       ├ u
    ///                 ├───────────────────┤
    ///             add │       b * y       ├ v
    ///                 ├───────────────────┤
    ///             sub │ (b - a) * (y - x) ├ m * n
    ///                 └───────────────────┘
    ///                 <───── maxSize ─────>
    ///
    ///
    /// - Parameter self: A buffer of size `lhs.count` + `rhs.count`.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/karatsuba_algorithm
    ///
    @inline(never) @inlinable public consuming func initializeByKaratsubaAlgorithm(to lhs: Immutable, times rhs: Immutable) {
        //=--------------------------------------=
        Swift.assert(self.count == lhs.count + rhs.count, String.indexOutOfBounds())
        //=--------------------------------------=
        let i: IX = (self.count &>> 2)
        let j: IX = (((((i))))) &<< 1
        
        var (a,b) = lhs.split(at: Swift.min(i, lhs.count))
        a = a.normalized()
        b = b.normalized()
        
        var (x,y) = rhs.split(at: Swift.min(i, rhs.count))
        x = x.normalized()
        y = y.normalized()
        
        let axCount: IX = a.count + x.count
        let byCount: IX = b.count + y.count
        let maxSize: IX = Swift.max(a.count, b.count) + Swift.max(x.count, y.count)
        let request: IX = 0000002 * maxSize
        
        Swift.assert(axCount <= j)
        Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: Int(request)) {
            let buffer = UnsafeMutableBufferPointer(rebasing: $0[..<Int(request)])
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.deinitialize()
            }
            //=----------------------------------=
            // regions
            //=----------------------------------=
            let u = Self(buffer)![unchecked: ..<maxSize]
            let v = Self(buffer)![unchecked: maxSize...]
            //=----------------------------------=
            // set (a * x) and (b * y)
            //=----------------------------------=
            u[unchecked: ..<axCount].initialize(to: a, times: x)
            u[unchecked: axCount...].initialize(repeating: Element.zero)
            v[unchecked: ..<byCount].initialize(to: b, times: y)
            v[unchecked: byCount...].initialize(repeating: Element.zero)
            Swift.assert(v[unchecked:(count-j)...].isZero)
            //=----------------------------------=
            // set (a * x) and (b * y)
            //=----------------------------------=
            self[unchecked: ..<j].initialize(load: Immutable(u[unchecked: ..<(axCount)]))
            self[unchecked: j...].initialize(load: Immutable(v[unchecked: ..<(count-j)]))
            //=----------------------------------=
            // sub (a * x) and (b * y)
            //=----------------------------------=
            let suffix = self[unchecked: i...]
            _ = suffix.increment(by: Immutable(u[unchecked: ..<(axCount)]))
            _ = suffix.increment(by: Immutable(v[unchecked: ..<(count-j)]))
            //=----------------------------------=
            // regions
            //=----------------------------------=
            let abSwap = b.compared(to: a) == Signum.less
            if  abSwap {
                Swift.swap(&a, &b)
            }
            
            let xySwap = y.compared(to: x) == Signum.less
            if  xySwap {
                Swift.swap(&x, &y)
            }
            
            let m = u[unchecked: ..<b.count]
            let n = u[unchecked: b.count...][unchecked: ..<y.count]
            //=----------------------------------=
            // set (b - a) mul (y - x)
            //=----------------------------------=
            m.initialize(to: b)
            m.decrement (by: a).assert()
            
            n.initialize(to: y)
            n.decrement (by: x).assert()
            
            v.initialize(to: Immutable(m), times: Immutable(n))
            //=----------------------------------=
            // sub (b - a) mul (y - x)
            //=----------------------------------=
            if  abSwap == xySwap {
                _ = suffix.decrement(by: Immutable(v))
            }   else {
                _ = suffix.increment(by: Immutable(v))
            }
        }
    }
    
    /// Initializes `self` to the square [Karatsuba][algorithm] product of `elements`.
    ///
    ///
    ///                 <───────── suffix ────────────>
    ///       ┌───────────────────┬───────────────────┐
    ///       │       a * x       │       b * y       ->
    ///       └─────────┬─────────┴─────────┬─────────┘
    ///             add │       a * x       ├ u
    ///                 ├───────────────────┤
    ///             add │       b * y       ├ v
    ///                 ├───────────────────┤
    ///             sub │ (b - a) * (y - x) ├ m * n
    ///                 └───────────────────┘
    ///                 <───── maxSize ─────>
    ///
    ///
    /// - Parameter self: A buffer of size `2 * elements.count`.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/karatsuba_algorithm
    ///
    /// ### Development
    ///
    /// - TODO: Add a test case where `elements` has redundant zeros.
    ///
    @inline(never) @inlinable public consuming func initializeByKaratsubaAlgorithm(toSquareProductOf elements: Immutable) {
        //=--------------------------------------=
        Swift.assert(self.count == 2 * elements.count, String.indexOutOfBounds())
        //=--------------------------------------=
        let i: IX = elements.count &>> 1
        let j: IX = i &<< 1
        
        var a: Immutable = elements[unchecked: ..<i].normalized()
        var b: Immutable = elements[unchecked: i...].normalized()

        let axCount: IX = 2 * a.count
        let byCount: IX = 2 * b.count
        let maxSize: IX = Swift.max(axCount, byCount)
        let request: IX = 0000002 * maxSize
        
        Swift.assert(axCount <= j)
        Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: Int(request)) {
            let buffer = UnsafeMutableBufferPointer(rebasing: $0[..<Int(request)])
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.deinitialize()
            }
            //=----------------------------------=
            // regions
            //=----------------------------------=
            let u = Self(buffer)![unchecked: ..<maxSize]
            let v = Self(buffer)![unchecked: maxSize...]
            //=----------------------------------=
            // set (a * x) and (b * y)
            //=----------------------------------=
            u[unchecked: ..<axCount].initialize(toSquareProductOf: a)
            u[unchecked: axCount...].initialize(repeating: Element.zero)
            v[unchecked: ..<byCount].initialize(toSquareProductOf: b)
            v[unchecked: byCount...].initialize(repeating: Element.zero)
            //=----------------------------------=
            // set (a * x) and (b * y)
            //=----------------------------------=
            self[unchecked: ..<j].initialize(load: Immutable(u[unchecked: ..<axCount]))
            self[unchecked: j...].initialize(load: Immutable(v[unchecked: ..<byCount]))
            //=----------------------------------=
            // set (a * x) and (b * y)
            //=----------------------------------=
            let suffix = self[unchecked: i...]
            suffix.increment(by: Immutable(u[unchecked: ..<axCount])).assert()
            suffix.increment(by: Immutable(v[unchecked: ..<byCount])).assert()
            //=----------------------------------=
            // regions
            //=----------------------------------=
            if  b.compared(to:  a) == Signum.less {
                Swift.swap(&a, &b)
            }
            //=----------------------------------=
            // set (b - a) mul (y - x)
            //=----------------------------------=
            u[unchecked: ..<b.count].initialize(to: b)
            u[unchecked: ..<b.count].decrement (by: a).assert()
            v.initialize(toSquareProductOf: Immutable(u[unchecked: ..<b.count]))
            //=----------------------------------=
            // sub (b - a) mul (y - x)
            //=----------------------------------=
            _ = suffix.decrement(by: Immutable(v))
        }
    }
}
