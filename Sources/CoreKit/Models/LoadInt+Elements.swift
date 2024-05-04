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
        if  Self.ratio == 1 {
            return Element(load: self.data[UX.zero])
            
        }   else if Self.ratio < UX(raw: self.data.body.count) {
            return UnsafeRawPointer(self.data.body.start).loadUnaligned(as: Element.self)
            
        }   else {
            var start = IX.zero
            var value = Element.zero
            var shift = Element.zero
            
            while start < UX(raw: self.data.body.count) {
                value = value | Element(load: self.data.body[unchecked: IX(raw: start)]) &<< shift
                shift = shift.plus(8).assert()
                start = start.plus(1).assert()
            }
            
            return value | Element(repeating: self.data.appendix) << Element(raw: shift)
        }
    }
}
