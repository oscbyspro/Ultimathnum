//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Contiguous x Mutable
//*============================================================================*

/// A mutable contiguous memory region.
///
/// ### Development
///
/// - TODO: Rework this when buffer views are added to Swift.
///
public protocol MutableContiguous<Element>: Contiguous {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func withUnsafeMutableBufferPointer<T>(_ action: (inout UnsafeMutableBufferPointer<Element>) throws -> T) rethrows -> T
}
