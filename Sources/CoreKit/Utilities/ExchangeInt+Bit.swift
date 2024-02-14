//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Exchange Int x Bit
//*============================================================================*

extension ExchangeInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: ExchangeInt<Base, Element.Magnitude>) {
        self.init(bitPattern.base, repeating: Bit.Extension(bitPattern: bitPattern.appendix))
    }
    
    @inlinable public var bitPattern: ExchangeInt<Base, Element.Magnitude> {
        BitPattern(self.base, repeating: Bit.Extension(bitPattern: self.appendix))
    }
}
