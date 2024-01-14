//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Bit Int x Words x Signed
//*============================================================================*

extension BitInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: Word) {
        self.init(bitPattern: Bit(source & 1 == 1))
    }
    
    @inlinable public init(load source: Pattern<some RandomAccessCollection<Word>>) {
        self.init(load: source.load(as: Word.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func load(as type: Word.Type) -> Word {
        Word(repeating: self.bitPattern)
    }
}

//*============================================================================*
// MARK: * Bit Int x Words x Unsigned
//*============================================================================*

extension BitInt.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: Word) {
        self.init(bitPattern: Bit(source & 1 == 1))
    }
    
    @inlinable public init(load source: Pattern<some RandomAccessCollection<Word>>) {
        self.init(load: source.load(as: Word.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
        
    @inlinable public func load(as type: Word.Type) -> Word {
        Word(self.bitPattern)
    }
}
