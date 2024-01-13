//=----------------------------------------------------------------------------=
// This source file is part of the Ultimathnum open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * Storage x Pointers
//*============================================================================*

extension Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func withUnsafeBufferPointer<T>(_ body: (UnsafeBufferPointer<Element>) throws -> T) rethrows -> T {
        switch self.mode {
        case .inline(let payload):
            
            try Swift.withUnsafePointer(to: payload) {
                try body(UnsafeBufferPointer(start: $0, count: 1))
            }
            
        case .allocation:
            
            try self.allocation.withUnsafeBufferPointer(body)
        }
    }
    
    @inlinable mutating func withUnsafeMutableBufferPointer<T>(_ body: (inout UnsafeMutableBufferPointer<Element>) throws -> T) rethrows -> T {
        switch self.mode {
        case .inline(var payload):
            
            try Swift.withUnsafeMutablePointer(to: &payload) {
                var buffer = UnsafeMutableBufferPointer(start: $0, count: 1)
                return try body(&buffer)
            }
            
        case .allocation:
            
            try self.allocation.withUnsafeMutableBufferPointer(body)
        }
    }
}
