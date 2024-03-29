//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
    @inlinable public init() throws {
        do  {
            self.i = try Value.exactly(0).get()
            self.a = try Value.exactly(0).get()
            self.b = try Value.exactly(1).get()
        }   catch {
            throw Error.overflow
        }
    }
    
    /// Creates the sequence pair at the given `index`.
    @inlinable public init(_ index: Value) throws {
        try self.init()
        
        let elements = ExchangeInt(index, as: U1.self)
        if  elements.appendix.bit == 1 {
            throw Error.overflow // is negative or infinite
        }
        
        for bit: U1 in elements.succinct().reversed() {
            try self.double()
            
            if  bit == 1 {
                try self.increment()
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
        brr: do {
            let n : Value
            try n = i.plus(Value.exactly(1)).get()
            
            let x : Value
            try x = a.plus(b).get()
            
            self.i = consume n
            self.a = consume x
            Swift.swap(&a, &b)
        }   catch {
            throw Error.overflow
        }
    }
    
    /// Forms the sequence pair at `index - 1`.
    @inlinable public mutating func decrement() throws {
        if  try i == Value.exactly(0).get() {
            throw Error.overflow
        }
        
        brr: do {
            let n : Value
            try n = i.minus(Value.exactly(1)).get()
            
            let y : Value
            try y = b.minus(a).get()
            
            self.i = consume n
            self.b = consume y
            Swift.swap(&a, &b)
        }   catch {
            throw Error.overflow
        }
    }
    
    /// Forms the sequence pair at `index * 2`.
    @inlinable public mutating func double() throws {
        if  try i == Value.exactly(0).get() {
            return
        }
        
        brr: do {
            let n : Value
            try n = i.times(Value.exactly(2)).get()
            
            var x : Value
            try x = b.times(Value.exactly(2)).get()
            try x = x.minus(a).get()
            try x = x.times(a).get()
            
            var y : Value
            try y = b.squared().plus(a.squared()).get()
            
            self.i = consume n
            self.a = consume x
            self.b = consume y
        }   catch {
            throw Error.overflow
        }
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
