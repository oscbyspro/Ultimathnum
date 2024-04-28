//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Fallible x Bit
//*============================================================================*

extension Fallible: BitCastable where Value: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming Fallible<Value.BitPattern>) {
        self.init(Value(raw: source.value), error: source.error)
    }
    
    @inlinable public var bitPattern: Fallible<Value.BitPattern> {
        consuming get {
            Fallible<Value.BitPattern>(Value.BitPattern(raw: self.value), error: self.error)
        }
    }
}
