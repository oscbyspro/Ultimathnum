//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Binary Integer x Bit
//*============================================================================*

extension BinaryInteger {
 
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// ### Development
    ///
    /// - Note: This method is **important** for performance.
    ///
    @inlinable public init(_ bit: Bit) {
        self = Bool(bitPattern: bit) ?  1 : 0 // TODO: 0 and 1-bit
    }
    
    @inlinable public init(repeating bit: Bit) {
        self = Bool(bitPattern: bit) ? ~0 : 0
    }
}
