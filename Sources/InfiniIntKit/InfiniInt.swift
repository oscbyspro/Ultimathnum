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
    
    @inlinable public static var size: Count {
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
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(unchecked: source.storage)
    }
    
    @inlinable public consuming func load(as type: BitPattern.Type) -> BitPattern {
        Magnitude(unchecked: self.storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral source: StaticBigInt) {
        self.init(raw: Signitude(source))
        precondition(!self.isInfinite, String.overflow())
    }
    
    /// ### Development
    ///
    /// - Note: It is nontrivial because `StaticBigInt` does not point to memory.
    ///
    @inline(never) @inlinable internal init(_ source: StaticBigInt) where Self: SignedInteger {
        let size  = UX(raw:  source.bitWidth)
        if  size <= UX(size: IX.self) {
            self.init(load:  IX(raw: source[Swift.Int.zero]))
            return
        }
        
        let appendix = Bit(source.signum() < Swift.Int.zero)
        let bits  = size.decremented().unchecked()
        let words = Swift.Int(raw: bits.division(Nonzero(size: UX.self)).ceil().unchecked())
        let body  = IXL.Storage.Body(unsafeUninitializedCapacity: words) { body, index in
            
            initialize: while index < words {
                body.initializeElement(at: index, to: UX(source[index]))
                index =  body.index(after: index)
            }
        }
        
        if  Swift.type(of: body) == Storage.Body.self {
            self.init(unchecked: Storage(Swift.unsafeBitCast(body, to: Storage.Body.self), repeating: appendix))
        }   else {
            self.init(load: body, repeating: appendix)
        }
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
