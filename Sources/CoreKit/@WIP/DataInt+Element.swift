//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Element x Storage
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: IX) -> Element {
        if  UX(bitPattern: index) < UX(bitPattern: self.count) {
            return self[unchecked: index]
        }   else {
            return Element(repeating: self.appendix)
        }
    }
    
    @inlinable public subscript(unchecked index: IX) -> Element {
        //=--------------------------------------=
        Swift.assert(index < self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        return self.storage.start.load(fromByteOffset: Int(index), as: Element.self)
    }
}
