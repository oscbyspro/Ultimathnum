//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Disjoint Data Int
//*============================================================================*

@frozen public struct DisjointDataInt<Element> where Element: SystemsInteger & UnsignedInteger {
    
    public typealias Element = Element
    
    @usableFromInline typealias Storage = DisjointDataIntStorage
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ base: Storage) {
        self.storage = base
    }
    
    @inlinable public init(_ start: UnsafeRawPointer, major: IX, minor: IX, appendix: Bit) {
        self.init(DisjointDataIntStorage(start, major: major, minor: minor, appendix: appendix))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var start: UnsafeRawPointer {
        self.storage.start
    }
    
    @inlinable public var major: IX {
        self.storage.major
    }
    
    @inlinable public var minor: IX {
        self.storage.minor
    }
    
    @inlinable public var appendix: Bit {
        self.storage.appendix
    }
}
