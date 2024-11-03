//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Randomenss
//*============================================================================*

/// A source of uniformly distributed random data.
///
/// ### Development
///
/// - TODO: Consider `MutableDataInt<U8>.Body` vs `UnsafeMutableRawBufferPointer`.
///
public protocol Randomness {
    
    associatedtype Element: SystemsInteger & UnsignedInteger where Element.Element == Element
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Generates more random data.
    @inlinable mutating func next() -> Element
    
    /// Generates enough random data to fill the given `buffer`.
    @inlinable mutating func fill(_ buffer: UnsafeMutableRawBufferPointer)
}
