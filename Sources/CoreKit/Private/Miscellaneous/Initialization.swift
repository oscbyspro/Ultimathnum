//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Initialization
//*============================================================================*

extension Namespace {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to `source` then returns the initialized `count`.
    @inlinable public static func initializeGetCount<T: SystemInteger>(
    _   base: UnsafeMutablePointer<T>, to source: UnsafeBufferPointer<T>) -> Int {
        base.initialize(from: source.baseAddress!, count: source.count)
        return source.count as Int
    }
    
    /// Initializes `base` to `source` then returns the initialized `count`.
    @inlinable public static func initializeGetCount<T: SystemInteger>(
    _   base: UnsafeMutablePointer<T>, repeating element: T, count: Int) -> Int {
        base.initialize(repeating: element, count: count)
        return count as Int
    }
}
