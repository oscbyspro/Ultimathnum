//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Pattern
//*============================================================================*

/// The integer currency type.
///
/// ### Development
///
/// - Consider helper methods like matches(\_:), etc.
///
@frozen public struct Pattern<Base> where Base: RandomAccessCollection<Word> {
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let base: Base
    public let sign: Word
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base, isSigned: Bool) {
        self.base = base; self.sign = Word(repeating: Bit(isSigned && Swift.Int(bitPattern: base.last ?? 0) < 0))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isLessThanZero: Bool {
        self.sign != (0 as Word)
    }
    
    @inlinable public func load(as type: Word.Type) -> Word {
        self.base.first ?? self.sign
    }
}
