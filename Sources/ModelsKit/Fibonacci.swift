//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import BitIntKit
import CoreKit
import MainIntKit

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
/// ### Development
///
/// - TODO: Make each operation throwing when type errors are introduced.
///
@frozen public struct Fibonacci<Value>: CustomStringConvertible where Value: Integer {
    
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
            i = try Value(exactly: 0 as BitInt.Magnitude)
            a = try Value(exactly: 0 as BitInt.Magnitude)
            b = try Value(exactly: 1 as BitInt.Magnitude)
        }   catch {
            throw Failure.overflow
        }
    }
    
    /// Creates the sequence pair at the given `index`.
    @inlinable public init(_ index: Value) throws {
        try self.init()
        
        brr: do {
            try index.withUnsafeBufferPointer {
                try $0.withMemoryRebound(to: UX.self) {
                    for bit: BitInt.Magnitude in Chunked(normalizing: $0, isSigned: false).reversed() {
                        try  self.double()
                        
                        if  bit == 1 {
                            try self.increment()
                        }
                    }
                }
            }
        }   catch {
            throw Failure.overflow
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
    
    @inlinable public var description: String {
        String(describing: self.element)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the sequence pair at `index + 1`.
    @inlinable public mutating func increment() throws {
        brr: do {
            let n : Value
            try n = i.incremented(by: 1)
            
            let x : Value
            try x = a.incremented(by: b)
            
            self.i = consume n
            self.a = consume x
            Swift.swap(&a, &b)
        }   catch {
            throw Failure.overflow
        }
    }
    
    /// Forms the sequence pair at `index - 1`.
    @inlinable public mutating func decrement() throws {
        brr: do {
            let n : Value
            try n = i.decremented(by: 1)
            
            let y : Value
            try y = b.decremented(by: a)
            
            self.i = consume n
            self.b = consume y
            Swift.swap(&a, &b)
        }   catch {
            throw Failure.overflow
        }
    }
    
    /// Forms the sequence pair at `index * 2`.
    @inlinable public mutating func double() throws {
        brr: do {
            let n : Value
            try n = i.multiplied (by: 2)
            
            var x : Value
            try x = b.multiplied (by: 2)
            try x = x.decremented(by: a)
            try x = x.multiplied (by: a)
            
            var y : Value
            try y = b.squared().incremented(by: a.squared())
            
            self.i = consume n
            self.a = consume x
            self.b = consume y
        }   catch {
            throw Failure.overflow
        }
    }
    
    //*========================================================================*
    // MARK: * Failure
    //*========================================================================*
    
    @frozen public enum Failure: Swift.Error {
        case overflow
    }
}
