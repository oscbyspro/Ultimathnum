//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
    
    @inlinable public init(literally source: BigIntLiteral) throws {
        try self.init(elements: ExchangeInt(source).reinterpreted(), isSigned: true)
    }

    @inlinable public init(integerLiteral: BigIntLiteral.IntegerLiteralType) {
        try! self.init(literally: BigIntLiteral(integerLiteral: integerLiteral))
    }
}
