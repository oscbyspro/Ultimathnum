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
        
        public var body: Body.Iterator
        public let appendix: Bit
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(_ base: MemoryInt) {
            self.body = Body.Iterator(base.body)
            self.appendix = base.appendix
        }
    }
}
