//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Allocation
//*============================================================================*

extension Namespace {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Grants unsafe access to a temporary allocation of `count` elements.
    @inlinable public static func withUnsafeTemporaryAllocation<Element, Result>(
    of  type: Element.Type, count: Int, perform: (UnsafeMutableBufferPointer<Element>) throws -> Result) rethrows -> Result {
        try Swift.withUnsafeTemporaryAllocation(of: Element.self, capacity: count) {
            //=----------------------------------=
            // allocation: count <= $0.count
            //=----------------------------------=
            try perform(UnsafeMutableBufferPointer(start: $0.baseAddress, count: count))
        }
    }
    
    /// Copies the elements of the given `collection` to a temporary allocation of `collection.count` elements.
    ///
    /// - Requires: The pointee type must be trivial.
    ///
    @inlinable public static func withUnsafeTemporaryAllocation<Element, Result>(
    copying collection: some Collection<Element>, perform: (UnsafeMutableBufferPointer<Element>) throws -> Result) rethrows -> Result {
        try Namespace.withUnsafeTemporaryAllocation(of: Element.self, count: collection.count) { buffer in
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            _ = buffer.initialize(fromContentsOf: collection)
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.deinitialize()
            }
            
            return try perform(buffer) as Result
        }
    }
}
