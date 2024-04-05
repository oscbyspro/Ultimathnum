//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Floating Point Sign
//*============================================================================*

extension FloatingPointSign: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_  sign: Sign) {
        self.init(bitPattern: sign)
    }
    
    @inlinable public init(bitPattern: Bool) {
        self = bitPattern ? Self.minus : Self.plus
    }
    
    @inlinable public var  bitPattern: Bool  {
        self == Self.minus
    }
}
