//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Infini Int Storage
//*============================================================================*

@frozen @usableFromInline struct InfiniIntStorage<Element> where
Element: SystemsInteger & UnsignedInteger, Element.Element == Element {
    
    @usableFromInline typealias Body = ContiguousArray<Element.Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var body: Body
    
    @usableFromInline var appendix: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable internal init(_ body: consuming Body, repeating appendix: Bit) {
        self.body = body
        self.appendix = appendix
    }
    
    @inlinable internal init(_ element: Element, at index: IX, repeating appendix: Bit) {
        self.body = Body(repeating: 0, count: Swift.Int(index) + 1)
        self.body[Swift.Int(index)] = element
        self.appendix = appendix
    }
}
