//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Memory Int x Iterator
//*============================================================================*

extension MemoryInt {
    
    @frozen public struct Iterator {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public var body: MemoryInt.Body.Iterator
        public let appendix: Bit
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ body: MemoryInt.Body.Iterator, repeating appendix: Bit) {
            self.body = body
            self.appendix = appendix
        }
    }
}

//*============================================================================*
// MARK: * Memory Int x Iterator x Body
//*============================================================================*

extension MemoryInt.Body {
    
    @frozen public struct Iterator: IteratorProtocol {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var _start: UnsafeRawPointer
        @usableFromInline var _count: IX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: MemoryInt.Body) {
            self._start = base.start
            self._count = base.count
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable public var start: UnsafeRawPointer {
            self._start
        }
        
        @inlinable public var count: IX {
            self._count
        }
        
        @inlinable public mutating func next() -> U8? {
            if  self._count > 0 {
                self._count = self._count - 1
                self._start = self._start.successor()
                return self._start.load(as: U8.self)
            }   else {
                return nil
            }
        }
    }
}
