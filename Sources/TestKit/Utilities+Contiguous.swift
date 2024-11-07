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
// MARK: * Utilities x Contiguous
//*============================================================================*

extension Contiguous where Element: SystemsInteger & UnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    @inlinable public borrowing func withUnsafeBinaryIntegerBody<T>(
        _ action: (DataInt<Element.Element>.Body) throws -> T
    )   rethrows -> T {
        
        try self.withUnsafeBufferPointer {
            try $0.withMemoryRebound(to: Element.Element.self) {
                try action(DataInt.Body($0)!)
            }
        }
    }

    @inlinable public mutating func withUnsafeMutableBinaryIntegerBody<T>(
        _ action: (MutableDataInt<Element.Element>.Body) throws -> T
    )   rethrows -> T where Self: MutableContiguous {
        
        try self.withUnsafeMutableBufferPointer {
            try $0.withMemoryRebound(to: Element.Element.self) {
                try action(MutableDataInt.Body($0)!)
            }
        }
    }
}
