//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Randomness x Full
//*============================================================================*

extension Randomness {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func fill(_ buffer: UnsafeMutableRawBufferPointer) {
        guard var start = buffer.baseAddress else { return }
        
        var count = buffer.count
        while count > Swift.Int.zero {
            Swift.withUnsafeBytes(of: self.next()) {
                let clamped: Swift.Int = Swift.min($0.count, count)
                start.copyMemory(from: $0.baseAddress!, byteCount: clamped)
                start  += clamped
                count &-= clamped
            }
        }
        
        Swift.assert(count == Swift.Int.zero)
    }
    
    /// Generates more randomness.
    @inlinable public mutating func next<T>(as type: T.Type = T.self) -> T where T: SystemsInteger & UnsignedInteger {
        self.systems(as: T.self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension Randomness {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Generates more randomness.
    ///
    /// - Requires: The given `type` must be a systems integer.
    ///
    @inlinable internal mutating func systems<T>(as type: T.Type = T.self) -> T where T: UnsignedInteger {        
        if  T.size <= Element.size {
            return T(load: self.next())
        }
        
        Swift.assert(IX(size: T.self)! % IX(size: Element.self) == IX.zero)
        let ratio  = IX(size: T.self)!.down(Shift(unchecked: UX(size: Element.self).ascending(Bit.zero)))
        var random = T()
        
        for index  in Range(uncheckedBounds: (IX.zero, ratio)) {
            random |= T(load: self.next()).up(Shift(unchecked: Count(unchecked: IX(size: Element.self) &* index)))
        }
        
        return random
    }
}
