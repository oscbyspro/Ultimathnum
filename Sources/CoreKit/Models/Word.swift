//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Word
//*============================================================================*

/// The system integer currency type.
///
/// Integers of different types can interoperate using a common model.
///
/// ### Swift.UInt
///
/// Ultimathnum cannot access Builtin.Word so it uses Swift.UInt instead.
///
/// ### Integerless collection abstraction
///
/// You may define a collection abstraction similar to Swift that does not
/// require concrete integer types, which is my justification for adding generic
/// collection conformances to this module. It may look like the following:
///
/// ```swift
/// protocol Collection {
///     associatedtype  Stride:
///     SignedInteger & SystemInteger where
///     Stride.BitPattern == Word
///
///     var count: Stride { get }
/// }
/// ```
///
/// So, when you see `Int` or `UInt` referenced in a collection from this module,
/// you can imagine it being `Stride` or `Stride.Magnitude` instead.
///
@frozen public struct Word: BitCastable, BitOperable, Comparable, ExpressibleByIntegerLiteral, Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let bitPattern: Swift.UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ bit: Bit) {
        self = Bool(bit) ?  1 : 0
    }
    
    @inlinable public init(repeating bit: Bit) {
        self = Bool(bit) ? ~0 : 0
    }
    
    @inlinable public init(bitPattern: consuming Swift.UInt) {
        self.bitPattern = bitPattern
    }
    
    @inlinable public init(integerLiteral: Swift.UInt.IntegerLiteralType) {
        self.bitPattern = Swift.UInt(integerLiteral: integerLiteral)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(operand: consuming Self) -> Self {
        Self(bitPattern: ~operand.bitPattern)
    }
    
    @inlinable public static func &(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern & rhs.bitPattern)
    }
    
    @inlinable public static func |(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern | rhs.bitPattern)
    }
    
    @inlinable public static func ^(lhs: consuming Self, rhs: borrowing Self) -> Self {
        Self(bitPattern: lhs.bitPattern ^ rhs.bitPattern)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func compared(to other: Self) -> Signum {
        self < other ? -1 : self == other ? 0 : 1
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.bitPattern < rhs.bitPattern
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<Self>) throws -> T) rethrows -> T {
        try Swift.withUnsafePointer(to: consume self) { buffer in
            try body(UnsafeBufferPointer(start: buffer, count: 1))
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBufferPointer<T>(_ body: (inout UnsafeMutableBufferPointer<Self>) throws -> T) rethrows -> T {
        try Swift.withUnsafeMutablePointer(to: &self) {
            var buffer = UnsafeMutableBufferPointer(start: $0, count: 1)
            return try body(&buffer)
        }
    }
}
