//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * UMN x Bit Sequence
//*============================================================================*

/// ### Development
///
/// It is a special case of 1-bit chunking; consider adding a 1-bit integer.
///
@frozen public struct UMNBitSequence<Base>: RandomAccessCollection where Base: RandomAccessCollection, Base.Element: UMNUnsignedInteger & UMNSystemInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public let base: Base
    public let count: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base) {
        self.base  = base
        self.count = base.count
    }
    
    @inlinable public init(trimming base: Base, isSigned: Bool) {
        let bit = isSigned && (base.last ?? 0) & Base.Element.msb != 0
        let pattern = Base.Element(repeating: bit)
        let zeros = base.reversed().prefix(while:{ $0 == pattern })
        let minor = base.dropLast(zeros.count).last?.count(repeating: bit, direction: .descending) ?? 0
        let droppable = Swift.max(0, zeros.count * IX.bitWidth.stdlib + IX(minor).stdlib - IX(isSigned).stdlib)
        
        self.base  = base
        self.count = base.count - droppable
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Int {
        0
    }
    
    @inlinable public var endIndex: Int {
        self.count
    }
    
    @inlinable public subscript(index: Int) -> Bool {
        precondition(self.indices ~=  index)
        let quotient  = IX(index) &>> IX(Base.Element.bitWidth).count(repeating: false, direction: .ascending)
        let remainder = IX(index) &   IX(Base.Element.bitWidth &- 1)
        let element = self.base[self.base.index(self.base.startIndex, offsetBy: quotient.stdlib)]
        return element &>> Base.Element(truncating: remainder) &  1 == 1
    }
}
