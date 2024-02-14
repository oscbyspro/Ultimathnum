//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int
//*============================================================================*

/// ### Development
///
/// - TODO: It should be generic over its `Element` type (please send help).
///
@frozen public struct InfiniInt<Base>: BinaryInteger where Base: SystemsInteger {

    public typealias Element = Base.Element
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias Magnitude = InfiniInt<Base.Magnitude>
            
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Element.isSigned
    }
    
    @inlinable public static var bitWidth: Magnitude {
        Magnitude.max
    }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(unchecked storage: consuming Storage) {
        self.storage = storage
        Swift.assert(self.storage.isNormal)
    }
    
    @inlinable init(normalizing storage: consuming Storage) {
        self.storage = storage
        self.storage.normalize()
    }
    
    @inlinable public init(bitPattern: consuming Magnitude) {
        self.init(unchecked: bitPattern.storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitPattern: Magnitude {
        consuming get {
            Magnitude(unchecked: self.storage)
        }
    }
    
    @inlinable public var magnitude: Magnitude {
        consuming get {
            Magnitude(bitPattern: Overflow.ignore({ self.isLessThanZero ? try self.negated() : self }))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Un/signed
//=----------------------------------------------------------------------------=

extension InfiniInt:   SignedInteger where Base:   SignedInteger { }
extension InfiniInt: UnsignedInteger where Base: UnsignedInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias IXL = InfiniInt<IX>
public typealias UXL = InfiniInt<UX>
