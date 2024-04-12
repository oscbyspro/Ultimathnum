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
    
    @inlinable public borrowing func withMemoryRebound<OtherElement, Value>(
        to type: OtherElement.Type,
        perform action: (MemoryInt<OtherElement>) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        let appendix = self.appendix
        //=--------------------------------------=
        return try self.body.withMemoryRebound(to: OtherElement.self) {
            try action(MemoryInt<OtherElement>($0, repeating: appendix))
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
    
    @inlinable public borrowing func withMemoryRebound<OtherElement, Value>(
        to type: OtherElement.Type,
        perform action: (MemoryInt<OtherElement>.Body) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Element.elementsCanBeRebound(to: OtherElement.self))
        //=--------------------------------------=
        let ratio = IX(MemoryLayout<Element>.stride / MemoryLayout<OtherElement>.stride)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to: OtherElement.self, capacity: Int(count)) {
            try action(MemoryInt<OtherElement>.Body($0, count: count))
        }
    }
}
