//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Allocation
//*============================================================================*

extension UMN {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to a temporary allocation of `1` element.
    @inline(__always) @inlinable public static func withUnsafeTemporaryAllocation<Element, Result>(
    of  type: Element.Type, perform: (UnsafeMutablePointer<Element>) throws -> Result) rethrows -> Result {
        try Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: 1) {
            //=----------------------------------=
            // allocation: count <= $0.count
            //=----------------------------------=
            try perform($0.baseAddress.unsafelyUnwrapped)
        }
    }
    
    /// Grants unsafe access to a temporary allocation of `count` elements.
    @inline(__always) @inlinable public static func withUnsafeTemporaryAllocation<Element, Result>(
    of  type: Element.Type, count: Int, perform: (UnsafeMutableBufferPointer<Element>) throws -> Result) rethrows -> Result {
        try Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: count) {
            //=----------------------------------=
            // allocation: count <= $0.count
            //=----------------------------------=
            try perform(UnsafeMutableBufferPointer(start: $0.baseAddress, count: count))
        }
    }
}