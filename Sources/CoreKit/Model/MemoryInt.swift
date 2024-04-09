//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Memory Int
//*============================================================================*

@frozen public struct MemoryInt<Element> where Element: SystemsInteger {
    
    public typealias Body = MemoryIntBody<Element>
    
    public typealias Element = Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
   
    public let body: Body
    public let appendix: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ body: Body, repeating appendix: Bit) {
        self.body = body
        self.appendix = appendix
    }
}
