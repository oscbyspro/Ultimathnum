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

/// A binary integer `body` and `appendix` view.
@frozen public struct DataInt<Element>: BitCountable, Recoverable where Element: SystemsInteger & UnsignedInteger {
        
    public typealias Element = Element
        
    public typealias Mutable = MutableDataInt<Element>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=
    
    /// The maximum number of elements in its `body`.
    ///
    /// - Note: Its `entropy` must not exceed `IX.max`.
    ///
    @inlinable public static var capacity: IX {
        IX.max.decremented().quotient(Nonzero(size: Element.self)).unchecked()
    }
    
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
    /// - Important: Its operations are finite, unsigned, and unchecked.
    ///
    /// - Important: Its subsequences are rebased instances of this type.
    ///
    @frozen public struct Body: BitCountable, Recoverable {
        
        public typealias Element = DataInt.Element
        
        public typealias Mutable = MutableDataInt<Element>.Body
        
        //=--------------------------------------------------------------------=
        // MARK: Metadata
        //=--------------------------------------------------------------------=

        /// The maximum number of elements in its `body`.
        ///
        /// - Note: Its `entropy` must not exceed `IX.max`.
        ///
        @inlinable public static var capacity: IX {
            DataInt<Element>.capacity
        }
        
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
            Swift.assert(count >= IX.zero, String.brokenInvariant())
            Swift.assert(count <= DataInt<Element>.capacity, String.brokenInvariant())
            
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
        
        @inlinable public consuming func bytes() -> UnsafeRawBufferPointer {
            UnsafeRawBufferPointer(self.buffer())
        }
        
        @inlinable public consuming func buffer() -> UnsafeBufferPointer<Element> {
            UnsafeBufferPointer(start: self.start, count: Int(self.count))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Read|Write
//*============================================================================*

/// A mutable binary integer `body` and `appendix` view.
///
/// ### Updates go through initialization APIs
///
/// A mutable binary integer `body` is always bound to systems integer elements.
/// As a result, it does not differentiate between initialization and updates.
/// All updates go through Swift's initialization APIs, which require that the
/// destination memory is uninitialized or that the pointee is a trivial type.
/// In this case, the latter is always true.
///
@frozen public struct MutableDataInt<Element>: BitCountable, Recoverable where Element: SystemsInteger & UnsignedInteger {
        
    public typealias Element = Element
    
    public typealias Immutable = DataInt<Element>
    
    //=------------------------------------------------------------------------=
    // MARK: Metadata
    //=------------------------------------------------------------------------=

    /// The maximum number of elements in its `body`.
    ///
    /// - Note: Its `entropy` must not exceed `IX.max`.
    ///
    @inlinable public static var capacity: IX {
        Immutable.capacity
    }
    
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
    /// - Important: Its operations are finite, unsigned, and unchecked.
    ///
    /// - Important: Its subsequences are rebased instances of this type.
    ///
    /// ### Updates go through initialization APIs
    ///
    /// A mutable binary integer `body` is always bound to systems integer elements.
    /// As a result, it does not differentiate between initialization and updates.
    /// All updates go through Swift's initialization APIs, which require that the
    /// destination memory is uninitialized or that the pointee is a trivial type.
    /// In this case, the latter is always true.
    ///
    @frozen public struct Body: BitCountable, Recoverable {
        
        public typealias Element = MutableDataInt.Element
        
        public typealias Immutable = DataInt<Element>.Body
        
        //=--------------------------------------------------------------------=
        // MARK: Metadata
        //=--------------------------------------------------------------------=

        /// The maximum number of elements in its `body`.
        ///
        /// - Note: Its `entropy` must not exceed `IX.max`.
        ///
        @inlinable public static var capacity: IX {
            Immutable.capacity
        }
        
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
            Swift.assert(count >= IX.zero, String.brokenInvariant())
            Swift.assert(count <= DataInt<Element>.capacity, String.brokenInvariant())
            
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
        
        @inlinable public consuming func bytes() -> UnsafeMutableRawBufferPointer {
            UnsafeMutableRawBufferPointer(self.buffer())
        }
        
        @inlinable public consuming func buffer() -> UnsafeMutableBufferPointer<Element> {
            UnsafeMutableBufferPointer(start: self.start, count: Int(self.count))
        }
    }
}
