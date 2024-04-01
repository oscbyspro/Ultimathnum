//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Division x Bit
//*============================================================================*

extension Division: BitCastable where Quotient: BitCastable, Remainder: BitCastable {
        
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: consuming Division<Quotient.BitPattern, Remainder.BitPattern>) {
        self.init(
            quotient:  Quotient (bitPattern: bitPattern.quotient ),
            remainder: Remainder(bitPattern: bitPattern.remainder)
        )
    }
    
    @inlinable public var bitPattern: Division<Quotient.BitPattern, Remainder.BitPattern> {
        consuming get {
            Division<Quotient.BitPattern, Remainder.BitPattern>(
                quotient:  Quotient .BitPattern(bitPattern: self.quotient ),
                remainder: Remainder.BitPattern(bitPattern: self.remainder)
            )
        }
    }
}
