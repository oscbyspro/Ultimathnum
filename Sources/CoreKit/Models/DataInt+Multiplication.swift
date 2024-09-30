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
        
        while !self.isEmpty {
            (self[unchecked: ()], increment) =
            (self[unchecked: ()]).multiplication(multiplier, plus: increment).components()
            (self) = (consume self)[unchecked: 1...]
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
        if  32 > Swift.min(lhs.count, rhs.count) {
            self.initializeByLongAlgorithm(to: lhs, times: rhs)
        }   else {
            self.initializeByKaratsubaAlgorithm(to: lhs, times: rhs)
        }
    }
    
    /// Initializes `self` to the square product of `elements` plus `increment`.
    ///
    /// - Parameter self: A buffer of size `2 * elements`.
    ///
    @inlinable public consuming func initialize(toSquareProductOf elements: Immutable) {
        if  32 > elements.count {
            self.initializeByLongAlgorithm(toSquareProductOf: elements)
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
    /// - Parameter self: The `body` must be of size `lhs.count` + `rhs.count`.
    ///
    /// - Requires: If `self` is empty, then the `increment` must be zero.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inline(never) @inlinable public consuming func initializeByLongAlgorithm(
        to lhs: consuming Immutable, times rhs: consuming Immutable, plus increment: consuming Element = .zero
    ) {
        
        Swift.assert(self.count == lhs.count + rhs.count, String.indexOutOfBounds())
        Swift.assert(self.count >= 1 || increment.isZero, String.indexOutOfBounds())
        //=--------------------------------------=
        var pointer: UnsafeMutablePointer<Element> = self.start
        //=--------------------------------------=
        // pointee: initialization 1
        //=--------------------------------------=
        let first: Element = rhs.first ?? Element()
        
        for index in lhs.indices {
            let product = lhs[unchecked: index].multiplication(first, plus: increment)
            increment = product.high
            pointer.initialize(to: product.low)
            pointer = pointer.successor()
        }
        
        if !rhs.isEmpty {
            pointer.initialize(to: increment)
            pointer = pointer.successor()
            rhs  = (consume rhs )[unchecked: 1...]
            self = (consume self)[unchecked: 1...]
        }
        
        Swift.assert(IX(self.start.distance(to: pointer)) == lhs.count)
        //=--------------------------------------=
        // pointee: initialization 2
        //=--------------------------------------=
        while !rhs.isEmpty {
            pointer.initialize(to: .zero)
            pointer = pointer.successor()
            (copy self).incrementSubSequence(by: copy lhs, times: rhs[unchecked: ()]).unchecked()
            rhs  = (consume rhs )[unchecked: 1...]
            self = (consume self)[unchecked: 1...]
        }

        Swift.assert(IX(self.start.distance(to: pointer)) == lhs.count)
    }
    
    /// Initializes `self` to the square [long][algorithm] product of `elements` plus `increment`.
    ///
    /// - Parameter self: A buffer of size `2 * elements`.
    ///
    /// - Requires: If `self` is empty, then the `increment` must be zero.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/multiplication_algorithm
    ///
    @inline(never) @inlinable public consuming func initializeByLongAlgorithm(
         toSquareProductOf elements: Immutable, plus increment: Element = .zero
    ) {
        
        Swift.assert(self.count == 2  * (elements.count), String.indexOutOfBounds())
        Swift.assert(self.count >= 1 || increment.isZero, String.indexOutOfBounds())
        //=--------------------------------------=
        // pointee: initialization
        //=--------------------------------------=
        self.initialize(repeating: .zero)
        //=--------------------------------------=
        var bit: Bool
        var index = 000 as IX
        var carry = increment
        //=--------------------------------------=
        while !self.isEmpty {
            //=----------------------------------=
            let multiplier = Immutable(elements.start + Int(index), count: 1)
            let (diagonal) = multiplier[unchecked:()]
            index = index.incremented().unchecked ()
            //=----------------------------------=
            // add non-diagonal products
            //=----------------------------------=
            (copy self)[unchecked: 1...].incrementSubSequence(by: elements[unchecked: index...], times: diagonal).unchecked()
            //=----------------------------------=
            // partially double non-diagonal
            //=----------------------------------=
            (carry) = (copy self)[unchecked: ..<2].multiply(by: 2, add: carry)
            //=----------------------------------=
            // add this iteration's diagonal
            //=----------------------------------=
            (self, bit) = self.incrementSubSequence(by: multiplier, times: diagonal).components()
            (carry) &+= Element(Bit(bit))
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
    ///                 <───────── suffix ────────────>
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
        Swift.assert(self.count >=  2 * j)
        
        var (a,b) = lhs.split(unchecked: Swift.min(i, lhs.count))
        a = a.normalized()
        b = b.normalized()
        
        var (x,y) = rhs.split(unchecked: Swift.min(i, rhs.count))
        x = x.normalized()
        y = y.normalized()
        
        let axCount: IX = a.count + x.count
        let byCount: IX = b.count + y.count
        let maxSize: IX = Swift.max(a.count, b.count) + Swift.max(x.count, y.count)
        let request: IX = 0000002 * maxSize
        
        Swift.assert(axCount <= j)
        Swift.assert(maxSize >= axCount)
        Swift.assert(maxSize >= byCount)
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
            let vjCount = Swift.min(v.count, self.count - j)
            //=----------------------------------=
            // set (a * x) and (b * y)
            //=----------------------------------=
            u[unchecked: ..<axCount].initialize(to: a, times:  x)
            u[unchecked: axCount...].initialize(repeating: .zero)
            v[unchecked: ..<byCount].initialize(to: b, times:  y)
            v[unchecked: byCount...].initialize(repeating: .zero)
            Swift.assert(v[unchecked: vjCount...].isZero)
            //=----------------------------------=
            // set (a * x) and (b * y)
            //=----------------------------------=
            self[unchecked: ..<j].initialize(load: Immutable(u[unchecked: ..<axCount]))
            self[unchecked: j...].initialize(load: Immutable(v[unchecked: ..<vjCount]))
            //=----------------------------------=
            // add (a * x) and (b * y)
            //=----------------------------------=
            let suffix = self[unchecked: i...]
            suffix.increment(by: Immutable(u[unchecked: ..<axCount])).discard()
            suffix.increment(by: Immutable(v[unchecked: ..<vjCount])).discard()
            //=----------------------------------=
            // regions
            //=----------------------------------=
            let abSwap = b.compared(to: a).isNegative
            if  abSwap {
                Swift.swap(&a, &b)
            }
            
            let xySwap = y.compared(to: x).isNegative
            if  xySwap {
                Swift.swap(&x, &y)
            }
            
            let m = u[unchecked: ..<b.count]
            let n = u[unchecked: b.count...][unchecked: ..<y.count]
            //=----------------------------------=
            // set (b - a) mul (y - x)
            //=----------------------------------=
            m.initialize(to: b)
            m.decrement (by: a).discard()
            
            n.initialize(to: y)
            n.decrement (by: x).discard()
            
            v.initialize(to: Immutable(m), times: Immutable(n))
            //=----------------------------------=
            // sub (b - a) mul (y - x)
            //=----------------------------------=
            if  abSwap == xySwap {
                suffix.decrement(by: Immutable(v)).discard()
            }   else {
                suffix.increment(by: Immutable(v)).discard()
            }
        }
    }
    
    /// Initializes `self` to the square [Karatsuba][algorithm] product of `elements`.
    ///
    ///
    ///                 <───────── suffix ────────────>
    ///                 i         j
    ///       ┌─────────┴─────╌╌╌╌┴───────────────╌╌╌╌┐
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
        Swift.assert(self.count ==  2 * elements.count, String.indexOutOfBounds())
        //=--------------------------------------=
        let i: IX = (self.count &>> 2)
        let j: IX = (((((i))))) &<< 1
        Swift.assert(self.count >=  2 * j)
        
        var a: Immutable = elements[unchecked: ..<i].normalized()
        var b: Immutable = elements[unchecked: i...].normalized()

        let axCount: IX = 2 * a.count
        let byCount: IX = 2 * b.count
        let maxSize: IX = Swift.max(axCount, byCount)
        let request: IX = 0000002 * maxSize
        
        Swift.assert(axCount <= j)
        Swift.assert(maxSize >= axCount)
        Swift.assert(maxSize >= byCount)
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
            u[unchecked: axCount...].initialize(repeating: .zero)
            v[unchecked: ..<byCount].initialize(toSquareProductOf: b)
            v[unchecked: byCount...].initialize(repeating: .zero)
            //=----------------------------------=
            // set (a * x) and (b * y)
            //=----------------------------------=
            self[unchecked: ..<j].initialize(load: Immutable(u[unchecked: ..<axCount]))
            self[unchecked: j...].initialize(load: Immutable(v[unchecked: ..<byCount]))
            //=----------------------------------=
            // add (a * x) and (b * y)
            //=----------------------------------=
            let suffix = self[unchecked: i...]
            suffix.increment(by: Immutable(u[unchecked: ..<axCount])).discard()
            suffix.increment(by: Immutable(v[unchecked: ..<byCount])).discard()
            //=----------------------------------=
            // regions
            //=----------------------------------=
            if  b.compared(to:  a).isNegative {
                Swift.swap(&a, &b)
            }
            //=----------------------------------=
            // set (b - a) mul (y - x)
            //=----------------------------------=
            u[unchecked: ..<b.count].initialize(to: b)
            u[unchecked: ..<b.count].decrement (by: a).discard()
            v.initialize(toSquareProductOf: Immutable(u[unchecked: ..<b.count]))
            //=----------------------------------=
            // sub (b - a) mul (y - x)
            //=----------------------------------=
            suffix.decrement(by: Immutable(v)).discard()
        }
    }
}
