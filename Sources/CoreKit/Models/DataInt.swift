//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Data Int x Read
//*============================================================================*

@frozen public struct DataInt<Element> where Element: SystemsInteger & UnsignedInteger {
        
    public typealias Element = Element
        
    public typealias Mutable = MutableDataInt<Element>
    
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
    
    @inlinable public init?(_ body: UnsafeBufferPointer<Element>, repeating appendix: Bit = .zero) {
        guard let body = Body(body) else { return nil }
        self.init(body, repeating: appendix)
    }
    
    @inlinable public init(_ start: UnsafePointer<Element>, count: IX, repeating appendix: Bit = .zero) {
        self.init(Body(start, count: count), repeating: appendix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ data: Mutable) {
        self.init(data.body, repeating: data.appendix)
    }
    
    @inlinable public init(_ body: Mutable.Body, repeating appendix: Bit = .zero) {
        self.init(Body(body), repeating: appendix)
    }
    
    //*========================================================================*
    // MARK: * Body
    //*========================================================================*
    
    /// A binary integer `body` view.
    ///
    /// - Note: Its operations are `unsigned` and `finite` by default.
    ///
    @frozen public struct Body {
                
        public typealias Element = DataInt.Element
                
        public typealias Mutable = MutableDataInt<Element>.Body
        
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
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ body: Mutable) {
            self.init(UnsafePointer(body.start), count: body.count)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func buffer() -> UnsafeBufferPointer<Element> {
            UnsafeBufferPointer(start: self.start, count: Int(self.count))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Read|Write
//*============================================================================*

@frozen public struct MutableDataInt<Element> where Element: SystemsInteger & UnsignedInteger {
        
    public typealias Element = Element
        
    public typealias Immutable = DataInt<Element>
    
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
    
    @inlinable public init?(_ body: UnsafeMutableBufferPointer<Element>, repeating appendix: Bit = .zero) {
        guard let body = Body(body) else { return nil }
        self.init(body, repeating: appendix)
    }
    
    @inlinable public init(_ start: UnsafeMutablePointer<Element>, count: IX, repeating appendix: Bit = .zero) {
        self.init(Body(start, count: count), repeating: appendix)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(mutating other: Immutable) {
        self.init(Body(mutating: other.body), repeating: other.appendix)
    }
    
    //*========================================================================*
    // MARK: * Body
    //*========================================================================*
    
    /// A mutable binary integer `body` view.
    ///
    /// - Note: Its operations are `unsigned` and `finite` by default.
    ///
    @frozen public struct Body {
                        
        public typealias Element = MutableDataInt.Element
                
        public typealias Immutable = DataInt<Element>.Body
        
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
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(mutating other: Immutable) {
            self.init(UnsafeMutablePointer(mutating: other.start), count: other.count)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func buffer() -> UnsafeMutableBufferPointer<Element> {
            UnsafeMutableBufferPointer(start: self.start, count: Int(self.count))
        }
    }
}
