//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c)  2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import CoreKit

//*============================================================================*
// MARK: * Utilities x Text x Binary Integer
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func debug() -> String {
        self.withUnsafeBinaryIntegerElements { data in
            var capacity = Swift.Int(data.body.size().natural().unwrap())
            
            if  Self.isArbitrary {
                capacity += 4 // ...X
            }
            
            Swift.assert((capacity >= 4))
            return String(unsafeUninitializedCapacity: capacity) { ascii in
                var pointer = ascii.baseAddress.unchecked()
                for var element in data.body.buffer() {
                    for _ in 0 ..< UX(size: Element.self) {
                        pointer.initialize(to: UInt8(element.lsb.ascii))
                        pointer = pointer.successor()
                        element = element.down(Shift.one)
                    }
                }
                
                if  Self.isArbitrary {
                    pointer.initialize(to: UInt8(ascii: "."))
                    pointer = pointer.successor()
                    pointer.initialize(to: UInt8(ascii: "."))
                    pointer = pointer.successor()
                    pointer.initialize(to: UInt8(ascii: "."))
                    pointer = pointer.successor()
                    pointer.initialize(to: UInt8(data.appendix.ascii))
                    pointer = pointer.successor()
                }
                
                Swift.assert(pointer == ascii.baseAddress!.advanced(by: capacity))
                return capacity
            }
        }
    }
}

//*============================================================================*
// MARK: * Utilities x Text x Bit
//*============================================================================*

extension Bit {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var ascii: U8 {
        U8(Bool(self) ? UInt8(ascii: "1") : UInt8(ascii: "0"))
    }
}
