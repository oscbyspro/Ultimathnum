//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Overflow x Bit
//*============================================================================*

extension Overflow: BitCastable where Value: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Overflow<Value.BitPattern>) {
        self.init(Value(bitPattern: bitPattern.value))
    }
    
    @inlinable public var bitPattern: Overflow<Value.BitPattern> {
        consuming get {
            .init(Value.BitPattern(bitPattern: self.value))
        }
    }
}
