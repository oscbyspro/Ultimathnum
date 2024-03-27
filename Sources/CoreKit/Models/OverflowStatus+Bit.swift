//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Overflow Status x Bit
//*============================================================================*

extension OverflowStatus: BitCastable where Value: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming OverflowStatus<Value.BitPattern>) {
        self.init(Value(bitPattern: bitPattern.value), overflow: bitPattern.overflow)
    }
    
    @inlinable public var bitPattern: OverflowStatus<Value.BitPattern> {
        consuming get {
            OverflowStatus<Value.BitPattern>(Value.BitPattern(bitPattern: self.value), overflow: self.overflow)
        }
    }
}
