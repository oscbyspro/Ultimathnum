//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Utilities x Literals
//*============================================================================*

extension ExpressibleByArrayLiteral {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// An initializer that helps infer the type of a literal.
    @inlinable public static func infer(_ instance: consuming Self) -> Self {
        instance
    }
    
    /// An initializer that helps infer the type of a literal.
    @inlinable public static func group(_ instance: consuming Self) -> CollectionOfOne<Self> {
        CollectionOfOne(instance)
    }
}
