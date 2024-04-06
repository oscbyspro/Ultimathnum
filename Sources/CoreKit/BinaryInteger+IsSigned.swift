//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Is Signed
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    /// Indicates whether this type can represent negative values.
    ///
    /// ```
    /// ┌──────┬──────────┬──────┬──────┐
    /// │ type │ isSigned │  min │  max │
    /// ├──────┼──────────┼──────┼──────┤
    /// │ I8   │ true     │ -128 │  127 │
    /// │ U8   │ false    │    0 │  255 │
    /// └──────┴──────────┴──────┴──────┘
    /// ```
    ///
    @inlinable public static var isSigned: Bool {
        Mode.isSigned
    }
}
