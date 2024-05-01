//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Fibonacci
//*============================================================================*

/// The [Fibonacci sequence](https://en.wikipedia.org/wiki/fibonacci_sequence)\.
///
/// It is represented by an index and two consecutive elements.
///
/// ```swift
/// Fibonacci(0) // (index: 0, element: 0, next: 1)
/// Fibonacci(1) // (index: 1, element: 1, next: 1)
/// Fibonacci(2) // (index: 2, element: 1, next: 2)
/// Fibonacci(3) // (index: 3, element: 2, next: 3)
/// Fibonacci(4) // (index: 4, element: 3, next: 5)
/// Fibonacci(5) // (index: 5, element: 5, next: 8)
/// ```
///
/// ### Fast double-and-add algorithm
///
/// The fast double-and-add algorithm is powered by this observation:
///
/// ```swift
/// f(x + 0 + 1) == f(x) * 0000 + f(x + 1) * 00000001
/// f(x + 1 + 1) == f(x) * 0001 + f(x + 1) * 00000001
/// f(x + 2 + 1) == f(x) * 0001 + f(x + 1) * 00000002
/// f(x + 3 + 1) == f(x) * 0002 + f(x + 1) * 00000003
/// f(x + 4 + 1) == f(x) * 0003 + f(x + 1) * 00000005
/// f(x + 5 + 1) == f(x) * 0005 + f(x + 1) * 00000008
/// f(x + 6 + 1) == f(x) * 0008 + f(x + 1) * 00000013
/// ─────────────────────────────────────────────────
/// f(x + y + 1) == f(x) * f(y) + f(x + 1) * f(y + 1)
/// f(x + x + 1) == f(x) ^ 0002 + f(x + 1) ^ 00000002
/// ```
///
/// ### Un/signed vs Magnitude
///
/// It permits both signed and unsigned values for testing purposes.
///
@frozen public struct Fibonacci<Value> where Value: BinaryInteger {
    
    public enum Error: Swift.Error { case overflow }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var i: Value
    @usableFromInline var a: Value
    @usableFromInline var b: Value
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates the first sequence pair.
    @inlinable public init() {
        self.i = 0
        self.a = 0
        self.b = 1
    }
    
    /// Creates the sequence pair at the given `index`.
    @inlinable public init(_ index: Value) throws {
        if  index.appendix == 1 {
            throw Error.overflow
        }
        
        self.init()
        
        try index.withUnsafeBinaryIntegerElementsAsBytes {
            let x = $0.body.count(.nondescending(.zero))
            for x in (0 ..< x).reversed() {
                try self.double()
                
                if  $0.body[unchecked: x &>> 3] &>> U8(load: x) & 1 != 0 {
                    try self.increment()
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The sequence `index`.
    @inlinable public var index: Value {
        self.i
    }
    
    /// The sequence `element` at `index`.
    @inlinable public var element: Value {
        self.a
    }
    
    /// The sequence `element` at `index + 1`.
    @inlinable public var next: Value {
        self.b
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the sequence pair at `index + 1`.
    @inlinable public mutating func increment() throws {
        let  n = try i.plus(1).prune(Error.overflow)
        let  x = try a.plus(b).prune(Error.overflow)
        
        self.i = consume n
        self.a = b
        self.b = consume x
    }
    
    /// Forms the sequence pair at `index - 1`.
    @inlinable public mutating func decrement() throws {
        let  n = try i.minus(1).prune(Error.overflow)
        let  y = try b.minus(a).prune(Error.overflow)
        
        if  n.isNegative {
            throw Error.overflow
        }
        
        self.i = consume n
        self.b = a
        self.a = consume y
    }
    
    /// Forms the sequence pair at `index * 2`.
    @inlinable public mutating func double() throws {
        let  n = try i.times(2).prune(Error.overflow)
        let  x = try b.times(2).minus(a).times (a).prune(Error.overflow)
        let  y = try b.squared().plus(a.squared()).prune(Error.overflow)

        self.i = consume n
        self.a = consume x
        self.b = consume y
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Description
//=----------------------------------------------------------------------------=

extension Fibonacci: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(describing: self.element)
    }
}
