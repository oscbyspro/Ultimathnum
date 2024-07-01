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
@frozen public struct InfiniInt<Source>: BinaryInteger where Source: SystemsInteger {
    
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
    
    @inlinable public static var size: Magnitude {
        Magnitude(unchecked: Storage([], repeating: 1))
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
    
    @inlinable public init(integerLiteral: RootInt.IntegerLiteralType) {
        self = Self.exactly(RootInt(integerLiteral: integerLiteral)).unwrap()
    }
    
    /// Creates a new instance from the given `body` and `appendix`.
    ///
    /// - Note: This is a convenience derived from `init<T>(DataInt<T>)`.
    ///
    @inlinable public init<T>(_ body: borrowing T, repeating appendix: Bit = .zero)
    where T: Sequence, T.Element: SystemsInteger & UnsignedInteger {
        
        let instance = body.withContiguousStorageIfAvailable {
            Self(load: DataInt($0, repeating: appendix)!)
        }
        
        if  let    instance {
            self = instance
        }   else {
            self = ContiguousArray(copy body).withUnsafeBufferPointer {
                Self(load: DataInt($0, repeating: appendix)!)
            }
        }
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
