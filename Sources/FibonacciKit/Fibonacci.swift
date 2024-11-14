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

/// The [Fibonacci][info] sequence.
///
///     F(x) == F(x-1) + F(x-2) where F(0) == 0 and F(1) == 1
///
/// It is represented by two consecutive elements and an index.
///
/// ```swift
/// Fibonacci<I8>(-12) // (nil)
/// Fibonacci<I8>(-11) // (minor:  89, major: -55, index: -11)
/// Fibonacci<I8>(-10) // (minor: -55, major:  34, index: -10)
/// Fibonacci<I8>( -9) // (minor:  34, major: -21, index:  -9)
/// Fibonacci<I8>( -8) // (minor: -21, major:  13, index:  -8)
/// Fibonacci<I8>( -7) // (minor:  13, major:  -8, index:  -7)
/// Fibonacci<I8>( -6) // (minor:  -8, major:   5, index:  -6)
/// Fibonacci<I8>( -5) // (minor:   5, major:  -3, index:  -5)
/// Fibonacci<I8>( -4) // (minor:  -3, major:   2, index:  -4)
/// Fibonacci<I8>( -3) // (minor:   2, major:  -1, index:  -3)
/// Fibonacci<I8>( -2) // (minor:  -1, major:   1, index:  -2)
/// Fibonacci<I8>( -1) // (minor:   1, major:   0, index:  -1)
/// Fibonacci<I8>(  0) // (minor:   0, major:   1, index:   0)
/// Fibonacci<I8>(  1) // (minor:   1, major:   1, index:   1)
/// Fibonacci<I8>(  2) // (minor:   1, major:   2, index:   2)
/// Fibonacci<I8>(  3) // (minor:   2, major:   3, index:   3)
/// Fibonacci<I8>(  4) // (minor:   3, major:   5, index:   4)
/// Fibonacci<I8>(  5) // (minor:   5, major:   8, index:   5)
/// Fibonacci<I8>(  6) // (minor:   8, major:  13, index:   6)
/// Fibonacci<I8>(  7) // (minor:  13, major:  21, index:   7)
/// Fibonacci<I8>(  8) // (minor:  21, major:  34, index:   8)
/// Fibonacci<I8>(  9) // (minor:  34, major:  55, index:   9)
/// Fibonacci<I8>( 10) // (minor:  55, major:  89, index:  10)
/// Fibonacci<I8>( 11) // (nil)
///
/// Fibonacci<U8>( 11) // (minor:  89, major: 144, index:  11)
/// Fibonacci<U8>( 12) // (minor: 144, major: 233, index:  12)
/// Fibonacci<U8>( 13) // (nil)
/// ```
///
/// [info]: https://en.wikipedia.org/wiki/fibonacci_sequence
///
@frozen public struct Fibonacci<Element>: CustomStringConvertible, Hashable, Sendable where Element: BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var base: Indexacci<Element>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns a new instance at `index` zero.
    @inlinable public init() {
        self.base = Indexacci.fibonacci()
    }
    
    /// Returns a new instance using the given `components`.
    ///
    /// - Important: The `components` must belong to this sequence.
    ///
    @inlinable public init(unsafe components: consuming Indexacci<Element>) {
        self.base = components
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// The sequence element at `index`.
    @inlinable public var minor: Element {
        _read {
            yield self.base.tuple.minor
        }
    }
    
    /// The sequence element at `index + 1`.
    @inlinable public var major: Element {
        _read {
            yield self.base.tuple.major
        }
    }
    
    /// The sequence `index`.
    @inlinable public var index: Element {
        _read {
            yield self.base.index
        }
    }
    
    /// Returns the `components` of this instance.
    @inlinable public consuming func components() -> Indexacci<Element> {
        self.base
    }
}

//*============================================================================*
// MARK: * Fibonacci x Binary Integer
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the `Fibonacci<Self>` sequence element at `index` and an `error` indicator, or `nil`.
    ///
    /// - Note: It ignores `major` element `error` indicators.
    ///
    /// ### Fibonacci
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `index` is `infinite`.
    ///
    @inlinable public static func fibonacci(_ index: consuming Self) -> Optional<Fallible<Self>> {
        let major = index.isPositive
        if  major {
            index = index.decremented().value
        }
        
        guard let result = Fibonacci.exactly(index, as: Tupleacci.self) else { return nil }
        
        if  major {
            return result.map({ $0.major })
        }   else {
            return result.map({ $0.minor })
        }
    }
    
    /// Returns the `Fibonacci<Self>` sequence element at `index` and an `error` indicator.
    ///
    /// - Note: It ignores `major` element `error` indicators.
    ///
    /// ### Fibonacci
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `index` is `infinite`.
    ///
    @inlinable public static func fibonacci(_ index: consuming Self) -> Fallible<Self> where Self: FiniteInteger {
        (Self.fibonacci(index) as Optional).unchecked()
    }
    
    /// Returns the `Fibonacci<Self>` sequence element at `index`.
    ///
    /// - Note: It ignores `major` element `error` indicators.
    ///
    /// ### Fibonacci
    ///
    /// - Note: The `error` is set if the operation is `lossy`.
    ///
    /// - Note: It produces `nil` if the `index` is `infinite`.
    ///
    @inlinable public static func fibonacci(_ index: consuming Self) -> Self where Self: ArbitraryInteger & SignedInteger {
        (Self.fibonacci(index) as Fallible).unchecked()
    }    
}
