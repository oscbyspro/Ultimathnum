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
            //=--------------------------------------=
            Swift.assert(self.count >= IX(MemoryLayout<T>.size), String.indexOutOfBounds())
            //=--------------------------------------=
            let address  = UnsafeRawPointer(self.start)
            self._start +=   (MemoryLayout<T>.size)
            self._count -= IX(MemoryLayout<T>.size)
            return address.loadUnaligned(as: T.self)
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
