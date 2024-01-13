//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Storage x Collection
//*============================================================================*

extension Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable var count: Swift.Int {
        switch self.mode {
        case .inline: 1
        case .allocation: self.allocation.count
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func append(_ element: Element) {
        self.allocate()
        self.allocation.append(element)
    }
    
    @inlinable mutating func resize(minCount: Int) {
        guard minCount > 1 else { return }
        
        self.allocate()
        self.allocation.reserveCapacity(minCount)
        
        appending: while self.allocation.count < minCount {
            self.allocation.append(0 as Element)
        }
    }
}
