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
        
    public typealias Element = Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
   
    public let body: Body
    
    public let appendix: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ body: Body, repeating appendix: Bit = .zero) {
        self.body = body
        self.appendix = appendix
    }
    
    @inlinable public init?(_ body: UnsafeBufferPointer<Element>, repeating bit: Bit = .zero) {
        guard let body = Body(body) else { return nil }
        self.init(body, repeating: bit)
    }
    
    @inlinable public init(_ start: UnsafePointer<Element>, count: IX, repeating bit: Bit = .zero) {
        self.init(Body(start, count: count), repeating: bit)
    }
    
    //*========================================================================*
    // MARK: * Body
    //*========================================================================*
    
    @frozen public struct Body {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let start: UnsafePointer<Element>
        public let count: IX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init?(_ buffer: UnsafeBufferPointer<Element>) {
            guard let start = buffer.baseAddress else { return nil }
            self.init(start, count: IX(buffer.count))
        }
        
        @inlinable public init(_ start: UnsafePointer<Element>, count: IX) {
            self.start = start
            self.count = count
        }
        
        //=------------------------------------------------------------------------=
        // MARK: Utilities
        //=------------------------------------------------------------------------=
        
        @inlinable public consuming func buffer() -> UnsafeBufferPointer<Element> {
            UnsafeBufferPointer(start: self.start, count: Int(self.count))
        }
    }
}
