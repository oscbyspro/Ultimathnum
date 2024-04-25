//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Memory
//*============================================================================*

extension SomeDataInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (DataInt<Destination>) throws -> Value
    )   rethrows -> Value {
        
        try self.body.withMemoryRebound(to: Destination.self) {
            try action(DataInt<Destination>($0, repeating: self.appendix))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Memory x Body
//*============================================================================*

extension DataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (DataInt<Destination>.Body) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Element.elementsCanBeRebound(to: Destination.self))
        //=--------------------------------------=
        let ratio = IX(size: Element.self) / IX(size: Destination.self)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to:  Destination.self, capacity: Int(count)) {
            try action(DataInt<Destination>.Body($0,  count: count))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Memory x Read & Write x Body
//*============================================================================*

extension MutableDataInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (DataInt<Destination>.Body) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Element.elementsCanBeRebound(to: Destination.self))
        //=--------------------------------------=
        let ratio = IX(size: Element.self) / IX(size: Destination.self)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to:  Destination.self, capacity: Int(count)) {
            try action(DataInt<Destination>.Body($0,  count: count))
        }
    }
}
