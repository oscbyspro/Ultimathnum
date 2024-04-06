//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Signedness
//*============================================================================*

public protocol Signedness {
    
    //=------------------------------------------------------------------------=
    // MARK: Meta Data
    //=------------------------------------------------------------------------=
    
    @inlinable static var isSigned: Bool { get }
}


@frozen public struct IsSigned: Signedness {
    
    @inlinable public static var isSigned: Bool {
        true
    }
}

@frozen public struct IsUnsigned: Signedness {
    
    @inlinable public static var isSigned: Bool {
        false
    }
}
