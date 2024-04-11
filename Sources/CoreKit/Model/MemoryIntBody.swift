//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*========================================================================*
// MARK: * Memory Int Body
//*========================================================================*

@frozen public struct MemoryIntBody<Element> where Element: SystemsInteger & UnsignedInteger {
    
    public typealias Element = Element
    
    //=--------------------------------------------------------------------=
    // MARK: State
    //=--------------------------------------------------------------------=
    
    public var _start: UnsafePointer<Element>
    public var _count: IX
    
    //=--------------------------------------------------------------------=
    // MARK: Initializers
    //=--------------------------------------------------------------------=
    
    @inlinable public init(_ start: UnsafePointer<Element>, count: IX) {
        self._start = start
        self._count = count
    }
    
    @inlinable public init?(_ buffer: UnsafeBufferPointer<Element>) {
        if  let start = buffer.baseAddress {
            self.init(start, count: IX(buffer.count))
        }   else {
            return nil
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var start: UnsafePointer<Element> {
        self._start
    }
    
    @inlinable public var count: IX {
        self._count
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(unchecked index: IX) -> Element {
        //=--------------------------------------=
        Swift.assert(index < self.count, String.indexOutOfBounds())
        //=--------------------------------------=
        return self.start[Int(index)]
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func buffer() -> UnsafeBufferPointer<Element> {
        UnsafeBufferPointer(start: self.start, count: Int(self.count))
    }
    
    @inlinable public borrowing func withMemoryRebound<OtherElement, Value>(
        to type: OtherElement.Type,
        perform action: (MemoryIntBody<OtherElement>) throws -> Value
    )   rethrows -> Value {
        //=--------------------------------------=
        precondition(Self.Element.elementsCanBeRebound(to: OtherElement.self))
        //=--------------------------------------=
        let ratio = IX(MemoryLayout<Self.Element>.stride / MemoryLayout<OtherElement>.stride)
        let count = self.count * ratio
        return try  self.start.withMemoryRebound(to: OtherElement.self, capacity: Int(count)) {
            try action(MemoryIntBody<OtherElement>($0, count: count))
        }
    }
}
