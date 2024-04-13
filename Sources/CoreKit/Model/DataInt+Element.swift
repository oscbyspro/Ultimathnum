//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Element
//*============================================================================*

extension DataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: UX) -> Element {
        if  index < UX(bitPattern: self.body.count) {
            return self.body[unchecked: IX(bitPattern: index)]
        }   else {
            return Element(repeating: self.appendix)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(unchecked index: IX) -> Element {
        //=--------------------------------------=
        Swift.assert(index >= 0000000000, String.indexOutOfBounds())
        Swift.assert(index <  self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        return self.start[Int(index)]
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Canvas
//*============================================================================*

extension DataInt.Canvas {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(unchecked index: IX) -> Element {
        nonmutating get {
            //=--------------------------------------=
            Swift.assert(index >= 0000000000, String.indexOutOfBounds())
            Swift.assert(index <  self.count, String.indexOutOfBounds())
            //=--------------------------------------=
            return self.start[Int(index)]
        }
        
        nonmutating set {
            //=--------------------------------------=
            Swift.assert(index >= 0000000000, String.indexOutOfBounds())
            Swift.assert(index <  self.count, String.indexOutOfBounds())
            //=--------------------------------------=
            // note that the pointee must be trivial
            //=--------------------------------------=
            self.start.advanced(by: Int(index)).initialize(to: newValue)
        }
    }
}
