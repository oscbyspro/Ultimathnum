//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Disjoint Data Int x Storage
//*============================================================================*

@frozen public struct DisjointDataIntStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @usableFromInline var start: UnsafeRawPointer
    @usableFromInline var major: IX
    @usableFromInline var minor: IX
    @usableFromInline var appendix: Bit
    
    //=--------------------------------------------------------------------=
    // MARK: Initializers
    //=--------------------------------------------------------------------=
    
    @inlinable init(_ start: UnsafeRawPointer, major: IX, minor: IX, appendix: Bit) {
        self.start  = start
        self.major  = major
        self.minor  = minor
        self.appendix = appendix
    }
}
