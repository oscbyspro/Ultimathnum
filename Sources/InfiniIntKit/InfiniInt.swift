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

@frozen public struct InfiniInt<Source>: BinaryInteger where Source: SystemsInteger {
    
    public typealias Element = Source.Element
    
    public typealias IntegerLiteralType = StaticBigInt
    
    public typealias Magnitude = InfiniInt<Source.Magnitude>
    
    public typealias Signitude = InfiniInt<Source.Signitude>
    
    @usableFromInline typealias Storage = InfiniIntStorage<Element.Magnitude>
        
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable public static var mode: Source.Mode {
        Source.mode
    }
    
    @inlinable public static var size: Magnitude {
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
        Swift.assert(storage.isNormal, String.brokenInvariant())
        self.storage = storage
    }
    
    @inlinable init(normalizing storage: consuming Storage) {
        storage.normalize()
        self.init(unchecked: storage)
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
