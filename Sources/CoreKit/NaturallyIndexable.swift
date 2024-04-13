//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Naturally Indexable
//*============================================================================*

/// A collection with contiguous indices from `0` through `Index.max`.
///
/// ```swift
/// BigIntLiteral(1337)[000000] // 1337
/// BigIntLiteral(1337)[IX.max] // 0000
/// ```
///
public protocol NaturallyIndexable<Element> {
    
    associatedtype Index: SystemsInteger
    
    associatedtype Element
    
    @inlinable subscript(index: Index) -> Element { get }
}
