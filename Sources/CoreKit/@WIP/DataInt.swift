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
    
    @usableFromInline typealias Storage = DataIntStorage

    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: consuming Storage) {
        self.storage = base
    }
    
    @inlinable public init(_ start: UnsafeRawPointer, count: IX, appendix: Bit) {
        self.init(Storage(start, count: count, appendix: appendix))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func split<OtherElement>(as type: OtherElement.Type) -> DataInt<OtherElement> {
        //=--------------------------------------=
        precondition(MemoryLayout<Self.Element>.stride % MemoryLayout<OtherElement>.stride == 0)
        //=--------------------------------------=
        self.storage.count *= IX(MemoryLayout<Self.Element>.stride)
        self.storage.count /= IX(MemoryLayout<OtherElement>.stride)
        //=--------------------------------------=
        return DataInt<OtherElement>(self.storage)
    }
    
    @inlinable public consuming func merge<OtherElement>(as type: OtherElement.Type) -> DisjointDataInt<OtherElement> {
        //=--------------------------------------=
        precondition(MemoryLayout<OtherElement>.stride % MemoryLayout<Self.Element>.stride == 0)
        //=--------------------------------------=
        self.storage.count *= IX(MemoryLayout<Self.Element>.stride)
        let remainder = self.count % IX(MemoryLayout<Self.Element>.stride)
        self.storage.count /= IX(MemoryLayout<OtherElement>.stride)
        //=--------------------------------------=
        return DisjointDataInt<OtherElement>(self.start, major: self.count, minor: remainder, appendix: self.appendix)
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var start: UnsafeRawPointer {
        self.storage.start
    }
    
    @inlinable public var count: IX {
        self.storage.count
    }
    
    @inlinable public var appendix: Bit {
        self.storage.appendix
    }
}
