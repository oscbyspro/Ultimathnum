//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Sequence
//*============================================================================*

@frozen public struct BitSequence: NaturallyIndexable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: DataInt<U8>
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: DataInt<U8>) {
        self.base = base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
        
    @inlinable public consuming func nonappendix() throws -> Prefix<Self> {
        self.prefix(self.base.body.count(.nondescending(self.base.appendix)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        self.base.appendix
    }
    
    @inlinable public subscript(index: UX) -> Bit {
        Bit(self.base[index &>> 3] &>> U8(load: index) & (1 as U8) != (0 as U8))
    }
}
