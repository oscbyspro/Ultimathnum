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

/// The Fibonacci [sequence](https://en.wikipedia.org/wiki/fibonacci_sequence)\.
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
/// f(x + 1 + 0) == f(x) * 0000 + f(x + 1) * 00000001
/// f(x + 1 + 1) == f(x) * 0001 + f(x + 1) * 00000001
/// f(x + 1 + 2) == f(x) * 0001 + f(x + 1) * 00000002
/// f(x + 1 + 3) == f(x) * 0002 + f(x + 1) * 00000003
/// f(x + 1 + 4) == f(x) * 0003 + f(x + 1) * 00000005
/// f(x + 1 + 5) == f(x) * 0005 + f(x + 1) * 00000008
/// -------------------------------------------------
/// f(x + 1 + y) == f(x) * f(y) + f(x + 1) * f(y + 1)
/// ```
///
/// Going the other direction is a bit more complicated, but not much:
///
/// ```swift
/// f(x - 0) == + f(x) * 00000001 - f(x + 1) * 0000
/// f(x - 1) == - f(x) * 00000001 + f(x + 1) * 0001
/// f(x - 2) == + f(x) * 00000002 - f(x + 1) * 0001
/// f(x - 3) == - f(x) * 00000003 + f(x + 1) * 0002
/// f(x - 4) == + f(x) * 00000005 - f(x + 1) * 0003
/// f(x - 5) == - f(x) * 00000008 + f(x + 1) * 0005
/// -----------------------------------------------
/// f(x - y) == ± f(x) * f(y + 1) ± f(x + 1) * f(y)
/// ```
///
/// ### Un/signed vs Magnitude
///
/// It permits both signed and unsigned values for testing purposes.
///
@frozen public struct Fibonacci<Value> where Value: BinaryInteger {
    
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
        if  Bool(index.appendix) {
            throw Value.isSigned ? Error.indexOutOfBounds : Error.overflow
        }
        
        self.init()
        
        try index.withUnsafeBinaryIntegerBody(as: U8.self) {
            for i in (0 ..< IX(raw: $0.nondescending(Bit.zero))).reversed() {
                try self.double()
                
                if  $0[unchecked: i &>> 3] &>> U8(load: i) & 1 != 0 {
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
        let ix = try i.plus(1).prune(Error.overflow)
        let bx = try a.plus(b).prune(Error.overflow)
        
        self.i = consume ix
        self.a = b
        self.b = consume bx
    }
    
    /// Forms the sequence pair at `index - 1`.
    @inlinable public mutating func decrement() throws {
        let ix = try i.minus(1).veto({$0.isNegative}).prune(Error.indexOutOfBounds)
        let ax = try b.minus(a).prune(Error.overflow)
        
        self.i = consume ix
        self.b = a
        self.a = consume ax
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the sequence pair at `index * 2`.
    @inlinable public mutating func double() throws {
        let ex = Self.Error.overflow
        let ix = try i.times(2) .prune(ex)
        let ax = try b.times(2) .prune(ex).minus(a).prune(ex).times(a).prune(ex)
        let bx = try b.squared().prune(ex).plus(a.squared().prune(ex)).prune(ex)
        
        self.i = consume ix
        self.a = consume ax
        self.b = consume bx
    }
    
    /// Forms the sequence pair at `index + x.index`.
    @inlinable public mutating func increment(by x: borrowing Self) throws {
        let ex = Self.Error.overflow
        let ix = try i.plus (x.i).prune(ex)
        let ax = try a.times(x.b).plus(b.minus(a).prune(ex).times(x.a).prune(ex)).prune(ex)
        let bx = try b.times(x.b).prune(ex).plus(       (a).times(x.a).prune(ex)).prune(ex)

        self.i = consume ix
        self.a = consume ax
        self.b = consume bx
    }
    
    /// Forms the sequence pair at `index - x.index`.
    @inlinable public mutating func decrement(by x: borrowing Self) throws {
        let ix = try i.minus(x.i).veto({ $0.isNegative }).prune(Error.indexOutOfBounds)
        
        var a0 = b.times(x.a).value
        var a1 = a.times(x.b).value
        var b0 = b.plus(a).value.times(x.a).value
        var b1 = b.times(x.b).value
        
        if  Bool(x.i.lsb) {
            Swift.swap(&a0, &a1)
            Swift.swap(&b0, &b1)
        }
        
        self.i = consume ix
        self.a = a1.minus(a0).value
        self.b = b1.minus(b0).value
    }
    
    //*========================================================================*
    // MARK: * Error
    //*========================================================================*
    
    public enum Error: Swift.Error {
        
        /// Tried to form a sequence pair that cannot be represented.
        case overflow
        
        /// Tried to form a sequence pair at an index less than zero.
        case indexOutOfBounds
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Text
//=----------------------------------------------------------------------------=

extension Fibonacci: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        String(describing: self.element)
    }
}
