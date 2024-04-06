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

/// ### Development
///
/// - TODO: It should be generic over its `Element` type (please send help).
///
@frozen public struct InfiniInt<Source>: BinaryInteger where Source: SystemsInteger {

    public typealias Element = Source.Element
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias Magnitude = InfiniInt<Source.Magnitude>
        
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var isSigned: Bool {
        Element.isSigned
    }
    
    @inlinable public static var bitWidth: Magnitude {
        Magnitude(repeating: 1)
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
}

//=----------------------------------------------------------------------------=
// MARK: + Un/signed
//=----------------------------------------------------------------------------=

extension InfiniInt:   SignedInteger where Source:   SignedInteger { }
extension InfiniInt: UnsignedInteger where Source: UnsignedInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Aliases
//=----------------------------------------------------------------------------=

public typealias IXL = InfiniInt<IX>
public typealias UXL = InfiniInt<UX>
