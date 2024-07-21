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
        while count > Int.zero {
            Swift.withUnsafeBytes(of: self.next()) {
                start.copyMemory(from: $0.baseAddress!, byteCount: Swift.min($0.count, count))
                start += $0.count
                count -= $0.count
            }
        }
    }
    
    /// Generates more randomness.
    @inlinable public mutating func next<T>(as type: T.Type = T.self) -> T where T: SystemsInteger & UnsignedInteger {
        if  T.size <= Element.size {
            return T(load: self.next())
        }
        
        Swift.assert(IX(size: T.self) % IX(size: Element.self) == IX.zero)
        let ratio  = IX(size: T.self).down(Shift(unchecked: UX(size: Element.self).ascending(Bit.zero)))
        var random = T()
        
        for index  in Range(uncheckedBounds: (IX.zero, ratio)) {
            random |= T(load: self.next()).up(Shift(unchecked: Count(unchecked: IX(size: Element.self) &* index)))
        }
        
        return random
    }
}
