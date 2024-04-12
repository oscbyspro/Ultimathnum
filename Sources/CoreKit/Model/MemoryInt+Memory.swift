//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Memory Int x Memory
//*============================================================================*

extension MemoryInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (MemoryInt<Destination>) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        let appendix = self.appendix
        //=--------------------------------------=
        return try self.body.withMemoryRebound(to: Destination.self) {
            try action(MemoryInt<Destination>($0, repeating: appendix))
        }
    }
}

//*============================================================================*
// MARK: * Memory Int x Memory x Body
//*============================================================================*

extension MemoryInt.Body {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryRebound<Destination, Value>(
        to type: Destination.Type,
        perform action: (MemoryInt<Destination>.Body) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Element.elementsCanBeRebound(to: Destination.self))
        //=--------------------------------------=
        let ratio = IX(size: Element.self) / IX(size: Destination.self)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to:  Destination.self, capacity: Int(count)) {
            try action(MemoryInt<Destination>.Body($0, count: count))
        }
    }
}
