//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Strict Unsigned Integer x Multiplication x Karatsuba x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension Namespace.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to the [Karatsuba][algorithm] product of `lhs` and `rhs`.
    ///
    ///
    ///            high : z1                low : z0
    ///     ┌───────────┴───────────┬───────────┴───────────┐
    ///     │        x1 * y1        │        x0 * y0        │
    ///     └───────────┬───────────┴───────────┬───────────┘
    ///             add │        x0 * y0        │
    ///                 ├───────────────────────┤
    ///             add │        x1 * y1        │
    ///                 ├───────────────────────┤
    ///             sub │ (x1 - x0) * (y1 - y0) │ : z2
    ///                 └───────────────────────┘
    ///
    ///
    /// - Parameter base: A buffer of size `lhs.count` + `rhs.count`.
    ///
    /// - Important: The `base` must be uninitialized, or its elements must be trivial.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/karatsuba_algorithm
    ///
    /// ### Development
    ///
    /// - TODO: [Swift 5.8](https://github.com/apple/swift-evolution/blob/main/proposals/0370-pointer-family-initialization-improvements.md)
    ///
    @inline(never) @inlinable package static func initializeByKaratsubaAlgorithm<T>(
    _ base: inout Base, to lhs: UnsafeBufferPointer<Base.Element>, times rhs: UnsafeBufferPointer<Base.Element>)
    where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        Swift.assert(base.count == lhs.count + rhs.count, String.indexOutOfBounds())
        //=--------------------------------------=
        let (k0c): Int = Swift.max(lhs.count,  rhs.count)
        let (k1c): Int = k0c &>> 1
        let (k2c): Int = k1c &<< 1
        
        let (x1s, x0s) = SUISS.partitionNoRedundantZeros(lhs, at: k1c)
        let (y1s, y0s) = SUISS.partitionNoRedundantZeros(rhs, at: k1c)
        let (z1c, z0c) = (x1s.count + y1s.count, x0s.count + y0s.count)
        
        Namespace.withUnsafeTemporaryAllocation(of: Base.Element.self, count: 2 * (z0c + z1c)) { buffer in
            var pointer: UnsafeMutablePointer<Base.Element>
            var (index): UnsafeMutableBufferPointer<Base.Element>.Index
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.deinitialize()
            }
            //=----------------------------------=
            // regions
            //=----------------------------------=
            pointer  = buffer.baseAddress! as UnsafeMutablePointer<Base.Element>
            var x0 = UnsafeMutableBufferPointer(start: pointer, count: x0s.count); pointer += x0.count
            var x1 = UnsafeMutableBufferPointer(start: pointer, count: x1s.count); pointer += x1.count
            var y0 = UnsafeMutableBufferPointer(start: pointer, count: y0s.count); pointer += y0.count
            var y1 = UnsafeMutableBufferPointer(start: pointer, count: y1s.count); pointer += y1.count
            var z0 = UnsafeMutableBufferPointer(start: pointer, count: z0c/*--*/); pointer += z0.count
            var z1 = UnsafeMutableBufferPointer(start: pointer, count: z1c/*--*/); pointer += z1.count
            Swift.assert(buffer.baseAddress!.distance(to: pointer) == buffer.count)
            //=----------------------------------=
            // pointee: initialization 1
            //=----------------------------------=
            _ = x0.initialize(fromContentsOf: x0s)
            _ = x1.initialize(fromContentsOf: x1s)
            _ = y0.initialize(fromContentsOf: y0s)
            _ = y1.initialize(fromContentsOf: y1s)
            
            SUISS.initialize(&z0, to: UnsafeBufferPointer(x0), times: UnsafeBufferPointer(y0))
            SUISS.initialize(&z1, to: UnsafeBufferPointer(x1), times: UnsafeBufferPointer(y1))
            
            let xs = SUISS.compare(x1, to: x0) == -1 as Signum
            if  xs {
                Swift.swap(&x0, &x1)
            }
            
            let ys = SUISS.compare(y1, to: y0) == -1 as Signum
            if  ys {
                Swift.swap(&y0, &y1)
            }
            
            SUISS.decrement( &x1, by: UnsafeBufferPointer(x0))
            SUISS.decrement( &y1, by: UnsafeBufferPointer(y0))
            //=----------------------------------=
            // product must fit in combined width
            //=----------------------------------=
            Swift.assert(z1.dropFirst(base[k2c...].count).allSatisfy({ $0 == 000 }))
            z1 = UnsafeMutableBufferPointer(rebasing: z1.prefix(base[k2c...].count))
            //=----------------------------------=
            // pointee: initialization 2
            //=----------------------------------=
            index = base/*---------*/.initialize(fromContentsOf: UnsafeBufferPointer(z0))
            /*-*/   base[index..<k2c].initialize(repeating: 0000000000000000000000000000)
            index = base[  k2c...   ].initialize(fromContentsOf: UnsafeBufferPointer(z1))
            /*-*/   base[index...   ].initialize(repeating: 0000000000000000000000000000)
            //=----------------------------------=
            var slice = UnsafeMutableBufferPointer(rebasing: base[k1c...])
            SUISS.increment(&slice, by: UnsafeBufferPointer(z0))
            SUISS.increment(&slice, by: UnsafeBufferPointer(z1))
            
            z2: do { // reuse z0 and z1 to form z2. pointee is trivial
                z0 = UnsafeMutableBufferPointer(start: z0.baseAddress!, count: x1.count &+ y1.count)
                SUISS.initialize(&(z0), to: UnsafeBufferPointer(x1), times: UnsafeBufferPointer(y1))
            };  if xs == ys {
                SUISS.decrement(&slice, by: UnsafeBufferPointer(z0))
            }   else {
                SUISS.increment(&slice, by: UnsafeBufferPointer(z0))
            }
        }
    }
    
    /// Initializes `base` to the square [Karatsuba][algorithm] product of `elements`.
    ///
    ///
    ///            high : z1                low : z0
    ///     ┌───────────┴───────────┬───────────┴───────────┐
    ///     │        x1 * x1        │        x0 * x0        │
    ///     └───────────┬───────────┴───────────┬───────────┘
    ///             add │        x0 * x0        │
    ///                 ├───────────────────────┤
    ///             add │        x1 * x1        │
    ///                 ├───────────────────────┤
    ///             sub │ (x1 - x0) * (x1 - x0) │ : z2
    ///                 └───────────────────────┘
    ///
    ///
    /// - Parameter base: A buffer of size `2 * elements.count`.
    ///
    /// - Important: The `base` must be uninitialized, or its elements must be trivial.
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/karatsuba_algorithm
    ///
    /// ### Development
    ///
    /// - TODO: Add a test case where `elements` has redundant zeros.
    ///
    @inline(never) @inlinable package static func initializeByKaratsubaAlgorithm<T>(
    _   base: inout Base, toSquareProductOf elements: UnsafeBufferPointer<Base.Element>) where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        Swift.assert(base.count == 2 * elements.count, String.indexOutOfBounds())
        //=--------------------------------------=
        let (k0c): Int = elements.count
        let (k1c): Int = k0c &>> 1
        let (k2c): Int = k1c &<< 1
        
        let (x1s, x0s) = SUISS.partitionNoRedundantZeros(elements, at: k1c)
        let (z1c, z0c) = (2 * x1s.count, 2 * x0s.count)
        
        Namespace.withUnsafeTemporaryAllocation(of: Base.Element.self, count: 3 * (x1s.count + x0s.count)) { buffer in
            var pointer: UnsafeMutablePointer<Base.Element>
            var (index): UnsafeMutableBufferPointer<Base.Element>.Index
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.deinitialize()
            }
            //=----------------------------------=
            // regions
            //=----------------------------------=
            pointer  = buffer.baseAddress! as UnsafeMutablePointer<Base.Element>
            var x0 = UnsafeMutableBufferPointer(start: pointer, count: x0s.count); pointer += x0.count
            var x1 = UnsafeMutableBufferPointer(start: pointer, count: x1s.count); pointer += x1.count
            var z0 = UnsafeMutableBufferPointer(start: pointer, count: z0c/*--*/); pointer += z0.count
            var z1 = UnsafeMutableBufferPointer(start: pointer, count: z1c/*--*/); pointer += z1.count
            Swift.assert(buffer.baseAddress!.distance(to: pointer) == buffer.count)
            //=----------------------------------=
            // pointee: initialization 1
            //=----------------------------------=
            _ = x0.initialize(fromContentsOf: x0s)
            _ = x1.initialize(fromContentsOf: x1s)
            
            SUISS.initialize(&z0, toSquareProductOf: UnsafeBufferPointer(x0))
            SUISS.initialize(&z1, toSquareProductOf: UnsafeBufferPointer(x1))
            
            if  SUISS.compare(x1, to: x0) == -1 as Signum {
                Swift.swap(&x0, &x1)
            }
            
            SUISS.decrement(&x1, by: UnsafeBufferPointer(x0))
            //=----------------------------------=
            // product must fit in combined width
            //=----------------------------------=
            Swift.assert(z1.dropFirst(base[k2c...].count).allSatisfy({ $0 == 000 }))
            z1 = UnsafeMutableBufferPointer(rebasing: z1.prefix(base[k2c...].count))
            //=----------------------------------=
            // pointee: initialization 2
            //=----------------------------------=
            index = base/*---------*/.initialize(fromContentsOf: UnsafeBufferPointer(z0))
            /*-*/   base[index..<k2c].initialize(repeating: 0000000000000000000000000000)
            index = base[  k2c...   ].initialize(fromContentsOf: UnsafeBufferPointer(z1))
            /*-*/   base[index...   ].initialize(repeating: 0000000000000000000000000000)
            //=----------------------------------=
            var slice = UnsafeMutableBufferPointer(rebasing: base[k1c...])
            SUISS.increment(&slice, by: UnsafeBufferPointer(z0))
            SUISS.increment(&slice, by: UnsafeBufferPointer(z1))
            
            z2: do { // reuse z0 and z1 to form z2. pointee is trivial
                z0 = UnsafeMutableBufferPointer(start: z0.baseAddress!, count: x1.count &<< 1)
                SUISS.initialize(&(z0), toSquareProductOf: UnsafeBufferPointer(x1))
                SUISS.decrement(&slice, by:/*-----------*/ UnsafeBufferPointer(z0))
            }
        }
    }
}
