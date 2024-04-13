//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int
//*============================================================================*

@frozen public struct DataInt<Element> where Element: SystemsInteger & UnsignedInteger {
        
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
    
    @inlinable public init(_ canvas: Canvas, repeating appendix: Bit = .zero) {
        self.init(Body(canvas), repeating: appendix)
    }
    
    @inlinable public init?(_ body: UnsafeBufferPointer<Element>, repeating appendix: Bit = .zero) {
        guard let body = Body(body) else { return nil }
        self.init(body, repeating: appendix)
    }
    
    @inlinable public init(_ start: UnsafePointer<Element>, count: IX, repeating appendix: Bit = .zero) {
        self.init(Body(start, count: count), repeating: appendix)
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
        
        @inlinable public init(_ canvas: Canvas) {
            self.start = UnsafePointer(canvas.start)
            self.count = canvas.count
        }
        
        @inlinable public init?(_ buffer: UnsafeBufferPointer<Element>) {
            guard let start = buffer.baseAddress else { return nil }
            self.init(start, count: IX(buffer.count))
        }
        
        @inlinable public init(_ start: UnsafePointer<Element>, count: IX) {
            self.start = start
            self.count = count
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var indices: Range<IX> {
            Range(uncheckedBounds:(0, self.count))
        }
        
        @inlinable public consuming func buffer() -> UnsafeBufferPointer<Element> {
            UnsafeBufferPointer(start: self.start, count: Int(self.count))
        }
    }
    
    //*========================================================================*
    // MARK: * Canvas
    //*========================================================================*
    
    /// It is like `DataInt<Element>.Body` but with write access.
    ///
    /// - Note: Its operations are unsigned unless they state otherwise.
    ///
    @frozen public struct Canvas {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let start: UnsafeMutablePointer<Element>
        public let count: IX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init?(_ buffer: UnsafeMutableBufferPointer<Element>) {
            guard let start = buffer.baseAddress else { return nil }
            self.init(start, count: IX(buffer.count))
        }
        
        @inlinable public init(_ start: UnsafeMutablePointer<Element>, count: IX) {
            self.start = start
            self.count = count
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var indices: Range<IX> {
            Range(uncheckedBounds:(0, self.count))
        }
        
        @inlinable public consuming func buffer() -> UnsafeMutableBufferPointer<Element> {
            UnsafeMutableBufferPointer(start: self.start, count: Int(self.count))
        }
    }
}
