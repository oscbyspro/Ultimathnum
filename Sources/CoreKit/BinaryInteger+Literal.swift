//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Literal
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral: BigIntLiteral.IntegerLiteralType) {
        self = Self.exactly(BigIntLiteral(integerLiteral: integerLiteral)).unwrap()        
    }
    
    @inlinable public static func exactly(_ source: consuming BigIntLiteral) -> Fallible<Self> {
        source.withUnsafeBinaryIntegerElements {
            Self.exactly($0, mode: .signed)
        }
    }
}
