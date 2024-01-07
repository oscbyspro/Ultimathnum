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

/// The system integer currency.
///
/// Integers of different types can interoperate using a common model.
///
/// ### Swift.UInt
///
/// Ultimathnum cannot access Builtin.Word so it uses Swift.UInt instead.
///
@frozen public struct Word: BitCastable, Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let bitPattern: Swift.UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Swift.UInt) {
        self.bitPattern = bitPattern
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
    
    @inlinable public consuming func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<Self>) throws -> T) rethrows -> T {
        try Swift.withUnsafePointer(to: consume self) { pointer in
            try body(UnsafeBufferPointer(start: pointer, count: 1))
        }
    }
}
