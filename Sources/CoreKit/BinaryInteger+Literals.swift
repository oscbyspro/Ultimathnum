//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Literals
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a validated instance from the given `source`.
    @inlinable public static func exactly(_ source: borrowing LiteralInt) -> Fallible<Self> {
        //=--------------------------------------=
        // 2024-07-05: StaticBigInt performance
        //=--------------------------------------=
        if  source.entropy() <= IX.size {
            return Self.exactly(IX(raw: source[.zero]))
        }
        //=--------------------------------------=
        return source.withUnsafeBinaryIntegerElements {
            Self.exactly($0, mode: Signedness.signed)
        }
    }
}
