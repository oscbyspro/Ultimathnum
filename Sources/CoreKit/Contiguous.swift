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
/// ### Banned: DataInteger and BinaryInteger
///
/// A binary integer's bit pattern extends forever, so it cannot be represented
/// as a contiguous sequence on a finite machine. Why does this matter? Imagine
/// the following method and consider why the body must not be a binary integer.
///
/// ```swift
/// extension BinaryInteger {
///     // Returns the bit pattern of `body` and `appendix` that fits.
///     @inlinable public init<Body: Contiguous>(
///         load body: borrowing Body,
///         repeating appendix: Bit = .zero
///     )   where Body.Element: SystemsInteger & UnsignedInteger {
///         self = body.withUnsafeBufferPointer {
///             Self(load: DataInt($0, repeating: appendix)!)
///         }
///     }
/// }
/// ```
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
