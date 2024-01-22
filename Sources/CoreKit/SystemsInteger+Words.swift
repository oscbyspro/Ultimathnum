//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Systems Integer x Words
//*============================================================================*

extension SystemsInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public func load<T>(as type: T.Type) -> T where T: BitCastable<UX.BitPattern> {
        T(bitPattern: self.load(as: UX.self))
    }
    
    @inlinable public init<T>(load source: Pattern<T>) {
        if  Self.bitWidth <= Magnitude(load: UX(bitPattern: Swift.UInt.bitWidth)) {
            self.init(load:  source.load(as: UX.self))
        }   else {
            let minus = source.isLessThanZero
            self.init(repeating: Bit(bitPattern: minus))
            var bitIndex: Self = 0000000000000000000000000000000
            let bitWidth: Self = Self(bitPattern: Self.bitWidth)
            var index = source.base.startIndex; while index < source.base.endIndex, bitIndex < bitWidth {
                let element = source.base[index]
                index = source.base.index(after: index)
                
                ((self)) = ((self)) ^ Self(load: minus ? ~element : element) &<< bitIndex
                bitIndex = bitIndex + Self(load: UX(bitPattern: Swift.UInt.bitWidth))
            }
        }
    }
}
