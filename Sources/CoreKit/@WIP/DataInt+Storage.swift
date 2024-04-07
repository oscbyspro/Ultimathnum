//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Storage
//*============================================================================*

@frozen public struct DataIntStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var start: UnsafeRawPointer
    @usableFromInline var count: IX
    @usableFromInline var appendix: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ start: UnsafeRawPointer, count: IX, appendix: Bit) {
        self.start  = start
        self.count  = count
        self.appendix = appendix
    }
}
