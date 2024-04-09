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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func stream() -> Iterator {
        Iterator(self)
    }
    
    //*========================================================================*
    // MARK: * Iterator
    //*========================================================================*
    
    @frozen public struct Iterator {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        public var body: Body.Iterator
        public let appendix: Bit
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: MemoryInt) {
            self.body = Body.Iterator(base.body)
            self.appendix = base.appendix
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable public consuming func normalized() -> Self {
            let appendix = Element(repeating: self.appendix)
            
            while self.body.count > 0 {
                let lastIndex = self.body._count - 1
                guard self.body.start[Int(lastIndex)] == appendix else { break }
                self.body._count = lastIndex
            }
            
            return self as Self as Self as Self as Self
        }
    }
}
