//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Swift x Bool
//*============================================================================*

extension Bool: BitCastable {
    
    public typealias BitPattern = Self
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ source: consuming Bit) {
        self = source.load(as: Self.self)
    }
    
    @inlinable public init(_ source: consuming Sign) {
        self = source.load(as: Self.self)
    }
}
