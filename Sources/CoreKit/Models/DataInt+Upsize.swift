//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Upsize x Read
//*============================================================================*

extension DataInt<U8> {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the least significant bit pattern that fits in the given type,
    /// then rebases `self` such that it starts at the end of this bit pattern.
    @inlinable public mutating func next<Destination>(
        as destination: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        defer {
            self = self[UX(raw: MemoryLayout<Destination>.stride)...]
        }
        
        return self.load(as: Destination.self)
    }
    
    /// Returns the least significant bit pattern that fits in the given type.
    @inlinable public borrowing func load<Destination>(
        as destination: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        if  IX(MemoryLayout<Destination>.size) <= self.body.count {
            return UnsafeRawPointer(self.body.start).loadUnaligned(as: Destination.self)
            
        }   else if IX(MemoryLayout<Destination>.size) == 1 {
            return Destination(repeating: self.appendix)
            
        }   else {
            var index = self.body.count
            var value = Destination(repeating: self.appendix)
            
            while index  > 0 as IX {
                index  &-= 1 as IX
                value &<<= 8 as Destination
                value   |= Destination(load: self.body[unchecked: index])
            }
            
            return value
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Upsize x Read|Write
//*============================================================================*

extension MutableDataInt<U8> {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the least significant bit pattern that fits in the given type,
    /// then rebases `self` such that it starts at the end of this bit pattern.
    @inlinable public mutating func next<Destination>(
        as destination: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        var immutable = Immutable.init(self)

        defer {
            self = Self(mutating: immutable)
        }
        
        return immutable.next(as: Destination.self)
    }
    
    /// Returns the least significant bit pattern that fits in the given type.
    @inlinable public borrowing func load<Destination>(
        as destination: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        Immutable(self).load(as: Destination.self)
    }
}

//*============================================================================*
// MARK: * Data Int x Upsize x Read|Body
//*============================================================================*

extension DataInt<U8>.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count<Destination>(
        as type: Destination.Type
    )   -> IX where Destination: SystemsInteger & UnsignedInteger {
        
        var count = UX(raw: self.count)
        count   &+= UX(raw: MemoryLayout<Destination>.stride).minus(1).unchecked()
        count  &>>= UX(raw: MemoryLayout<Destination>.stride).count(.ascending(.zero))
        return IX(raw: count)
    }
}

//*============================================================================*
// MARK: * Data Int x Upsize x Read|Write|Body
//*============================================================================*

extension MutableDataInt<U8>.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func count<Destination>(
        as type: Destination.Type
    )   -> IX where Destination: SystemsInteger & UnsignedInteger {
        
        Immutable(self).count(as: Destination.self)
    }
}
