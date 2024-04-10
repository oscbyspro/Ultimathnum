//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Memory
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init<T>(load source: borrowing T) where T: BinaryInteger, BitPattern == UX.BitPattern {
        self = source.load(as: Self.self)
    }
    
    @inlinable public init<T>(load source: borrowing T) where T: BinaryInteger, BitPattern == T.Element.BitPattern {
        self = source.load(as: Self.self)
    }
}
