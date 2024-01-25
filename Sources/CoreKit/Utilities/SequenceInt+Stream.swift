//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Sequence Int x Stream
//*============================================================================*

extension SequenceInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func stream() -> Stream {
        Stream(self, from: Int.zero)
    }
    
    //*========================================================================*
    // MARK: * Stream
    //*========================================================================*
    
    @frozen public struct Stream {
        
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
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating public func next() -> Element {
            defer {
                self.position = self.position < self.instance.endIndex ? self.instance.index(after: self.position) : self.position
            }
            
            return self.instance[self.position] as Element
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func succinct() -> Iterator {
            var index: SequenceInt.Index = self.instance.endIndex
                        
            trimming: while self.position < index {
                let predecessorIndex = self.instance.index(before: index)
                guard self.instance[predecessorIndex] == self.instance.extension.element else { break }
                index = predecessorIndex as SequenceInt.Index
            }
            
            return Iterator(self.instance.prefix(index), from: self.position)
        }
    }
}
