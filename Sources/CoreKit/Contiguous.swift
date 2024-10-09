//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Contiguous
//*============================================================================*

/// A contiguous memory region.
///
/// ### Development
///
/// - TODO: Rework this when buffer views are added to Swift.
///
public protocol Contiguous<Element> {
    
    associatedtype Element
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable borrowing func withUnsafeBufferPointer<T>(_ perform: (UnsafeBufferPointer<Element>) throws -> T) rethrows -> T
}
