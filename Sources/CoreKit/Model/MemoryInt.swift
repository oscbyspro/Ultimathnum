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

@frozen public struct MemoryInt<Element> where Element: SystemsInteger & UnsignedInteger {
    
    public typealias Body = MemoryIntBody<Element>
    
    public typealias Element = Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
   
    public var _body: Body
    public var _appendix: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ body: Body, repeating appendix: Bit) {
        self._body = body
        self._appendix = appendix
    }
    
    @inlinable public init(_ body: Body, isSigned: Bool) {
        let extensible = Bool(Bit(isSigned) & Bit(body.count > IX.zero))
        let appendix = extensible ? Element.Signitude(bitPattern: body[unchecked: body.count - 1]).appendix : Bit.zero
        self.init(body, repeating: appendix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func normalized() -> Self {
        let appendix = Element(repeating: self.appendix)
        
        while self.body.count > 0 {
            let lastIndex = self._body._count - 1
            guard self.body[unchecked: lastIndex] == appendix else { break }
            self._body._count = lastIndex
        }
        
        return self as Self as Self as Self as Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var body: Body {
        self._body
    }
    
    @inlinable public var appendix: Bit {
        self._appendix
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public borrowing func withMemoryAsBytes<Value>(
        perform action: (MemoryInt<U8>) throws -> Value
    )   rethrows -> Value {

        try self.withMemoryRebound(to: U8.self, perform: action)
    }
    
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
