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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func drop<Destination>(
        as destination: Destination.Type
    )   -> Self where Destination: SystemsInteger & UnsignedInteger {
        
        (consume self)[UX(raw: MemoryLayout<Destination>.stride)...]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func load<Destination>(
        as destination: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        self.body.load(as: Destination.self, repeating: self.appendix)
    }
}

//*============================================================================*
// MARK: * Data Int x Upsize x Read|Write
//*============================================================================*

extension MutableDataInt<U8> {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func drop<Destination>(
        as destination: Destination.Type
    )   -> Self where Destination: SystemsInteger & UnsignedInteger {
        
        Self(mutating: Immutable(self).drop(as: Destination.self))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func load<Destination>(
        as destination: Destination.Type
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        self.body.load(as: Destination.self, repeating: self.appendix)
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
        count   &+= UX(raw: MemoryLayout<Destination>.stride) &- 1
        count  &>>= UX(raw: MemoryLayout<Destination>.stride).count(.ascending(.zero))
        return IX(raw: count)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func load<Destination>(
        as destination: Destination.Type,
        repeating appendix: Bit = .zero
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        if  IX(MemoryLayout<Destination>.size) <= self.count as IX {
            return UnsafeRawPointer(self.start).loadUnaligned(as: Destination.self)
            
        }   else if IX(MemoryLayout<Destination>.size) == 1 {
            return Destination(repeating: appendix)
            
        }   else {
            var index = self.count
            var value = Destination(repeating: appendix)
            
            while index  > 0 as IX {
                index  &-= 1 as IX
                value &<<= 8 as Destination
                value   |= Destination(load: self[unchecked: index])
            }
            
            return value
        }
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func load<Destination>(
        as destination: Destination.Type,
        repeating appendix: Bit = .zero
    )   -> Destination where Destination: SystemsInteger & UnsignedInteger {
        
        Immutable(self).load(as: Destination.self, repeating: appendix)
    }
}
