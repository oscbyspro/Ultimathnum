//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Bit Extension x Bit
//*============================================================================*

extension BitExtension {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(repeating bit: Bit) {
        self.init(unchecked: Element(repeating: bit))
    }
    
    @inlinable public init<T>(repeating other: consuming BitExtension<T>) {
        let bitCastOrLoad = T.isSigned || UX(bitWidth: Element.self) <= UX(bitWidth: T.self)
        self.init(unchecked: bitCastOrLoad ? Element(load: other.element) : Element(repeating: other.bit))
    }
}
