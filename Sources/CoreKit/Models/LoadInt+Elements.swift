//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Load Int x Elements
//*============================================================================*

extension LoadInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func next() -> Element {
        defer { 
            self = self.successor()
        }
        
        return self.load() as Element
    }
    
    @inlinable public borrowing func load() -> Element {
        if  IX(MemoryLayout<Element>.size)  <= self.data.body.count as IX {
            return UnsafeRawPointer(self.data.body.start).loadUnaligned(as: Element.self)
            
        }   else if IX(MemoryLayout<Element>.size) == 1 {
            return Element(repeating: self.appendix)
            
        }   else {
            var start = self.data.body.count
            var value = Element(repeating: self.appendix)
            
            while start  > 0 as IX {
                start  &-= 1 as IX
                value &<<= 8 as Element
                value   |= Element(load: self.data.body[unchecked: start])
            }
            
            return value
        }
    }
}
