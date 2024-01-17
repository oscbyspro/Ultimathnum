//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Core Int x Words
//*============================================================================*

extension CoreInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(load source: consuming UX) {
        self.init(Base(truncatingIfNeeded: UInt(bitPattern: source)))
    }
    
    @inlinable public func load(as type: UX.Type) -> UX {
        UX(bitPattern: UInt(truncatingIfNeeded: self.base))
    }
    
    @inlinable public init(load source: Pattern<some RandomAccessCollection<UX>>) {
        if  Self.bitWidth <= Magnitude(load: UX(bitPattern: Swift.UInt.bitWidth)) {
            self.init(load:  source.load(as: UX.self))
        }   else {
            let minus = source.isLessThanZero
            self.init(repeating: Bit(minus))
            var bitIndex: Self = 0000000000000000000000000000000
            let bitWidth: Self = Self(bitPattern: Self.bitWidth)
            var index = source.base.startIndex;  while index < source.base.endIndex, bitIndex < bitWidth {
                let element: UX = source.base[ index]
                index = source.base.index(after: index)
                
                ((self)) = ((self)) ^ Self(load: minus ? ~element : element) &<< bitIndex
                bitIndex = bitIndex + Self(load: UX(bitPattern:   Swift.UInt.bitWidth))
            }
        }
    }
}
