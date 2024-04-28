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
    
    public typealias BitPattern = Division<Quotient.BitPattern, Remainder.BitPattern>
        
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(raw source: consuming BitPattern) {
        self.init(
            quotient:  Quotient (raw: source.quotient ),
            remainder: Remainder(raw: source.remainder)
        )
    }
    
    @inlinable public var bitPattern: BitPattern {
        consuming get {
            BitPattern(
                quotient:  Quotient .BitPattern(raw: self.quotient ),
                remainder: Remainder.BitPattern(raw: self.remainder)
            )
        }
    }
}
