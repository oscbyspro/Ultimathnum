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

/// An infinite un/signed binary integer type.
///
/// ```
///  InfiniInt<IX>            InfiniInt<UX>
/// ┌───────────────────────┐┌───────────────────────┐
/// │ IXL                   ││ UXL                   │
/// ├─────────────────┬─────┤├─────────────────┬─────┤
/// │ UX............. │ Bit ││ UX............. │ Bit │
/// └─────────────────┴─────┘└─────────────────┴─────┘
/// ```
///
/// ### Development
///
/// - TODO: Make it generic over its `Element` type.
///
/// - TODO: Precondition resizing `DataInt<Element>.capacity`.
///
@frozen public struct InfiniInt<Source>: ArbitraryInteger where Source: SystemsInteger {
    
    public typealias Element = Source.Element
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias BitPattern = InfiniInt<Source.Magnitude>
    
    public typealias Magnitude  = InfiniInt<Source.Magnitude>
    
    public typealias Signitude  = InfiniInt<Source.Signitude>
    
    @usableFromInline typealias Storage = InfiniIntStorage<Element.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Signedness {
        Source.mode
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

extension InfiniInt:     EdgyInteger where Source: UnsignedInteger { }
extension InfiniInt:   FiniteInteger where Source:   SignedInteger { }
extension InfiniInt:   SignedInteger where Source:   SignedInteger { }
extension InfiniInt: UnsignedInteger where Source: UnsignedInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

/// An infinite signed binary integer type.
public typealias IXL = InfiniInt<IX>

/// An infinite unsigned binary integer type.
public typealias UXL = InfiniInt<UX>
