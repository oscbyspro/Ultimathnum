//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int
//*============================================================================*

/// An arbitrary un/signed binary integer type.
///
///      InfiniInt<IX>            InfiniInt<UX>
///     ┌───────────────────────┐┌───────────────────────┐
///     │ IXL                   ││ UXL                   │
///     ├─────────────────┬─────┤├─────────────────┬─────┤
///     │ UX............. │ Bit ││ UX............. │ Bit │
///     └─────────────────┴─────┘└─────────────────┴─────┘
///
/// ### Development
///
/// - TODO: Precondition resizing `DataInt<Element>.capacity`.
///
@frozen public struct InfiniInt<Element>: ArbitraryInteger, Namespace.Foo, Namespace.Bar 
where Element: SystemsInteger, Element.Element == Element {
        
    public typealias BitPattern = InfiniInt<Element.Magnitude>
    
    public typealias Magnitude  = InfiniInt<Element.Magnitude>
    
    public typealias Signitude  = InfiniInt<Element.Signitude>
    
    @usableFromInline typealias Storage = InfiniIntStorage<Element.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signedness {
        Element.mode
    }
    
    @inlinable public static var size: Count<IX> {
        Count.infinity
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable internal init(unchecked storage: consuming Storage) {
        Swift.assert(storage.isNormal, String.brokenInvariant())
        self.storage = storage
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral: LiteralInt.IntegerLiteralType) {
        self = Self.exactly(LiteralInt(integerLiteral: integerLiteral)).unwrap()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(unchecked: source.storage)
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        Magnitude(unchecked: self.storage)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Un/signed
//=----------------------------------------------------------------------------=

extension InfiniInt:     EdgyInteger where Element: UnsignedInteger { }
extension InfiniInt:   FiniteInteger where Element:   SignedInteger { }
extension InfiniInt:   SignedInteger where Element:   SignedInteger { }
extension InfiniInt: UnsignedInteger where Element: UnsignedInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

/// An arbitrary signed binary integer type.
public typealias IXL = InfiniInt<IX>

/// An arbitrary unsigned binary integer type.
public typealias UXL = InfiniInt<UX>
