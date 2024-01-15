//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Normal Int x Subtraction
//*============================================================================*

extension NormalInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public consuming func negated() throws -> Self {
        let overflow: Bool = !self.storage.withUnsafeMutableBufferPointer {
            SUISS.formTwosComplementSubSequence(&$0, increment: true)
        }
        
        if  overflow, self.storage.msb == 0 {
            self.storage.append(Element(repeating: 1))
        }   else {
            self.storage.normalize()
        }
        
        return try Overflow.resolve(consume self, overflow: overflow)
    }
    
    @inlinable public consuming func minus(_ increment: Self) throws -> Self {
        var overflow: Bool = false
        if  increment != 0 {
            self.storage.resize(minCount: increment.storage.count)
            
            overflow = self.storage.withUnsafeMutableBufferPointer { instance in
                increment.storage.withUnsafeBufferPointer { increment in
                    SUISS.decrement(&instance, by: increment).overflow
                }
            }
                        
            if  overflow, self.storage.msb == 0 {
                self.storage.append(Element(repeating: 1))
            }   else {
                self.storage.normalize()
            }
        }
        
        return try Overflow.resolve(consume self, overflow: overflow)
    }
}
