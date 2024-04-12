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
    
    @inlinable public init(_ body: Body, repeating appendix: Bit = .zero) {
        self._body = body
        self._appendix = appendix
    }
    
    @inlinable public init?(_ body: UnsafeBufferPointer<Element>, repeating bit: Bit = .zero) {
        guard let body = Body(body) else { return nil }
        self.init(body, repeating: bit)
    }
    
    @inlinable public init(_ start: UnsafePointer<Element>, count: IX, repeating bit: Bit = .zero) {
        self.init(Body(start, count: count), repeating: bit)
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
        
        return self
    }

    @inlinable public consuming func drop(_ distance: UX) -> Self {
        self._body = self._body.drop(distance)
        return self
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var body: Body {
        self._body
    }
    
    @inlinable public var appendix: Bit {
        self._appendix
    }
    
    @inlinable public subscript(index: UX) -> Element {
        if  index < UX(bitPattern: self.body.count) {
            return self.body[unchecked: IX(bitPattern: index)]
        }   else {
            return Element(repeating: self.appendix)
        }
    }
}
