//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Storage x Normal
//*============================================================================*

extension Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var isNormal: Bool {
        switch self.mode {
        case .inline: 
            
            return true
            
        case .allocation:
            
            return self.allocation.count == (1 as Int) || self.allocation.last! != (0 as Element)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func normalize() {
        switch self.mode {
        case .inline:
            
            break
            
        case .allocation:
            
            trimming: while self.allocation.count > (1 as Int) && self.allocation.last! == (0 as Element) {
                self.allocation.removeLast()
            }
        }
    }
}

