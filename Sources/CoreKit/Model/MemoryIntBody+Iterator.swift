//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Memory Int Body x Iterator
//*============================================================================*

extension MemoryIntBody {
    
    @frozen public struct Iterator: IteratorProtocol {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var _start: UnsafePointer<Element>
        @usableFromInline var _count: IX
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: MemoryIntBody) {
            self._start = base.start
            self._count = base.count
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable public mutating func next() -> Element? {
            if  self._count > 0 {
                let pointee = self._start.pointee
                self._count = self._count - 1
                self._start = self._start.successor()
                return pointee
            }   else {
                return nil
            }
        }
        
        @inlinable public mutating func load<T>(unchecked type: T.Type) -> T where T: SystemsInteger {
            let ratio = IX(MemoryLayout<T>.stride / MemoryLayout<Element>.stride)
            //=--------------------------------------=
            Swift.assert(ratio <= self.count, String.indexOutOfBounds())
            Swift.assert(ratio >= 1, "must not load integers smaller than this type's element")
            //=--------------------------------------=
            let instance = UnsafeRawPointer(self.start).loadUnaligned(as: T.self)
            self._start += ratio.base
            self._count -= ratio
            return instance as T
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
    }
}
