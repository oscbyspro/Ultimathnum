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

extension SomeDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: UX) -> Element {
        if  index < UX(raw: self.body.count) {
            return self.body[unchecked: IX(raw: index)]
        }   else {
            return Element(repeating: self.appendix)
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Body
//*============================================================================*

extension SomeDataIntBody {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var isEmpty: Bool {
        self.count == 0
    }
    
    @inlinable public var indices: Range<IX> {
        Range(uncheckedBounds:(0, self.count))
    }
    
    @inlinable public subscript(optional index: IX) -> Optional<Element> {
        if  UX(raw: index) < UX(raw: self.count) {
            return self[unchecked: index]
        }   else {
            return nil
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Read|Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(unchecked index: Void) -> Element {
        //=----------------------------------=
        Swift.assert(00000 <  self.count, String.indexOutOfBounds())
        //=----------------------------------=
        return self.start.pointee
    }
    
    @inlinable public subscript(unchecked index: IX) -> Element {
        //=--------------------------------------=
        Swift.assert(index >= 0000000000, String.indexOutOfBounds())
        Swift.assert(index <  self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        return self.start.advanced(by: Int(index)).pointee
    }
}

//*============================================================================*
// MARK: * Data Int x Element x Read|Write|Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(unchecked index: Void) -> Element {
        nonmutating get {
            //=----------------------------------=
            Swift.assert(00000 <  self.count, String.indexOutOfBounds())
            //=----------------------------------=
            return self.start.pointee
        }
        
        nonmutating set {
            //=----------------------------------=
            Swift.assert(00000 <  self.count, String.indexOutOfBounds())
            //=----------------------------------=
            // note that the pointee is trivial
            //=----------------------------------=
            return self.start.initialize(to: newValue)
        }
    }
    
    @inlinable public subscript(unchecked index: IX) -> Element {
        nonmutating get {
            //=----------------------------------=
            Swift.assert(index >= 0000000000, String.indexOutOfBounds())
            Swift.assert(index <  self.count, String.indexOutOfBounds())
            //=----------------------------------=
            return self.start.advanced(by: Int(index)).pointee
        }
        
        nonmutating set {
            //=----------------------------------=
            Swift.assert(index >= 0000000000, String.indexOutOfBounds())
            Swift.assert(index <  self.count, String.indexOutOfBounds())
            //=----------------------------------=
            // note that the pointee is trivial
            //=----------------------------------=
            return self.start.advanced(by: Int(index)).initialize(to: newValue)
        }
    }
}