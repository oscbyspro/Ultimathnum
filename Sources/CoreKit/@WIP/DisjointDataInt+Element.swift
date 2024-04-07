//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Disjoint Data Int x Storage
//*============================================================================*

extension DisjointDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: IX) -> Element {
        if  UX(bitPattern: index) < UX(bitPattern: self.major) {
            return self.majorElement(unchecked: index)
        }   else if index == self.major {
            return self.minorElementOrAppendix()
        }   else {
            return Element(repeating: self.appendix)
        }
    }
    
    @inlinable public func majorElement(unchecked index: IX) -> Element {
        //=--------------------------------------=
        Swift.assert(index < self.major, String.indexOutOfBounds())
        //=--------------------------------------=
        let position = Int(index * IX(MemoryLayout<Element>.stride))
        //=--------------------------------------=
        // unaligned load because upscaled source
        //=--------------------------------------=
        return self.start.loadUnaligned(fromByteOffset: position, as: Element.self)
    }
    
    @inlinable public func minorElementOrAppendix() -> Element {
        //=--------------------------------------=
        Swift.assert(self.minor < IX(MemoryLayout<Element>.stride), String.indexOutOfBounds())
        //=--------------------------------------=
        var offset  = Int(0000 as IX)
        let initial = Int(self.major * IX(MemoryLayout<Element>.stride))
        var element = Element(repeating: self.appendix) &<< Element(load: 8 * UX(bitPattern: self.minor))
        //=--------------------------------------=
        // aligned load because payload is byte
        //=--------------------------------------=
        chunking: while offset < Int(self.minor) {
            let position = initial + offset
            element |= Element(load: self.start.load(fromByteOffset: position, as: U8.self).load(as: UX.self))
            offset  += 1
        }
        
        return element as Element
    }
}
