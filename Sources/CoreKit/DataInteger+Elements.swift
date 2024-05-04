//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Integer x Elements
//*============================================================================*

extension DataInteger {
    
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
// MARK: * Data Int x Elements x Body
//*============================================================================*

extension DataIntegerBody {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        Bit.zero
    }
    
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
