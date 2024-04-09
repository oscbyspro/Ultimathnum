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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public  static func memoryCanBeRebound<Other>(to type: Other.Type) -> Bool where Other: SystemsInteger {
        //=--------------------------------------=
        let size      = MemoryLayout<Self>.size      % MemoryLayout<Other>.size      == 0
        let stride    = MemoryLayout<Self>.stride    % MemoryLayout<Other>.stride    == 0
        let alignment = MemoryLayout<Self>.alignment % MemoryLayout<Other>.alignment == 0
        //=--------------------------------------=
        return Bool(Bit(size) & Bit(stride) & Bit(alignment))
    }
}
