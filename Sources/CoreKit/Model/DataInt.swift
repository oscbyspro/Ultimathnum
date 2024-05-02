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

public protocol SomeDataInt<Element> {
    
    associatedtype Body: SomeDataIntBody<Element>
    
    associatedtype Element: SystemsInteger & UnsignedInteger
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=

    @inlinable var body: Body { get }
    
    @inlinable var appendix: Bit { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ start: Body, repeating appendix: Bit)
}

//*============================================================================*
// MARK: * Data Int x Body
//*============================================================================*

public protocol SomeDataIntBody<Element> {
    
    associatedtype Address: Strideable<Int>
    
    associatedtype Buffer: RandomAccessCollection<Element>
    
    associatedtype Element: SystemsInteger & UnsignedInteger
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @inlinable var start: Address { get }
    
    @inlinable var count: IX { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
        
    @inlinable init?(_ buffer: Buffer)
    
    @inlinable init(_ start: Address, count: IX)
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable consuming func buffer() -> Buffer
    
    @inlinable consuming func reader() -> DataInt<Element>.Body
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(unchecked index:   IX) -> Element { get }
    
    @inlinable subscript(unchecked index: Void) -> Element { get }
}

//*============================================================================*
// MARK: * Data Int x Read
//*============================================================================*

@frozen public struct DataInt<Element>: SomeDataInt where Element: SystemsInteger & UnsignedInteger {
        
    public typealias Element = Element
    
    public typealias Index = IX
    
    public typealias Mutable = MutableDataInt<Element>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
   
    public let body: Body
    
    public let appendix: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ data: some SomeDataInt<Element>) {
        self.init(data.body, repeating: data.appendix)
    }
    
    @inlinable public init(_ body: some SomeDataIntBody<Element>, repeating appendix: Bit = .zero) {
        self.body = body.reader()
        self.appendix = appendix
    }
    
    //*========================================================================*
    // MARK: * Body
    //*========================================================================*
    
    /// A binary integer `body` view.
    ///
    /// - Note: Its operations are `unsigned` and `finite` by default.
    ///
    @frozen public struct Body: SomeDataIntBody {
        
        public typealias Address = UnsafePointer<Element>
        
        public typealias Buffer = UnsafeBufferPointer<Element>
        
        public typealias Element = DataInt.Element
        
        public typealias Index = DataInt.Index
        
        public typealias Mutable = MutableDataInt<Element>.Body
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let start: Address
        public let count: IX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ body: Mutable) {
            self = body.reader()
        }
        
        @inlinable public init?(_ buffer: Buffer) {
            guard let start = buffer.baseAddress else { return nil }
            self.init(start, count: IX(buffer.count))
        }
        
        @inlinable public init(_ start: Address, count: IX) {
            self.start = start
            self.count = count
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func reader() -> DataInt<Element>.Body {
            self
        }
        
        @inlinable public consuming func buffer() -> Buffer {
            Buffer(start: self.start, count: Int(self.count))
        }
    }
}

//*============================================================================*
// MARK: * Data Int x Read|Write
//*============================================================================*

@frozen public struct MutableDataInt<Element>: SomeDataInt where Element: SystemsInteger & UnsignedInteger {
        
    public typealias Element = Element
    
    public typealias Index = IX
    
    public typealias Immutable = DataInt<Element>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
   
    public let body: Body
    
    public let appendix: Bit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(mutating other: Immutable) {
        self.init(Body(mutating: other.body), repeating: other.appendix)
    }
    
    @inlinable public init(_ body: Body, repeating appendix: Bit = .zero) {
        self.body = body
        self.appendix = appendix
    }
    
    //*========================================================================*
    // MARK: * Body
    //*========================================================================*
    
    /// A mutable binary integer `body` view.
    ///
    /// - Note: Its operations are `unsigned` and `finite` by default.
    ///
    @frozen public struct Body: Functional, SomeDataIntBody {
        
        public typealias Address = UnsafeMutablePointer<Element>
        
        public typealias Buffer = UnsafeMutableBufferPointer<Element>
                
        public typealias Element = MutableDataInt.Element
        
        public typealias Index = MutableDataInt.Index
        
        public typealias Immutable = DataInt<Element>.Body
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public let start: Address
        public let count: IX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init?(_ buffer: Buffer) {
            guard let start = buffer.baseAddress else { return nil }
            self.init(start, count: IX(buffer.count))
        }
        
        @inlinable public init(_ start: Address, count: IX) {
            self.start = start
            self.count = count
        }
        
        @inlinable public init(mutating other: Immutable) {
            self.init(Address(mutating: other.start), count: other.count)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func reader() -> DataInt<Element>.Body {
            Immutable(Immutable.Address(self.start), count: self.count)
        }
        
        @inlinable public consuming func buffer() -> Buffer {
            Buffer(start: self.start, count: Int(self.count))
        }
    }
}
