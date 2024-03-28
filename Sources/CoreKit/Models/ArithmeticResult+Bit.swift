//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Arithmetic Result x Bit
//*============================================================================*

extension ArithmeticResult: BitCastable where Value: BitCastable {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming ArithmeticResult<Value.BitPattern>) {
        self.init(Value(bitPattern: bitPattern.value), error: bitPattern.error)
    }
    
    @inlinable public var bitPattern: ArithmeticResult<Value.BitPattern> {
        consuming get {
            ArithmeticResult<Value.BitPattern>(Value.BitPattern(bitPattern: self.value), error: self.error)
        }
    }
}
