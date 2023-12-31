//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Fibonacci
//*============================================================================*

/// The [Fibonacci sequence](https://en.wikipedia.org/wiki/fibonacci_sequence)\.
///
/// It is represented by an index and two consecutive elements.
///
/// ```swift
/// UMNFibonacci(0) // (index: 0, element: 0, next: 1)
/// UMNFibonacci(1) // (index: 1, element: 1, next: 1)
/// UMNFibonacci(2) // (index: 2, element: 1, next: 2)
/// UMNFibonacci(3) // (index: 3, element: 2, next: 3)
/// UMNFibonacci(4) // (index: 4, element: 3, next: 5)
/// UMNFibonacci(5) // (index: 5, element: 5, next: 8)
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
@frozen public struct UMNFibonacci<Integer>: CustomStringConvertible where Integer: UMNUnsigned & UMNBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var i = Integer.zero
    @usableFromInline var a = Integer.one
    @usableFromInline var b = Integer.one
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates the first sequence pair.
    @inlinable public init() { }
    
    /// Creates the sequence pair at the given `index`.
    @inlinable public init(_ index: UX) {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The sequence `index`.
    @inlinable public var index: Integer {
        self.i
    }
    
    /// The sequence `element` at `index`.
    @inlinable public var element: Integer {
        self.a
    }
    
    /// The sequence `element` at `index + 1`.
    @inlinable public var next: Integer {
        self.b
    }
    
    @inlinable public var description: String {
        String(describing: self.element)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the sequence pair at `index + 1`.
    @inlinable public mutating func increment() {
        i = i + 1
        a = a + b
        Swift.swap(&a, &b)
    }
    
    /// Forms the sequence pair at `index - 1`.
    @inlinable public mutating func decrement() {
        i = i - 1
        b = b - a
        Swift.swap(&a, &b)
    }
    
    /// Forms the sequence pair at `index * 2`.
    @inlinable public mutating func double() {
        var x: Integer // f(2 * index + 0)
        x = b * 2
        x = x - a
        x = x * a
        
        var y: Integer // f(2 * index + 1)
        y = a.squared().unwrapped() + b.squared().unwrapped()
        
        i = i * 2
        a = x
        b = y
    }
}
