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
// MARK: * Double Int x Elements
//*============================================================================*

extension DoubleInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var appendix: Bit {
        self.storage.high.appendix
    }
    
    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try Swift.withUnsafePointer(to: self) {
            let count = MemoryLayout<Self>.stride / MemoryLayout<Element.Magnitude>.stride
            return try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: count) {
                try action(DataInt.Body($0, count: IX(count)))
            }
        }
    }
    
    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Magnitude>.Body) throws -> T
    )   rethrows -> T {
        
        try Swift.withUnsafeMutablePointer(to: &self) {
            let count = MemoryLayout<Self>.stride / MemoryLayout<Element.Magnitude>.stride
            return try $0.withMemoryRebound(to: Element.Magnitude.self, capacity: count) {
                try action(MutableDataInt.Body($0, count: IX(count)))
            }
        }
    }
}
