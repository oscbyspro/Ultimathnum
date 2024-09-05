//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Namespace
//*============================================================================*

/// A namespace for `Ultimathnum` development.
///
/// - Warning: Do not use this namespace outside of `Ultimathnum` development.
///
@frozen public enum Namespace {
    
    /// A protocol used to manipulate the reduction order.
    ///
    /// See also: Slava Pestov's forum [comment][1].
    ///
    /// [1]: https://forums.swift.org/t/fixedwidth-cannot-build-rewrite-system-for-protocol/64285/7
    ///
    public protocol Foo { }
    
    /// A protocol used to manipulate the reduction order.
    ///
    /// See also: Slava Pestov's forum [comment][1].
    ///
    /// [1]: https://forums.swift.org/t/fixedwidth-cannot-build-rewrite-system-for-protocol/64285/7
    ///
    public protocol Bar { }
    
    //*========================================================================*
    // MARK: * Comparator
    //*========================================================================*
    
    /// A coherent selection of comparison algorithms.
    @usableFromInline internal protocol Comparator {
        
        associatedtype Result
        
        @inline(__always)
        @inlinable func resolve(_ signum: Signum) -> Result
        
        @inline(__always)
        @inlinable func compare<T: BinaryInteger>(_ lhs: borrowing T, to rhs: borrowing T) -> Result
    }
    
    @frozen @usableFromInline internal struct Compare: Comparator {
        @inline(__always)
        @inlinable internal init() { }
        
        @inline(__always)
        @inlinable internal func resolve(_ signum: Signum) -> Signum {
            signum
        }
        
        @inline(__always)
        @inlinable internal func compare<T: BinaryInteger>(_ lhs: borrowing T, to rhs: borrowing T) -> Signum {
            lhs.compared(to: rhs)
        }
    }
    
    @frozen @usableFromInline internal struct IsSame: Comparator {
        @inlinable init() { }
        
        @inline(__always)
        @inlinable internal func resolve(_ signum: Signum) -> Bool {
            signum.isZero
        }
        
        @inline(__always)
        @inlinable internal func compare<T: BinaryInteger>(_ lhs: borrowing T, to rhs: borrowing T) -> Bool {
            lhs == rhs
        }
    }
    
    @frozen @usableFromInline internal struct IsLess: Comparator {
        @inline(__always)
        @inlinable internal init() { }
        
        @inline(__always)
        @inlinable internal func resolve(_ signum: Signum) -> Bool {
            signum.isNegative
        }
        
        @inline(__always)
        @inlinable internal func compare<T: BinaryInteger>(_ lhs: borrowing T, to rhs: borrowing T) -> Bool {
            lhs <  rhs
        }
    }
}
