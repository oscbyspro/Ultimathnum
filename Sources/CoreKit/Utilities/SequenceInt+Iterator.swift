//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sequence Int x Iterator
//*============================================================================*

extension SequenceInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func makeIterator() -> Iterator {
        Iterator(self, from: Int.zero)
    }
    
    //*========================================================================*
    // MARK: * Iterator
    //*========================================================================*
    
    @frozen public struct Iterator: IteratorProtocol {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var instance: SequenceInt
        @usableFromInline var position: SequenceInt.Index
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ instance: SequenceInt, from position: SequenceInt.Index) {
            self.instance = instance
            self.position = position
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public var count: Int {
            self.instance.distance(from: self.position, to: self.instance.endIndex)
        }
        
        @inlinable mutating public func next() -> Element? {
            guard self.position < self.instance.endIndex else {
                return nil
            };  defer {
                self.instance.formIndex(after: &self.position)
            };  return self.instance[self.position] as Element
        }
    }
}
